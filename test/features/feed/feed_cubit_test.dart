import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/feed/fake_feed_repository.dart';
import 'package:we36/core/data/feed/feed_repository.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/feed/domain/usecases/feed_usecases.dart';
import 'package:we36/features/feed/presentation/feed_cubit.dart';
import 'package:we36/features/feed/presentation/feed_state.dart';

class _MockFeedRepository extends Mock implements FeedRepository {}

FeedCubit _cubitFor(FeedRepository repo) => FeedCubit(
  WatchFeed(repo),
  LoadFeed(repo),
  LoadMoreFeed(repo),
  ToggleLike(repo),
  ToggleSave(repo),
);

Post _post(String id) => Post(
  id: id,
  author: const UserSummary(id: 'u1', username: 'maya', isVerified: false),
  media: const [],
  hashtags: const [],
  taggedUsers: const [],
  commentsDisabled: false,
  likeCount: 1,
  saveCount: 0,
  commentCount: 0,
  viewerHasLiked: false,
  viewerHasSaved: false,
  createdAt: DateTime.utc(2026, 7),
);

void main() {
  group('FeedCubit (fake-backed)', () {
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

    test('cold start, empty cache: loading → loaded(20)', () async {
      final states = <FeedState>[];
      final sub = cubit.stream.listen(states.add);
      await cubit.loadInitial();
      await sub.cancel();

      expect(states.first, isA<FeedLoading>());
      expect(cubit.state, isA<FeedLoaded>());
      expect(cubit.state.posts, hasLength(20));
      expect(cubit.state.hasMore, isTrue);
    });

    test(
      'cache-first cold start shows cache before network (no loading)',
      () async {
        await repo.loadFirstPage(); // warm the drift cache
        final warm = _cubitFor(repo);
        final states = <FeedState>[];
        final sub = warm.stream.listen(states.add);
        await warm.loadInitial();
        await sub.cancel();

        expect(states.first, isA<FeedLoaded>());
        expect(states.whereType<FeedLoading>(), isEmpty);
        await warm.close();
      },
    );

    test(
      'loadMore appends the next page: paginating → loaded(30), end',
      () async {
        await cubit.loadInitial();
        final states = <FeedState>[];
        final sub = cubit.stream.listen(states.add);
        await cubit.loadMore();
        await sub.cancel();

        expect(states.any((s) => s is FeedLoadedPaginating), isTrue);
        expect(cubit.state.posts, hasLength(30));
        expect(cubit.state.hasMore, isFalse);
      },
    );

    test('loadMore is a no-op once the end is reached (FR-007)', () async {
      await cubit.loadInitial();
      await cubit.loadMore(); // now 30, hasMore false
      await cubit.loadMore(); // guard: no further pages
      expect(cubit.state.posts, hasLength(30));
    });

    test('refresh reloads from the top (refreshing → loaded)', () async {
      await cubit.loadInitial();
      final states = <FeedState>[];
      final sub = cubit.stream.listen(states.add);
      await cubit.refresh();
      await sub.cancel();

      expect(states.any((s) => s is FeedLoadedRefreshing), isTrue);
      expect(cubit.state.posts, hasLength(20));
    });
  });

  group('FeedCubit (failure paths)', () {
    test('first-load error with empty cache → FeedError', () async {
      final repo = _MockFeedRepository();
      when(repo.watchHomeFeed).thenAnswer((_) => Stream.value(const <Post>[]));
      when(
        repo.loadFirstPage,
      ).thenAnswer((_) async => const Result.err(AppFailure.offline()));
      final cubit = _cubitFor(repo);

      await cubit.loadInitial();
      expect(cubit.state, isA<FeedError>());
      await cubit.close();
    });

    test('first-load failure WITH cache keeps the cache (no error)', () async {
      final repo = _MockFeedRepository();
      when(repo.watchHomeFeed).thenAnswer((_) => Stream.value([_post('c1')]));
      when(
        repo.loadFirstPage,
      ).thenAnswer((_) async => const Result.err(AppFailure.networkError()));
      final cubit = _cubitFor(repo);

      await cubit.loadInitial();
      expect(cubit.state, isA<FeedLoaded>());
      expect(cubit.state.posts, hasLength(1));
      await cubit.close();
    });
  });
}
