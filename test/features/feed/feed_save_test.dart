import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/feed/fake_feed_repository.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/features/feed/domain/usecases/feed_usecases.dart';
import 'package:we36/features/feed/presentation/feed_cubit.dart';

/// US3 — optimistic save (bookmark): instant toggle, rollback on failure,
/// idempotent, persisted via the canonical cached post.
FeedCubit _cubitFor(FakeFeedRepository repo) => FeedCubit(
  WatchFeed(repo),
  LoadFeed(repo),
  LoadMoreFeed(repo),
  ToggleLike(repo),
  ToggleSave(repo),
);

Future<void> _settle() =>
    Future<void>.delayed(const Duration(milliseconds: 10));

void main() {
  late AppDatabase db;
  late FakeFeedRepository repo;
  late FeedCubit cubit;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = FakeFeedRepository(db);
    cubit = _cubitFor(repo);
  });
  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  Post firstPost() => cubit.state.posts.first;

  test('save flips optimistically', () async {
    await cubit.loadInitial();
    final before = firstPost();
    expect(before.viewerHasSaved, isFalse);

    final result = await cubit.toggleSave(before);
    await _settle();

    expect(result.isOk, isTrue);
    final after = cubit.state.posts.firstWhere((p) => p.id == before.id);
    expect(after.viewerHasSaved, isTrue);
    expect(after.saveCount, before.saveCount + 1);
  });

  test('save rolls back on server failure (FR-015)', () async {
    await cubit.loadInitial();
    final before = firstPost();

    repo.failNextMutation = true;
    final result = await cubit.toggleSave(before);
    await _settle();

    expect(result.isErr, isTrue);
    final after = cubit.state.posts.firstWhere((p) => p.id == before.id);
    expect(after.viewerHasSaved, isFalse);
    expect(after.saveCount, before.saveCount);
  });

  test('saved state persists across a refresh (FR-016)', () async {
    await cubit.loadInitial();
    final before = firstPost();
    await cubit.toggleSave(before);
    await _settle();

    await cubit.refresh();
    await _settle();

    final after = cubit.state.posts.firstWhere((p) => p.id == before.id);
    expect(after.viewerHasSaved, isTrue);
  });
}
