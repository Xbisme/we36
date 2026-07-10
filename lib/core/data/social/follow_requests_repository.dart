import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/social/follow_request.dart';
import 'package:we36/core/domain/result.dart';

/// The follow-request approval inbox (#014, US2). A real impl (`env:['real']`)
/// binds to `/me/follow-requests`; an in-memory fake (`env:['fake']`) seeds a
/// few pending requests.
abstract interface class FollowRequestsRepository {
  Future<Result<CursorPage<FollowRequest>>> list({String? cursor});

  /// Approve — the requester becomes a follower. Returns the updated
  /// relationship (idempotent via [idempotencyKey]).
  Future<Result<ViewerRelationship>> accept(
    String userId, {
    String? idempotencyKey,
  });

  /// Decline — removes the request, no follower added.
  Future<Result<void>> reject(String userId, {String? idempotencyKey});
}
