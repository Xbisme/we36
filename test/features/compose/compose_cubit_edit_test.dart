import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/services/image_processing_service.dart';
import 'package:we36/core/services/media_upload_service_fake.dart';
import 'package:we36/core/services/photo_library_service_fake.dart';
import 'package:we36/features/compose/data/compose_draft_store.dart';
import 'package:we36/features/compose/data/create_post_repository_fake.dart';
import 'package:we36/features/compose/domain/models/media_edit_state.dart';
import 'package:we36/features/compose/domain/usecases/publish_post.dart';
import 'package:we36/features/compose/presentation/cubit/compose_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/compose_state.dart';

void main() {
  late AppDatabase db;

  ComposeCubit build() {
    final publish = PublishPost(
      FakePhotoLibraryService(),
      const ImageProcessingService(),
      FakeMediaUploadService()..stepDelay = Duration.zero,
      FakeCreatePostRepository(db),
    );
    return ComposeCubit(publish, ComposeDraftStore(db), IdempotencyKeys());
  }

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  MediaEditState editOf(ComposeState state, [int index = 0]) =>
      state.draftOrNull!.items[index].edit;

  blocTest<ComposeCubit, ComposeState>(
    'setFilter updates the active item filter',
    build: build,
    seed: () => const ComposeState.initial(),
    act: (c) async {
      await c.startFromAssets(['a', 'b']);
      c.setFilter(FilterPreset.lux);
    },
    verify: (c) {
      expect(editOf(c.state).filter, FilterPreset.lux);
      // Only the active (index 0) item changed; the other is pristine.
      expect(editOf(c.state, 1).filter, FilterPreset.original);
    },
  );

  blocTest<ComposeCubit, ComposeState>(
    'brightness/contrast/warmth adjustments update the active edit',
    build: build,
    act: (c) async {
      await c.startFromAssets(['a']);
      c
        ..setBrightness(0.4)
        ..setContrast(-0.2)
        ..setWarmth(0.6);
    },
    verify: (c) {
      final edit = editOf(c.state);
      expect(edit.brightness, 0.4);
      expect(edit.contrast, -0.2);
      expect(edit.warmth, 0.6);
    },
  );

  blocTest<ComposeCubit, ComposeState>(
    'setCrop stores a normalized crop rect on the active item',
    build: build,
    act: (c) async {
      await c.startFromAssets(['a']);
      c.setCrop(
        const CropRect(left: 0.1, top: 0.05, width: 0.8, height: 0.9),
      );
    },
    verify: (c) {
      final crop = editOf(c.state).cropRect;
      expect(crop, isNotNull);
      expect(crop!.width, 0.8);
    },
  );

  blocTest<ComposeCubit, ComposeState>(
    'edits target the active carousel item after setActiveItem',
    build: build,
    act: (c) async {
      await c.startFromAssets(['a', 'b']);
      c
        ..setActiveItem(1)
        ..setFilter(FilterPreset.mono);
    },
    verify: (c) {
      expect(editOf(c.state).filter, FilterPreset.original);
      expect(editOf(c.state, 1).filter, FilterPreset.mono);
    },
  );
}
