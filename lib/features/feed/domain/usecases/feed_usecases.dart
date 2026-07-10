import 'package:injectable/injectable.dart';
import 'package:we36/core/data/feed/feed_repository.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/moderation/block_filter.dart';
import 'package:we36/core/data/moderation/blocked_users_store.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Feed use cases (Constitution III: inject use cases into cubits, not repos).
/// Each is a thin, testable seam over [FeedRepository].

/// Reactive canonical feed read (drift stream).
@injectable
class WatchFeed {
  const WatchFeed(this._repo, this._blocked);
  final FeedRepository _repo;
  final BlockedUsersStore _blocked;

  /// The canonical feed with blocked authors filtered out reactively (#014).
  Stream<List<Post>> call() =>
      filterBlocked(_repo.watchHomeFeed(), _blocked, (p) => p.author.id);
}

/// Load the first page (also used for pull-to-refresh).
@injectable
class LoadFeed {
  const LoadFeed(this._repo);
  final FeedRepository _repo;
  Future<Result<CursorPage<Post>>> call() => _repo.loadFirstPage();
}

/// Append the next page for the given cursor.
@injectable
class LoadMoreFeed {
  const LoadMoreFeed(this._repo);
  final FeedRepository _repo;
  Future<Result<CursorPage<Post>>> call(String cursor) =>
      _repo.loadNextPage(cursor);
}

/// Toggle like (optimistic + idempotent, reconciled in the repository).
@injectable
class ToggleLike {
  const ToggleLike(this._repo);
  final FeedRepository _repo;
  Future<Result<EngagementState>> call(String postId, {required bool like}) =>
      _repo.toggleLike(postId, like: like);
}

/// Toggle save/bookmark (optimistic + idempotent).
@injectable
class ToggleSave {
  const ToggleSave(this._repo);
  final FeedRepository _repo;
  Future<Result<EngagementState>> call(String postId, {required bool save}) =>
      _repo.toggleSave(postId, save: save);
}
