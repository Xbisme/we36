import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/domain/result.dart';

/// Remote source for reels (B#007): `GET /reels` → `CursorPage<Reel>`; idempotent
/// like/save toggles → `EngagementState`; `POST /reels` (idempotent) → `Reel`;
/// `DELETE /reels/:id`. All via the shared [ApiClient] (centralized
/// auth/refresh/error mapping → `Result`).
@lazySingleton
class ReelsRemoteDataSource {
  const ReelsRemoteDataSource(this._api);

  final ApiClient _api;

  Future<Result<CursorPage<Reel>>> getFeed(PageRequest request) =>
      _api.get<CursorPage<Reel>>(
        ApiEndpoints.reels,
        query: request.toQuery(),
        decode: (data) => CursorPage<Reel>.fromJson(
          data as Map<String, dynamic>,
          Reel.fromJson,
        ),
      );

  /// Fetch a single reel (`GET /reels/:id`). Unlike the ready-only feed, this
  /// returns the reel even while its video is still transcoding — used to poll a
  /// just-published reel until `isVideoReady` flips.
  Future<Result<Reel>> getReel(String id) => _api.get<Reel>(
    ApiEndpoints.reel(id),
    decode: (data) => Reel.fromJson(data as Map<String, dynamic>),
  );

  Future<Result<EngagementState>> like(String reelId, {required bool like}) {
    final path = ApiEndpoints.reelLike(reelId);
    EngagementState decode(dynamic data) =>
        EngagementState.fromJson(data as Map<String, dynamic>);
    return like
        ? _api.post<EngagementState>(path, idempotent: true, decode: decode)
        : _api.delete<EngagementState>(path, decode: decode);
  }

  Future<Result<EngagementState>> save(String reelId, {required bool save}) {
    final path = ApiEndpoints.reelSave(reelId);
    EngagementState decode(dynamic data) =>
        EngagementState.fromJson(data as Map<String, dynamic>);
    return save
        ? _api.post<EngagementState>(path, idempotent: true, decode: decode)
        : _api.delete<EngagementState>(path, decode: decode);
  }

  Future<Result<Reel>> create({
    required String videoMediaId,
    required String clientKey,
    String? caption,
    bool commentsDisabled = false,
    String? locationName,
    List<String> taggedUserIds = const [],
  }) => _api.post<Reel>(
    ApiEndpoints.reels,
    idempotencyKey: clientKey, // Idempotency-Key header (not a body field)
    body: {
      'videoMediaId': videoMediaId,
      'commentsDisabled': commentsDisabled,
      'caption': ?caption,
      if (locationName != null) 'location': {'name': locationName},
      if (taggedUserIds.isNotEmpty) 'taggedUserIds': taggedUserIds,
    },
    decode: (data) => Reel.fromJson(data as Map<String, dynamic>),
  );

  Future<Result<void>> delete(String reelId) =>
      _api.delete<void>(ApiEndpoints.reel(reelId), decode: (_) {});
}
