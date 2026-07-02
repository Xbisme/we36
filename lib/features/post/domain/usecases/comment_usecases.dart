import 'package:injectable/injectable.dart';
import 'package:we36/core/data/comments/comment.dart';
import 'package:we36/core/data/comments/comment_engagement.dart';
import 'package:we36/core/data/comments/comments_repository.dart';
import 'package:we36/core/data/feed/feed_repository.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Reactive read of the canonical post being viewed (#006) — drives `PostCard`
/// and the `commentCount`, so feed and detail stay in sync via the one cached
/// copy.
@injectable
class WatchPost {
  const WatchPost(this._feed);
  final FeedRepository _feed;
  Stream<Post?> call(String postId) => _feed.watchPost(postId);
}

/// Comment use cases (Constitution III: inject use cases into cubits, not repos).
/// `AddComment`/`DeleteComment` are the **single owner** of the canonical
/// `Post.commentCount` reconciliation (plan R3, analyze F1) — they call
/// `FeedRepository.applyCommentCountDelta` on a confirmed mutation so feed and
/// detail never diverge (SC-005). The `CommentsRepository` never touches the
/// post cache.

/// Load a page of top-level comments (oldest-first).
@injectable
class LoadComments {
  const LoadComments(this._repo);
  final CommentsRepository _repo;
  Future<Result<CursorPage<Comment>>> call(
    String postId, {
    String? cursor,
  }) => _repo.loadComments(postId, cursor: cursor);
}

/// Load a page of a top-level comment's replies (one level).
@injectable
class LoadReplies {
  const LoadReplies(this._repo);
  final CommentsRepository _repo;
  Future<Result<CursorPage<Comment>>> call(
    String parentId, {
    String? cursor,
  }) => _repo.loadReplies(parentId, cursor: cursor);
}

/// Add a comment/reply (idempotent). On success, bumps the canonical post's
/// `commentCount` by +1.
@injectable
class AddComment {
  const AddComment(this._repo, this._feed);
  final CommentsRepository _repo;
  final FeedRepository _feed;

  Future<Result<Comment>> call(
    String postId, {
    required String text,
    required String clientKey,
    String? parentId,
  }) async {
    final result = await _repo.addComment(
      postId,
      text: text,
      clientKey: clientKey,
      parentId: parentId,
    );
    if (result.isOk) await _feed.applyCommentCountDelta(postId, 1);
    return result;
  }
}

/// Like/unlike a comment (optimistic + idempotent target-state).
@injectable
class ToggleCommentLike {
  const ToggleCommentLike(this._repo);
  final CommentsRepository _repo;
  Future<Result<CommentEngagement>> call(
    String commentId, {
    required bool like,
  }) => _repo.toggleCommentLike(commentId, like: like);
}

/// Delete own comment (cascade for a parent). On success, decrements the
/// canonical post's `commentCount` by the number removed (`1 + replyCount`).
@injectable
class DeleteComment {
  const DeleteComment(this._repo, this._feed);
  final CommentsRepository _repo;
  final FeedRepository _feed;

  Future<Result<int>> call(String commentId, {required String postId}) async {
    final result = await _repo.deleteComment(commentId);
    final removed = result.valueOrNull ?? 0;
    if (result.isOk && removed > 0) {
      await _feed.applyCommentCountDelta(postId, -removed);
    }
    return result;
  }
}

/// Report a comment (surface-only acknowledgement).
@injectable
class ReportComment {
  const ReportComment(this._repo);
  final CommentsRepository _repo;
  Future<Result<void>> call(String commentId) => _repo.reportComment(commentId);
}
