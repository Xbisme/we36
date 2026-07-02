import 'package:injectable/injectable.dart';
import 'package:we36/core/data/comments/comment.dart';
import 'package:we36/core/data/comments/comments_repository.dart';
import 'package:we36/core/data/reels/reels_repository.dart';
import 'package:we36/core/domain/result.dart';

/// Reel-scoped comment mutations (#008). The `CommentsRepository` is
/// target-agnostic (keyed by id); these two use cases are the reel analogue of
/// #006's `AddComment`/`DeleteComment` — the **single owner** of the canonical
/// `Reel.commentCount` reconciliation, routing the count delta to
/// [ReelsRepository.applyCommentCountDelta] (the `CommentTarget` seam, plan R7 /
/// analyze C1). The load / reply / like / report use cases from #006 are pure
/// `CommentsRepository` seams and are reused as-is.

/// Add a comment/reply to a reel (idempotent). On success, bumps the canonical
/// reel's `commentCount` by +1.
@injectable
class AddReelComment {
  const AddReelComment(this._comments, this._reels);
  final CommentsRepository _comments;
  final ReelsRepository _reels;

  Future<Result<Comment>> call(
    String reelId, {
    required String text,
    required String clientKey,
    String? parentId,
  }) async {
    final result = await _comments.addComment(
      reelId,
      text: text,
      clientKey: clientKey,
      parentId: parentId,
    );
    if (result.isOk) await _reels.applyCommentCountDelta(reelId, 1);
    return result;
  }
}

/// Delete an own comment on a reel (cascade for a parent). On success, decrements
/// the canonical reel's `commentCount` by the number removed (`1 + replyCount`).
@injectable
class DeleteReelComment {
  const DeleteReelComment(this._comments, this._reels);
  final CommentsRepository _comments;
  final ReelsRepository _reels;

  Future<Result<int>> call(String commentId, {required String reelId}) async {
    final result = await _comments.deleteComment(commentId);
    final removed = result.valueOrNull ?? 0;
    if (result.isOk && removed > 0) {
      await _reels.applyCommentCountDelta(reelId, -removed);
    }
    return result;
  }
}
