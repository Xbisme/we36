import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/daos/posts_dao.dart';
import 'package:we36/core/data/feed/feed_repository.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

/// Default #004 [FeedRepository]: a deterministic, contract-shaped feed synthesized
/// entirely in memory (no network) and written to the drift cache so reads flow
/// through the same canonical path as the real impl (Constitution VIII/IX/XII).
/// Posts carry no image URL (offline placeholder, as in #001) — real delivery
/// URLs arrive from the backend via `FeedRepositoryImpl`.
@LazySingleton(as: FeedRepository, env: ['fake'])
class FakeFeedRepository implements FeedRepository {
  FakeFeedRepository(this._db) {
    _master = _synthesize();
  }

  final AppDatabase _db;
  PostsDao get _dao => _db.postsDao;

  static const int _total = 30;
  static const int _pageSize = 20;

  late final List<Post> _master;

  /// Test seam: when true, the next mutation fails once (for rollback tests).
  bool failNextMutation = false;

  List<Post> _synthesize() {
    const authors = ['maya', 'leo', 'ava', 'noah', 'ivy', 'kai'];
    const captions = [
      'golden hour by the water 🌅',
      'weekend reset',
      'coffee and code ☕️',
      'trail day',
      'new studio corner',
      'sunset run',
    ];
    final base = DateTime.utc(2026, 7, 1, 12);
    return List<Post>.generate(_total, (i) {
      final username = authors[i % authors.length];
      return Post(
        id: 'post-${i.toString().padLeft(3, '0')}',
        author: UserSummary(
          id: 'user-$username',
          username: username,
          displayName: '${username[0].toUpperCase()}${username.substring(1)}',
          isVerified: i.isEven,
        ),
        media: [
          PostMedia(
            position: 0,
            media: Media(
              id: 'media-$i',
              kind: MediaKind.image,
              status: MediaStatus.ready,
              width: 800,
              height: 1000,
            ),
          ),
        ],
        hashtags: const [],
        taggedUsers: const [],
        commentsDisabled: false,
        likeCount: 40 + i * 7,
        saveCount: 3 + i,
        commentCount: i % 5,
        viewerHasLiked: false,
        viewerHasSaved: false,
        createdAt: base.subtract(Duration(hours: i)),
        caption: captions[i % captions.length],
      );
    });
  }

  CursorPage<Post> _page(int offset) {
    final slice = _master.skip(offset).take(_pageSize).toList();
    final next = offset + _pageSize;
    final hasMore = next < _master.length;
    return CursorPage<Post>(
      items: slice,
      nextCursor: hasMore ? '$next' : null,
      hasMore: hasMore,
    );
  }

  @override
  Stream<List<Post>> watchHomeFeed() => _dao.watchHomeFeed();

  @override
  Future<Result<CursorPage<Post>>> loadFirstPage() async {
    final page = _page(0);
    await _dao.clearFeed();
    await _dao.upsertAll(page.items);
    return Result<CursorPage<Post>>.ok(page);
  }

  @override
  Future<Result<CursorPage<Post>>> loadNextPage(String cursor) async {
    final offset = int.tryParse(cursor) ?? _master.length;
    final page = _page(offset);
    await _dao.upsertAll(page.items);
    return Result<CursorPage<Post>>.ok(page);
  }

  @override
  Future<Result<EngagementState>> toggleLike(
    String postId, {
    required bool like,
  }) => _mutate(postId, like: like);

  @override
  Future<Result<EngagementState>> toggleSave(
    String postId, {
    required bool save,
  }) => _mutate(postId, save: save);

  Future<Result<EngagementState>> _mutate(
    String postId, {
    bool? like,
    bool? save,
  }) async {
    if (failNextMutation) {
      failNextMutation = false;
      return const Result<EngagementState>.err(AppFailure.networkError());
    }
    final idx = _master.indexWhere((p) => p.id == postId);
    if (idx < 0) {
      return const Result<EngagementState>.err(AppFailure.notFound());
    }
    final prior = _master[idx];
    // Idempotent: setting to the current state is a no-op on counts.
    final nextLiked = like ?? prior.viewerHasLiked;
    final nextSaved = save ?? prior.viewerHasSaved;
    final likeDelta = (nextLiked ? 1 : 0) - (prior.viewerHasLiked ? 1 : 0);
    final saveDelta = (nextSaved ? 1 : 0) - (prior.viewerHasSaved ? 1 : 0);
    final optimistic = prior.copyWith(
      viewerHasLiked: nextLiked,
      viewerHasSaved: nextSaved,
      likeCount: prior.likeCount + likeDelta,
      saveCount: prior.saveCount + saveDelta,
    );
    // Optimistic write — reflected instantly via watchHomeFeed (Constitution IX).
    await _dao.upsert(optimistic);
    if (failNextMutation) {
      failNextMutation = false;
      await _dao.upsert(prior); // rollback
      return const Result<EngagementState>.err(AppFailure.networkError());
    }
    _master[idx] = optimistic;
    final engagement = EngagementState(
      postId: postId,
      likeCount: optimistic.likeCount,
      saveCount: optimistic.saveCount,
      viewerHasLiked: optimistic.viewerHasLiked,
      viewerHasSaved: optimistic.viewerHasSaved,
    );
    await _dao.applyEngagement(engagement);
    return Result<EngagementState>.ok(engagement);
  }
}
