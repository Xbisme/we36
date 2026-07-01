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
import 'package:we36/features/compose/presentation/widgets/adjust_slider.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

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
    gallery = GalleryCubit(FakePhotoLibraryService());
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

  Widget host(Widget child, {required ThemeMode mode, required double scale}) =>
      MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: mode,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => MediaQuery(
            // Preserve the ambient size; only bump the text scale.
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: gallery),
                BlocProvider.value(value: compose),
              ],
              child: child,
            ),
          ),
        ),
      );

  Future<void> pump(
    WidgetTester tester,
    Widget child,
    ThemeMode mode,
    double scale,
  ) async {
    // Tall surface so large text scales don't overflow the fixed-height panels.
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(host(child, mode: mode, scale: scale));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    final label = mode == ThemeMode.dark ? 'dark' : 'light';

    testWidgets('pick page has semantic cells + large text ($label)', (
      tester,
    ) async {
      await gallery.loadInitial();
      await pump(tester, const PickPage(), mode, 1.5);
      expect(find.bySemanticsLabel('Photo 1'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('edit page tabs + sliders are labelled ($label)', (
      tester,
    ) async {
      await compose.startFromAssets(['fake-asset-0']);
      await pump(tester, const EditPage(), mode, 1.3);
      await tester.tap(find.text('Adjust'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(AdjustSlider), findsNWidgets(3));
      // Sliders expose a Semantics slider node for screen readers.
      expect(find.byType(Slider), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });

    testWidgets('caption page toggle is labelled + scales ($label)', (
      tester,
    ) async {
      await compose.startFromAssets(['fake-asset-0']);
      await pump(tester, const CaptionPage(), mode, 1.3);
      // Both the row text and the switch expose the label to screen readers.
      expect(find.bySemanticsLabel('Turn off commenting'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  }
}
