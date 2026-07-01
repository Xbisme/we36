import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/feed/fake_feed_repository.dart';

void main() {
  late AppDatabase db;
  late FakeFeedRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = FakeFeedRepository(db);
  });
  tearDown(() => db.close());

  test(
    'loadFirstPage writes a deterministic first page to the cache',
    () async {
      final result = await repo.loadFirstPage();
      expect(result.isOk, isTrue);
      final page = result.valueOrNull!;
      expect(page.items, hasLength(20));
      expect(page.hasMore, isTrue);
      expect(page.nextCursor, '20');

      final cached = await repo.watchHomeFeed().first;
      expect(cached, hasLength(20));
      // Reverse-chronological (newest first).
      expect(
        cached.first.createdAt.isAfter(cached.last.createdAt),
        isTrue,
      );
    },
  );

  test('loadNextPage appends the remainder and ends pagination', () async {
    await repo.loadFirstPage();
    final result = await repo.loadNextPage('20');
    expect(result.isOk, isTrue);
    final page = result.valueOrNull!;
    expect(page.items, hasLength(10));
    expect(page.hasMore, isFalse);
    expect(page.nextCursor, isNull);

    final cached = await repo.watchHomeFeed().first;
    expect(cached, hasLength(30));
  });

  test('toggleLike echoes an incremented engagement state', () async {
    await repo.loadFirstPage();
    final first = (await repo.watchHomeFeed().first).first;
    final before = first.likeCount;

    final result = await repo.toggleLike(first.id, like: true);
    expect(result.isOk, isTrue);
    final e = result.valueOrNull!;
    expect(e.viewerHasLiked, isTrue);
    expect(e.likeCount, before + 1);

    final cached = (await repo.watchHomeFeed().first).firstWhere(
      (p) => p.id == first.id,
    );
    expect(cached.viewerHasLiked, isTrue);
    expect(cached.likeCount, before + 1);
  });

  test('toggleLike is idempotent (re-like does not double-count)', () async {
    await repo.loadFirstPage();
    final first = (await repo.watchHomeFeed().first).first;
    final before = first.likeCount;
    await repo.toggleLike(first.id, like: true);
    final again = await repo.toggleLike(first.id, like: true);
    expect(again.valueOrNull!.likeCount, before + 1);
  });

  test('failNextMutation fails once without mutating', () async {
    await repo.loadFirstPage();
    final first = (await repo.watchHomeFeed().first).first;
    final before = first.likeCount;

    repo.failNextMutation = true;
    final failed = await repo.toggleLike(first.id, like: true);
    expect(failed.isErr, isTrue);

    final cached = (await repo.watchHomeFeed().first).firstWhere(
      (p) => p.id == first.id,
    );
    expect(cached.likeCount, before);
    expect(cached.viewerHasLiked, isFalse);

    // Flag consumed — next mutation succeeds.
    final ok = await repo.toggleLike(first.id, like: true);
    expect(ok.isOk, isTrue);
  });

  test('toggleSave echoes an incremented save state', () async {
    await repo.loadFirstPage();
    final first = (await repo.watchHomeFeed().first).first;
    final before = first.saveCount;
    final result = await repo.toggleSave(first.id, save: true);
    expect(result.valueOrNull!.viewerHasSaved, isTrue);
    expect(result.valueOrNull!.saveCount, before + 1);
  });
}
