import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/reels/fake_reels_repository.dart';

void main() {
  late AppDatabase db;
  late FakeReelsRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = FakeReelsRepository(db)..processingDelay = Duration.zero;
  });
  tearDown(() => db.close());

  test(
    'loadFirstPage writes a deterministic first page to the cache',
    () async {
      final result = await repo.loadFirstPage();
      expect(result.isOk, isTrue);
      final page = result.valueOrNull!;
      expect(page.items, hasLength(6));
      expect(page.hasMore, isTrue);
      expect(page.nextCursor, '6');

      final cached = await repo.watchReelsFeed().first;
      expect(cached, hasLength(6));
      // Reverse-chronological (newest first).
      expect(cached.first.createdAt.isAfter(cached.last.createdAt), isTrue);
      // Synthesized reels are ready.
      expect(cached.every((r) => r.isVideoReady), isTrue);
    },
  );

  test('loadNextPage appends the remainder and ends pagination', () async {
    await repo.loadFirstPage();
    final result = await repo.loadNextPage('6');
    expect(result.isOk, isTrue);
    final page = result.valueOrNull!;
    expect(page.hasMore, isFalse); // 12 total / page 6 → page 2 is the last
    expect(page.nextCursor, isNull);
    final cached = await repo.watchReelsFeed().first;
    expect(cached, hasLength(12));
  });

  test('toggleLike is optimistic and reconciled in the cache', () async {
    await repo.loadFirstPage();
    final first = (await repo.watchReelsFeed().first).first;
    final result = await repo.toggleLike(first.id, like: true);
    expect(result.isOk, isTrue);
    final updated = (await repo.watchReelsFeed().first).firstWhere(
      (r) => r.id == first.id,
    );
    expect(updated.viewerHasLiked, isTrue);
    expect(updated.likeCount, first.likeCount + 1);
  });

  test('failNextMutation rolls back a like', () async {
    await repo.loadFirstPage();
    final first = (await repo.watchReelsFeed().first).first;
    repo.failNextMutation = true;
    final result = await repo.toggleLike(first.id, like: true);
    expect(result.isErr, isTrue);
    final after = (await repo.watchReelsFeed().first).firstWhere(
      (r) => r.id == first.id,
    );
    expect(after.viewerHasLiked, isFalse);
    expect(after.likeCount, first.likeCount);
  });

  test('createReel inserts a processing reel at feed top', () async {
    await repo.loadFirstPage();
    final result = await repo.createReel(
      videoMediaId: 'media-x',
      clientKey: 'key-1',
      caption: 'my first reel',
    );
    expect(result.isOk, isTrue);
    final created = result.valueOrNull!;
    expect(created.isProcessing, isTrue);

    final feed = await repo.watchReelsFeed().first;
    expect(feed.first.id, created.id);
    expect(feed.first.isVideoReady, isFalse);
  });

  test('createReel is idempotent for the same clientKey', () async {
    await repo.loadFirstPage();
    final a = await repo.createReel(videoMediaId: 'm', clientKey: 'dupe');
    final b = await repo.createReel(videoMediaId: 'm', clientKey: 'dupe');
    expect(a.valueOrNull!.id, b.valueOrNull!.id);
    final feed = await repo.watchReelsFeed().first;
    expect(feed.where((r) => r.id == a.valueOrNull!.id), hasLength(1));
  });

  test('deleteReel removes it from the cache', () async {
    await repo.loadFirstPage();
    final first = (await repo.watchReelsFeed().first).first;
    final result = await repo.deleteReel(first.id);
    expect(result.isOk, isTrue);
    final feed = await repo.watchReelsFeed().first;
    expect(feed.any((r) => r.id == first.id), isFalse);
  });
}
