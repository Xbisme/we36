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
  late FakeCreatePostRepository repo;
  late ComposeCubit cubit;

  ComposeCubit build() {
    uploader = FakeMediaUploadService()..stepDelay = Duration.zero;
    repo = FakeCreatePostRepository(db);
    final publish = PublishPost(
      FakePhotoLibraryService(),
      const ImageProcessingService(),
      uploader,
      repo,
    );
    return ComposeCubit(publish, ComposeDraftStore(db), IdempotencyKeys());
  }

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  test('publish: loaded → uploading(progress) → published; post cached at top', () async {
    cubit = build();
    await cubit.startFromAssets(['fake-asset-0']);
    cubit.setCaption('hello #we36');

    final states = <ComposeState>[];
    final sub = cubit.stream.listen(states.add);
    await cubit.publish();
    await sub.cancel();

    expect(states.whereType<ComposeLoadedUploading>(), isNotEmpty);
    expect(cubit.state, isA<ComposePublished>());
    // The created post projection carries the parsed hashtags.
    expect((cubit.state as ComposePublished).post.hashtags, contains('we36'));

    // The created post is in the canonical feed cache with its caption.
    final feed = await db.postsDao.watchHomeFeed().first;
    expect(feed, hasLength(1));
    expect(feed.first.caption, 'hello #we36');
  });

  test('retry after a failed upload creates exactly one post (idempotent)', () async {
    cubit = build();
    await cubit.startFromAssets(['fake-asset-0']);

    uploader.failAfterFraction = 0.5; // first attempt fails mid-upload
    await cubit.publish();
    expect(cubit.state, isA<ComposeError>());

    uploader.failAfterFraction = null; // retry succeeds
    await cubit.retry();
    expect(cubit.state, isA<ComposePublished>());

    final feed = await db.postsDao.watchHomeFeed().first;
    expect(feed, hasLength(1)); // exactly one — no duplicate (FR-018 / SC-003)
  });
}
