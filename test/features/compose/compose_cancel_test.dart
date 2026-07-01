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
  late FakeMediaUploadService uploader;
  late ComposeCubit cubit;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    uploader = FakeMediaUploadService()
      ..stepDelay = const Duration(milliseconds: 15);
    cubit = ComposeCubit(
      PublishPost(
        FakePhotoLibraryService(),
        const ImageProcessingService(),
        uploader,
        FakeCreatePostRepository(db),
      ),
      ComposeDraftStore(db),
      IdempotencyKeys(),
    );
  });

  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  test(
    'cancel mid-upload returns to loaded with the selection + edits intact',
    () async {
      await cubit.startFromAssets(['fake-asset-0']);
      cubit.setFilter(FilterPreset.lux); // an edit that must survive cancel

      final publishing = cubit.publish();
      // Let it enter the uploading state (first progress tick).
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(cubit.state, isA<ComposeLoadedUploading>());

      cubit.cancel();
      await publishing;

      // Back to editing — no post created, draft + edit preserved (FR-018a).
      expect(cubit.state, isA<ComposeLoaded>());
      final draft = cubit.state.draftOrNull!;
      expect(draft.items, hasLength(1));
      expect(draft.items.first.edit.filter, FilterPreset.lux);

      final feed = await db.postsDao.watchHomeFeed().first;
      expect(feed, isEmpty); // nothing published
    },
  );

  test('cancel does not re-enter uploading afterwards', () async {
    await cubit.startFromAssets(['fake-asset-0']);
    final publishing = cubit.publish();
    await Future<void>.delayed(const Duration(milliseconds: 20));
    cubit.cancel();
    await publishing;

    final settled = cubit.state;
    // Give any late stream events a chance; state must remain loaded.
    await Future<void>.delayed(const Duration(milliseconds: 40));
    expect(settled, isA<ComposeLoaded>());
    expect(cubit.state, isA<ComposeLoaded>());
  });
}
