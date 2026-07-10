import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:we36/app/app.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/router/app_router.dart';
import 'package:we36/core/services/image_processing_service.dart';
import 'package:we36/core/services/media_upload_service_fake.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/services/photo_library_service_fake.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/auth/domain/usecases/sign_in.dart';
import 'package:we36/features/auth/domain/usecases/sign_in_with_apple.dart';
import 'package:we36/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:we36/features/auth/presentation/oauth/oauth_cubit.dart';
import 'package:we36/features/auth/presentation/sign_in/sign_in_cubit.dart';
import 'package:we36/features/auth/presentation/sign_in/sign_in_page.dart';
import 'package:we36/features/compose/data/compose_draft_store.dart';
import 'package:we36/features/compose/data/create_post_repository_fake.dart';
import 'package:we36/features/compose/domain/usecases/publish_post.dart';
import 'package:we36/features/compose/presentation/cubit/compose_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/compose_state.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_cubit.dart';
import 'package:we36/features/compose/presentation/pages/pick_page.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

import '../../helpers/app_settings_double.dart';
import '../../support/auth_test_doubles.dart';

class _MockSignIn extends Mock implements SignIn {}

class _MockGoogle extends Mock implements SignInWithGoogle {}

class _MockApple extends Mock implements SignInWithApple {}

void main() {
  group('permission + media edge cases', () {
    late AppDatabase db;
    late FakePhotoLibraryService library;
    late GalleryCubit gallery;
    late ComposeCubit compose;

    ComposeCubit buildCompose(FakePhotoLibraryService lib) => ComposeCubit(
      PublishPost(
        lib,
        const ImageProcessingService(), // real bake → exercises decode failure
        FakeMediaUploadService()..stepDelay = Duration.zero,
        FakeCreatePostRepository(db),
      ),
      ComposeDraftStore(db),
      IdempotencyKeys(),
    );

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      library = FakePhotoLibraryService(permission: PhotoPermission.denied);
      gallery = GalleryCubit(library);
      compose = buildCompose(FakePhotoLibraryService());
      getIt.registerLazySingleton<ToastService>(ToastService.new);
    });

    tearDown(() async {
      await gallery.close();
      await compose.close();
      await db.close();
      await getIt.reset();
    });

    Widget host(Widget child) => MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: gallery),
          BlocProvider.value(value: compose),
        ],
        child: child,
      ),
    );

    testWidgets(
      'permission denied shows an Open Settings CTA that deep-links',
      (tester) async {
        await gallery.loadInitial(); // denied → GalleryError
        await tester.pumpWidget(host(const PickPage()));
        await tester.pump();

        final cta = find.widgetWithText(AppButton, 'Open Settings');
        expect(cta, findsOneWidget);
        await tester.tap(cta);
        await tester.pump();
        expect(library.openSettingsCalls, 1);
      },
    );

    test(
      'an undecodable source file fails the publish (unsupportedMedia)',
      () async {
        final cubit = buildCompose(
          FakePhotoLibraryService(originDecodable: false),
        );
        await cubit.startFromAssets(['fake-asset-0']);
        await cubit.publish();
        expect(cubit.state, isA<ComposeError>());
        final feed = await db.postsDao.watchHomeFeed().first;
        expect(feed, isEmpty);
        await cubit.close();
      },
    );

    test('offline upload failure keeps the draft for retry', () async {
      final uploader = FakeMediaUploadService()
        ..stepDelay = Duration.zero
        ..failAfterFraction = 0.5;
      final cubit = ComposeCubit(
        PublishPost(
          FakePhotoLibraryService(),
          const ImageProcessingService(),
          uploader,
          FakeCreatePostRepository(db),
        ),
        ComposeDraftStore(db),
        IdempotencyKeys(),
      );
      await cubit.startFromAssets(['fake-asset-0']);
      await cubit.publish();
      expect(cubit.state, isA<ComposeError>());
      expect(cubit.state.draftOrNull, isNotNull); // retryable
      await cubit.close();
    });
  });

  group('auth gating (FR-003)', () {
    testWidgets('unauthenticated → compose route is redirected to sign-in', (
      tester,
    ) async {
      getIt
        ..registerFactory<SignInCubit>(() => SignInCubit(_MockSignIn()))
        ..registerFactory<OAuthCubit>(
          () => OAuthCubit(_MockGoogle(), _MockApple()),
        )
        ..registerLazySingleton<ToastService>(ToastService.new);
      addTearDown(getIt.reset);

      final harness = SessionHarness(onboardingSeen: true); // signed OUT
      addTearDown(harness.dispose);
      await harness.controller.bootstrap();

      final router = AppRouter(harness.controller).router;
      await tester.pumpWidget(
        We36App(router: router, appSettings: testAppSettings()),
      );
      await tester.pumpAndSettle();

      router.go(AppRoutes.composePick);
      await tester.pumpAndSettle();

      // The guard redirected away from compose to the signed-out entry.
      expect(find.byType(PickPage), findsNothing);
      expect(find.byType(SignInPage), findsOneWidget);
    });
  });
}
