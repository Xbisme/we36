import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/comments/comment.dart';
import 'package:we36/core/data/comments/comment_engagement.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Remote source for comments (B#comments). All calls go through the shared
/// [ApiClient] (centralized auth/refresh/error mapping → `Result`). Add is
/// idempotent (the interceptor attaches a retry-safe `Idempotency-Key`); like
/// is a target-state `POST`/`DELETE` toggle (mirrors feed like/save).
@lazySingleton
class CommentsRemoteDataSource {
  const CommentsRemoteDataSource(this._api);

  final ApiClient _api;

  CursorPage<Comment> _decodePage(dynamic data) => CursorPage<Comment>.fromJson(
    data as Map<String, dynamic>,
    Comment.fromJson,
  );

  Future<Result<CursorPage<Comment>>> getComments(
    String postId,
    PageRequest request,
  ) => _api.get<CursorPage<Comment>>(
    ApiEndpoints.postComments(postId),
    query: request.toQuery(),
    decode: _decodePage,
  );

  Future<Result<CursorPage<Comment>>> getReplies(
    String parentId,
    PageRequest request,
  ) => _api.get<CursorPage<Comment>>(
    ApiEndpoints.commentReplies(parentId),
    query: request.toQuery(),
    decode: _decodePage,
  );

  Future<Result<Comment>> add(
    String postId, {
    required String text,
    String? parentId,
  }) => _api.post<Comment>(
    ApiEndpoints.postComments(postId),
    // Backend `CreateCommentDto`: the text field is `body` (not `text`).
    body: {'body': text, 'parentId': ?parentId},
    idempotent: true,
    decode: (data) => Comment.fromJson(data as Map<String, dynamic>),
  );

  Future<Result<CommentEngagement>> like(
    String commentId, {
    required bool like,
  }) {
    final path = ApiEndpoints.commentLike(commentId);
    CommentEngagement decode(dynamic data) =>
        CommentEngagement.fromJson(data as Map<String, dynamic>);
    return like
        ? _api.post<CommentEngagement>(path, idempotent: true, decode: decode)
        : _api.delete<CommentEngagement>(path, decode: decode);
  }

  Future<Result<int>> delete(String commentId) => _api.delete<int>(
    ApiEndpoints.comment(commentId),
    decode: (data) =>
        (data as Map<String, dynamic>)['deletedCount'] as int? ?? 0,
  );

  Future<Result<void>> report(String commentId) => _api.post<void>(
    ApiEndpoints.commentReport(commentId),
    idempotent: true,
    decode: (_) {},
  );
}
