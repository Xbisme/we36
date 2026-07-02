import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/reels/fake_reels_repository.dart';
import 'package:we36/core/services/media_upload_service_fake.dart';
import 'package:we36/core/services/photo_library_service_fake.dart';
import 'package:we36/features/reels/domain/usecases/publish_reel.dart';
import 'package:we36/features/reels/presentation/cubit/reel_compose_cubit.dart';
import 'package:we36/features/reels/presentation/cubit/reel_compose_state.dart';

void main() {
  late AppDatabase db;
  late FakeReelsRepository reels;
  late FakePhotoLibraryService library;
  late ReelComposeCubit cubit;

  ReelComposeCubit build() => ReelComposeCubit(
    library,
    PublishReel(library, FakeMediaUploadService(), reels),
    IdempotencyKeys(),
  );

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    reels = FakeReelsRepository(db)..processingDelay = Duration.zero;
    library = FakePhotoLibraryService()..videoDurationMs = 15000;
    cubit = build();
  });
  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  test('loadInitial lists pickable videos', () async {
    await cubit.loadInitial();
    expect(cubit.state, isA<ReelComposeLoaded>());
    expect(cubit.state.videos, isNotEmpty);
  });

  test('pickVideo starts a draft for a valid clip', () async {
    await cubit.loadInitial();
    final failure = cubit.pickVideo(cubit.state.videos.first);
    expect(failure, isNull);
    expect(cubit.state.draft, isNotNull);
  });

  test('pickVideo rejects a clip longer than 90s', () async {
    library.videoDurationMs = 95000;
    await cubit.loadInitial();
    final failure = cubit.pickVideo(cubit.state.videos.first);
    expect(failure, isNotNull);
    expect(cubit.state.draft, isNull);
  });

  test('publish emits published and creates the reel', () async {
    await cubit.loadInitial();
    cubit.pickVideo(cubit.state.videos.first);
    await cubit.publish();
    expect(cubit.state, isA<ReelComposePublished>());
    final feed = await reels.watchReelsFeed().first;
    expect(feed.any((r) => r.author.username == 'you'), isTrue);
  });

  test('retry reuses the idempotency key ⇒ exactly one reel', () async {
    await cubit.loadInitial();
    cubit.pickVideo(cubit.state.videos.first);
    final draftKey = cubit.state.draft!.idempotencyKey;
    await cubit.publish();
    // Publish again with the same draft (simulated retry).
    await cubit.retry();
    final feed = await reels.watchReelsFeed().first;
    final mine = feed.where((r) => r.id == 'reel-$draftKey');
    expect(mine, hasLength(1));
  });
}
