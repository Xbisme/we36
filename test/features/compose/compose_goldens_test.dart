import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/services/image_processing_service.dart';
import 'package:we36/core/services/media_upload_service_fake.dart';
import 'package:we36/core/services/photo_library_service_fake.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/compose/data/compose_draft_store.dart';
import 'package:we36/features/compose/data/create_post_repository_fake.dart';
import 'package:we36/features/compose/domain/models/media_edit_state.dart';
import 'package:we36/features/compose/domain/usecases/publish_post.dart';
import 'package:we36/features/compose/presentation/cubit/compose_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_cubit.dart';
import 'package:we36/features/compose/presentation/pages/caption_page.dart';
import 'package:we36/features/compose/presentation/pages/edit_page.dart';
import 'package:we36/features/compose/presentation/pages/pick_page.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// Golden coverage for the three compose steps (pick / caption / edit) in light +
/// dark (T032 + T039). Uses the deterministic fakes so the grid + preview paint
/// real (solid-colour) bytes with no network — Constitution XII.
class _SyncImageProcessing extends ImageProcessingService {
  const _SyncImageProcessing();
  @override
  Future<Result<Uint8List>> bake({
    required Uint8List source,
    required MediaEditState edit,
    int targetWidth = ImageProcessingService.defaultTargetWidth,
    int quality = ImageProcessingService.defaultQuality,
  }) async => Result.ok(source);
}

void main() {
  late AppDatabase db;
  late GalleryCubit gallery;
  late ComposeCubit compose;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    gallery = GalleryCubit(FakePhotoLibraryService(assetCount: 8));
    compose = ComposeCubit(
      PublishPost(
        FakePhotoLibraryService(),
        const _SyncImageProcessing(),
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

  Widget host(Widget child, ThemeMode mode) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: mode,
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

  /// Pumps under [runAsync] so the fake MemoryImage thumbnails actually decode
  /// and paint before the golden is captured, then settles synchronously.
  Future<void> pumpForGolden(
    WidgetTester tester,
    Widget child,
    ThemeMode mode,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.runAsync(() async {
      await tester.pumpWidget(host(child, mode));
      // Let the engine decode the in-memory JPEG thumbnails.
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 32));
        await Future<void>.delayed(const Duration(milliseconds: 16));
      }
    });
    await tester.pump();
  }

  Future<void> goldenBoth(
    WidgetTester tester,
    String name,
    Future<void> Function() prime,
    Widget child,
  ) async {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      await prime();
      await pumpForGolden(tester, child, mode);
      final suffix = mode == ThemeMode.dark ? 'dark' : 'light';
      await expectLater(
        find.byWidget(child),
        matchesGoldenFile('goldens/${name}_$suffix.png'),
      );
    }
  }

  testWidgets('pick page golden (one selected)', (tester) async {
    const child = PickPage();
    await goldenBoth(
      tester,
      'compose_pick',
      () async {
        await gallery.loadInitial();
        gallery.toggleSelect('fake-asset-0');
      },
      child,
    );
  });

  testWidgets('caption page golden', (tester) async {
    const child = CaptionPage();
    await goldenBoth(
      tester,
      'compose_caption',
      () => compose.startFromAssets(['fake-asset-0']),
      child,
    );
  });

  testWidgets('edit page golden (filters + adjust)', (tester) async {
    const child = EditPage();
    await goldenBoth(
      tester,
      'compose_edit',
      () => compose.startFromAssets(['fake-asset-0']),
      child,
    );
  });
}
