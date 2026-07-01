import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/domain/result.dart';
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
import 'package:we36/features/compose/presentation/pages/edit_page.dart';
import 'package:we36/features/compose/presentation/widgets/adjust_slider.dart';
import 'package:we36/features/compose/presentation/widgets/filter_row.dart';
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
  });

  tearDown(() async {
    await gallery.close();
    await compose.close();
    await db.close();
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

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('selecting a filter updates the active edit + preview', (
    tester,
  ) async {
    await compose.startFromAssets(['fake-asset-0']);
    await tester.pumpWidget(host(const EditPage()));
    await settle(tester);

    expect(find.byType(FilterRow), findsOneWidget);
    await tester.tap(find.text('Lux'));
    await settle(tester);

    expect(
      compose.state.draftOrNull!.items.first.edit.filter,
      FilterPreset.lux,
    );
    // The live preview is filtered with the same matrix (a ColorFiltered exists).
    expect(find.byType(ColorFiltered), findsWidgets);
  });

  testWidgets('adjust tab exposes sliders that mutate the edit', (
    tester,
  ) async {
    await compose.startFromAssets(['fake-asset-0']);
    await tester.pumpWidget(host(const EditPage()));
    await settle(tester);

    await tester.tap(find.text('Adjust'));
    await settle(tester);

    expect(find.byType(AdjustSlider), findsNWidgets(3));
    await tester.drag(find.byType(Slider).first, const Offset(60, 0));
    await settle(tester);

    // Dragging right raises brightness above neutral.
    expect(
      compose.state.draftOrNull!.items.first.edit.brightness,
      greaterThan(0),
    );
  });

  testWidgets('crop control passes through to the crop stage', (tester) async {
    await compose.startFromAssets(['fake-asset-0']);
    await tester.pumpWidget(host(const EditPage()));
    await settle(tester);

    // Tap the crop icon (semantic label "Crop").
    await tester.tap(find.bySemanticsLabel('Crop'));
    await settle(tester);

    // The crop stage is showing (bytes still decoding → progress spinner).
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
