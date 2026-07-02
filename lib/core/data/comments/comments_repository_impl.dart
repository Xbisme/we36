import 'package:injectable/injectable.dart';
import 'package:we36/core/data/comments/comment.dart';
import 'package:we36/core/data/comments/comment_engagement.dart';
import 'package:we36/core/data/comments/comments_remote_data_source.dart';
import 'package:we36/core/data/comments/comments_repository.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Real comments repository (B#comments): thin pass-through to the remote source.
/// Owns comments only — the canonical `Post.commentCount` is reconciled by the
/// `AddComment`/`DeleteComment` use cases (plan R3), never here. Registered only
/// in the `real` environment — the in-memory fake runs until a dev backend is
/// wired.
@LazySingleton(as: CommentsRepository, env: ['real'])
class CommentsRepositoryImpl implements CommentsRepository {
  const CommentsRepositoryImpl(this._remote);

  final CommentsRemoteDataSource _remote;

  @override
  Future<Result<CursorPage<Comment>>> loadComments(
    String postId, {
    String? cursor,
    int limit = PageRequest.defaultLimit,
  }) => _remote.getComments(postId, PageRequest(cursor: cursor, limit: limit));

  @override
  Future<Result<CursorPage<Comment>>> loadReplies(
    String parentId, {
    String? cursor,
    int limit = PageRequest.defaultLimit,
  }) => _remote.getReplies(parentId, PageRequest(cursor: cursor, limit: limit));

  @override
  Future<Result<Comment>> addComment(
    String postId, {
    required String text,
    required String clientKey,
    String? parentId,
  }) => _remote.add(postId, text: text, parentId: parentId);

  @override
  Future<Result<CommentEngagement>> toggleCommentLike(
    String commentId, {
    required bool like,
  }) => _remote.like(commentId, like: like);

  @override
  Future<Result<int>> deleteComment(String commentId) =>
      _remote.delete(commentId);

  @override
  Future<Result<void>> reportComment(String commentId) =>
      _remote.report(commentId);
}
