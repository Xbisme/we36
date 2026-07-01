import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Remote source for the feed (B#004): `GET /feed` → `CursorPage<Post>`;
/// idempotent like/save toggles → `EngagementState`. All via the shared
/// [ApiClient] (centralized auth/refresh/error mapping → `Result`).
@lazySingleton
class FeedRemoteDataSource {
  const FeedRemoteDataSource(this._api);

  final ApiClient _api;

  Future<Result<CursorPage<Post>>> getFeed(PageRequest request) =>
      _api.get<CursorPage<Post>>(
        ApiEndpoints.feed,
        query: request.toQuery(),
        decode: (data) => CursorPage<Post>.fromJson(
          data as Map<String, dynamic>,
          Post.fromJson,
        ),
      );

  Future<Result<EngagementState>> like(String postId, {required bool like}) {
    final path = ApiEndpoints.postLike(postId);
    EngagementState decode(dynamic data) =>
        EngagementState.fromJson(data as Map<String, dynamic>);
    return like
        ? _api.post<EngagementState>(path, idempotent: true, decode: decode)
        : _api.delete<EngagementState>(path, decode: decode);
  }

  Future<Result<EngagementState>> save(String postId, {required bool save}) {
    final path = ApiEndpoints.postSave(postId);
    EngagementState decode(dynamic data) =>
        EngagementState.fromJson(data as Map<String, dynamic>);
    return save
        ? _api.post<EngagementState>(path, idempotent: true, decode: decode)
        : _api.delete<EngagementState>(path, decode: decode);
  }
}
