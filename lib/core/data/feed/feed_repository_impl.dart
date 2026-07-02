import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/daos/posts_dao.dart';
import 'package:we36/core/data/feed/feed_remote_data_source.dart';
import 'package:we36/core/data/feed/feed_repository.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Real feed repository (B#004): remote pages reconciled into the drift cache,
/// reactive canonical reads, and server-authoritative engagement reconciliation
/// (Constitution VIII/IX). Registered only in the `real` environment — the
/// in-memory fake runs until a dev backend is wired.
@LazySingleton(as: FeedRepository, env: ['real'])
class FeedRepositoryImpl implements FeedRepository {
  FeedRepositoryImpl(this._remote, this._db);

  final FeedRemoteDataSource _remote;
  final AppDatabase _db;

  PostsDao get _dao => _db.postsDao;

  @override
  Stream<List<Post>> watchHomeFeed() => _dao.watchHomeFeed();

  @override
  Stream<Post?> watchPost(String id) => _dao.watchPost(id);

  @override
  Future<void> applyCommentCountDelta(String id, int delta) =>
      _dao.adjustCommentCount(id, delta);

  @override
  Future<Result<CursorPage<Post>>> loadFirstPage() async {
    final result = await _remote.getFeed(PageRequest());
    if (result.isOk) {
      final page = result.valueOrNull!;
      // Replace the cached feed only after a successful fetch — a failed refresh
      // must keep the existing cache (FR-004). Removed/withheld posts drop here
      // (FR-035).
      await _dao.clearFeed();
      await _dao.upsertAll(page.items);
    }
    return result;
  }

  @override
  Future<Result<CursorPage<Post>>> loadNextPage(String cursor) async {
    final result = await _remote.getFeed(PageRequest(cursor: cursor));
    if (result.isOk) {
      await _dao.upsertAll(result.valueOrNull!.items);
    }
    return result;
  }

  @override
  Future<Result<EngagementState>> toggleLike(
    String postId, {
    required bool like,
  }) => _mutate(
    postId,
    (p) => p.copyWith(
      viewerHasLiked: like,
      likeCount: p.likeCount + ((like ? 1 : 0) - (p.viewerHasLiked ? 1 : 0)),
    ),
    () => _remote.like(postId, like: like),
  );

  @override
  Future<Result<EngagementState>> toggleSave(
    String postId, {
    required bool save,
  }) => _mutate(
    postId,
    (p) => p.copyWith(
      viewerHasSaved: save,
      saveCount: p.saveCount + ((save ? 1 : 0) - (p.viewerHasSaved ? 1 : 0)),
    ),
    () => _remote.save(postId, save: save),
  );

  /// Optimistic write → server → reconcile / rollback (Constitution IX;
  /// [contracts/optimistic-engagement.md]). The canonical drift copy flips
  /// instantly (reflected via [watchHomeFeed]); on failure the prior snapshot is
  /// restored; on success the server-authoritative counts are adopted.
  Future<Result<EngagementState>> _mutate(
    String postId,
    Post Function(Post prior) toggle,
    Future<Result<EngagementState>> Function() remote,
  ) async {
    final prior = await _dao.getById(postId);
    if (prior != null) await _dao.upsert(toggle(prior));
    final result = await remote();
    if (prior != null) {
      await result.fold(_dao.applyEngagement, (_) => _dao.upsert(prior));
    } else if (result.isOk) {
      await _dao.applyEngagement(result.valueOrNull!);
    }
    return result;
  }
}
