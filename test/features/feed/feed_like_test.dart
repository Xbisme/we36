import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/feed/fake_feed_repository.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/moderation/blocked_users_store.dart';
import 'package:we36/features/feed/domain/usecases/feed_usecases.dart';
import 'package:we36/features/feed/presentation/feed_cubit.dart';

/// US2 — optimistic like: instant flip + server reconcile, rollback on failure,
/// idempotent, one canonical cached representation.
FeedCubit _cubitFor(FakeFeedRepository repo) => FeedCubit(
  WatchFeed(repo, BlockedUsersStore()),
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

  test('like flips optimistically and adopts server counts', () async {
    await cubit.loadInitial();
    final before = firstPost();
    expect(before.viewerHasLiked, isFalse);

    final result = await cubit.toggleLike(before);
    await _settle();

    expect(result.isOk, isTrue);
    final after = cubit.state.posts.firstWhere((p) => p.id == before.id);
    expect(after.viewerHasLiked, isTrue);
    expect(after.likeCount, before.likeCount + 1);
  });

  test('like rolls back on server failure (FR-011)', () async {
    await cubit.loadInitial();
    final before = firstPost();

    repo.failNextMutation = true;
    final result = await cubit.toggleLike(before);
    await _settle();

    expect(result.isErr, isTrue);
    final after = cubit.state.posts.firstWhere((p) => p.id == before.id);
    expect(after.viewerHasLiked, isFalse);
    expect(after.likeCount, before.likeCount);
  });

  test('like is idempotent — re-like does not double-count (FR-012)', () async {
    await cubit.loadInitial();
    final before = firstPost();

    await cubit.toggleLike(before); // like
    await _settle();
    final liked = cubit.state.posts.firstWhere((p) => p.id == before.id);
    // Re-issue the same like intent → no further increment.
    await repo.toggleLike(before.id, like: true);
    await _settle();

    final after = cubit.state.posts.firstWhere((p) => p.id == before.id);
    expect(after.likeCount, liked.likeCount);
  });

  test('unlike decrements from the liked state', () async {
    await cubit.loadInitial();
    final before = firstPost();
    await cubit.toggleLike(before); // like
    await _settle();
    final liked = cubit.state.posts.firstWhere((p) => p.id == before.id);

    await cubit.toggleLike(liked); // unlike
    await _settle();
    final after = cubit.state.posts.firstWhere((p) => p.id == before.id);
    expect(after.viewerHasLiked, isFalse);
    expect(after.likeCount, before.likeCount);
  });
}
