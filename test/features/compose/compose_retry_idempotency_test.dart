import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/services/image_processing_service.dart';
import 'package:we36/core/services/media_upload_service_fake.dart';
import 'package:we36/core/services/photo_library_service_fake.dart';
import 'package:we36/features/compose/data/compose_draft_store.dart';
import 'package:we36/features/compose/data/create_post_repository_fake.dart';
import 'package:we36/features/compose/domain/usecases/publish_post.dart';
import 'package:we36/features/compose/presentation/cubit/compose_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/compose_state.dart';

void main() {
  late AppDatabase db;
  late FakeMediaUploadService uploader;
  late ComposeCubit cubit;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    uploader = FakeMediaUploadService()..stepDelay = Duration.zero;
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

  test('failure keeps the draft and writes NO partial post', () async {
    await cubit.startFromAssets(['fake-asset-0']);
    uploader.failAfterFraction = 0.5;

    await cubit.publish();

    expect(cubit.state, isA<ComposeError>());
    expect(cubit.state.draftOrNull, isNotNull); // draft retained for retry
    final feed = await db.postsDao.watchHomeFeed().first;
    expect(feed, isEmpty); // no partial cache write (rollback-by-omission)
  });

  test(
    'retry with the same key yields exactly one post over many runs',
    () async {
      await cubit.startFromAssets(['fake-asset-0']);

      // Fail, then retry repeatedly; the created post must never duplicate.
      uploader.failAfterFraction = 0.5;
      await cubit.publish();
      expect(cubit.state, isA<ComposeError>());

      uploader.failAfterFraction = null;
      for (var i = 0; i < 5; i++) {
        await cubit.retry();
      }

      expect(cubit.state, isA<ComposePublished>());
      final feed = await db.postsDao.watchHomeFeed().first;
      expect(feed, hasLength(1)); // idempotent — exactly one (FR-018 / SC-003)
    },
  );

  test('a clean publish caches exactly one post', () async {
    await cubit.startFromAssets(['fake-asset-0', 'fake-asset-1']);
    await cubit.publish();

    expect(cubit.state, isA<ComposePublished>());
    final feed = await db.postsDao.watchHomeFeed().first;
    expect(feed, hasLength(1));
    // Both items are present on the single created post (carousel).
    expect((cubit.state as ComposePublished).post.media, hasLength(2));
  });
}
