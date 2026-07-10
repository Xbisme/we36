import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/social/follow_request.dart';
import 'package:we36/core/domain/result.dart';

/// Remote source for the follow-request approval inbox (#014, B#014) via the
/// shared [ApiClient]. Accept carries an `Idempotency-Key` (reject is a 204).
@lazySingleton
class FollowRequestsRemoteDataSource {
  const FollowRequestsRemoteDataSource(this._api);

  final ApiClient _api;

  Future<Result<CursorPage<FollowRequest>>> list({String? cursor}) =>
      _api.get<CursorPage<FollowRequest>>(
        ApiEndpoints.followRequests,
        query: cursor == null ? null : {'cursor': cursor},
        decode: (data) => CursorPage<FollowRequest>.fromJson(
          (data as Map).cast<String, dynamic>(),
          _decodeRequest,
        ),
      );

  Future<Result<ViewerRelationship>> accept(
    String userId, {
    String? idempotencyKey,
  }) => _api.post<ViewerRelationship>(
    ApiEndpoints.followRequestAccept(userId),
    idempotent: true,
    idempotencyKey: idempotencyKey,
    decode: (data) =>
        ViewerRelationship.fromJson((data as Map).cast<String, dynamic>()),
  );

  Future<Result<void>> reject(String userId, {String? idempotencyKey}) =>
      _api.post<void>(
        ApiEndpoints.followRequestReject(userId),
        idempotent: true,
        idempotencyKey: idempotencyKey,
        decode: (_) {},
      );

  static FollowRequest _decodeRequest(Map<String, dynamic> json) {
    final requester = (json['requester'] as Map).cast<String, dynamic>();
    return FollowRequest(
      requester: UserSummary(
        id: requester['id'] as String,
        isVerified: requester['isVerified'] as bool? ?? false,
        username: requester['username'] as String?,
        displayName: requester['displayName'] as String?,
        avatarUrl: requester['avatarUrl'] as String?,
      ),
      requestedAt:
          DateTime.tryParse(json['requestedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
