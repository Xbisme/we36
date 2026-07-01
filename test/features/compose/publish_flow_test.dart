import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/services/image_processing_service.dart';
import 'package:we36/core/services/media_upload_service_fake.dart';
import 'package:we36/core/services/photo_library_service_fake.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/compose/data/compose_draft_store.dart';
import 'package:we36/features/compose/data/create_post_repository_fake.dart';
import 'package:we36/features/compose/domain/usecases/publish_post.dart';
import 'package:we36/features/compose/presentation/cubit/compose_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_cubit.dart';
import 'package:we36/features/compose/presentation/pages/caption_page.dart';
import 'package:we36/features/compose/presentation/pages/edit_page.dart';
import 'package:we36/features/compose/presentation/pages/pick_page.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

void main() {
  late AppDatabase db;
  late GalleryCubit gallery;
  late ComposeCubit compose;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    gallery = GalleryCubit(FakePhotoLibraryService(assetCount: 6));
    compose = ComposeCubit(
      PublishPost(
        FakePhotoLibraryService(),
        const ImageProcessingService(),
        FakeMediaUploadService()..stepDelay = Duration.zero,
        FakeCreatePostRepository(db),
      ),
      ComposeDraftStore(db),
      IdempotencyKeys(),
    );
    getIt.registerLazySingleton<ToastService>(ToastService.new);
  });

  tearDown(() async {
    await gallery.close();
    await compose.close();
    await db.close();
    await getIt.reset();
  });

  Widget host() {
    final router = GoRouter(
      initialLocation: '/create/pick',
      routes: [
        ShellRoute(
          builder: (_, _, child) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: gallery),
              BlocProvider.value(value: compose),
            ],
            child: child,
          ),
          routes: [
            GoRoute(path: '/create/pick', builder: (_, _) => const PickPage()),
            GoRoute(path: '/create/edit', builder: (_, _) => const EditPage()),
            GoRoute(
              path: '/create/caption',
              builder: (_, _) => const CaptionPage(),
            ),
          ],
        ),
        GoRoute(
          path: '/home',
          builder: (_, _) => const Scaffold(body: Text('HOME')),
        ),
      ],
    );
    return MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }

  testWidgets('pick → edit → caption → Share publishes to the feed', (tester) async {
    await gallery.loadInitial();
    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    // Grid renders; select the first photo.
    expect(find.byType(Image), findsWidgets);
    await tester.tap(find.byType(Image).first);
    await tester.pumpAndSettle();

    // Next → edit step.
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.byType(EditPage), findsOneWidget);

    // Next → caption step.
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.byType(CaptionPage), findsOneWidget);

    // Share → publish. The bake runs on a real isolate (compute), so let real
    // async complete before settling the navigation.
    await tester.runAsync(() async {
      await tester.tap(find.text('Share'));
      await Future<void>.delayed(const Duration(milliseconds: 400));
    });
    await tester.pumpAndSettle();

    expect(find.text('HOME'), findsOneWidget);
    final feed = await db.postsDao.watchHomeFeed().first;
    expect(feed, hasLength(1));
  });
}
