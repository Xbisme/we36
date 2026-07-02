import 'package:we36/core/data/comments/comment.dart';
import 'package:we36/core/data/comments/comment_engagement.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// The comments data seam (Constitution VIII). Owns comments only — it MUST NOT
/// touch the post cache; the canonical `Post.commentCount` is owned by the
/// `AddComment`/`DeleteComment` use cases (plan R3, F1). A real impl
/// (`env:['real']`, B#comments contract) and an in-memory fake (`env:['fake']`,
/// the one that runs) exist. Widgets/Cubits never call this directly — use cases
/// sit in between (Constitution III/XI).
abstract interface class CommentsRepository {
  /// Top-level comments for a post (cursor, **oldest-first**).
  Future<Result<CursorPage<Comment>>> loadComments(
    String postId, {
    String? cursor,
    int limit,
  });

  /// One level of replies for a top-level comment (cursor, oldest-first).
  Future<Result<CursorPage<Comment>>> loadReplies(
    String parentId, {
    String? cursor,
    int limit,
  });

  /// Add a comment or reply. Idempotent via [clientKey] — a retry with the same
  /// key returns the same comment (exactly one — FR-007). `parentId` is
  /// normalized to the top-level ancestor (one level — FR-006).
  Future<Result<Comment>> addComment(
    String postId, {
    required String text,
    required String clientKey,
    String? parentId,
  });

  /// Like/unlike a comment (idempotent target-state).
  Future<Result<CommentEngagement>> toggleCommentLike(
    String commentId, {
    required bool like,
  });

  /// Delete own comment; a top-level comment cascade-removes its replies.
  /// Returns the number removed (`1 + replyCount`), `0` if already gone.
  Future<Result<int>> deleteComment(String commentId);

  /// Report a comment (surface-only acknowledgement — no enforcement, #014).
  Future<Result<void>> reportComment(String commentId);
}
