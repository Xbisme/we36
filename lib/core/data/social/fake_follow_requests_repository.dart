import 'package:injectable/injectable.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/social/follow_request.dart';
import 'package:we36/core/data/social/follow_requests_repository.dart';
import 'package:we36/core/domain/result.dart';

/// In-memory follow-request inbox (#014) — the impl that runs in `environment:
/// 'fake'` and hermetic tests. Seeds a few pending requests; accept/reject are
/// idempotent (a request already resolved simply no-ops).
@LazySingleton(as: FollowRequestsRepository, env: ['fake'])
class FakeFollowRequestsRepository implements FollowRequestsRepository {
  final List<FollowRequest> _pending = [
    FollowRequest(
      requester: const UserSummary(
        id: 'u_req_1',
        isVerified: false,
        username: 'nina.codes',
        displayName: 'Nina',
      ),
      requestedAt: DateTime.utc(2026, 7, 9, 10),
    ),
    FollowRequest(
      requester: const UserSummary(
        id: 'u_req_2',
        isVerified: true,
        username: 'leo.travels',
        displayName: 'Leo',
      ),
      requestedAt: DateTime.utc(2026, 7, 8, 18),
    ),
  ];

  @override
  Future<Result<CursorPage<FollowRequest>>> list({String? cursor}) async =>
      Result<CursorPage<FollowRequest>>.ok(
        CursorPage<FollowRequest>(
          items: List<FollowRequest>.unmodifiable(_pending),
          nextCursor: null,
          hasMore: false,
        ),
      );

  @override
  Future<Result<ViewerRelationship>> accept(
    String userId, {
    String? idempotencyKey,
  }) async {
    _pending.removeWhere((r) => r.requester.id == userId);
    return const Result<ViewerRelationship>.ok(
      ViewerRelationship(
        following: false,
        requested: false,
        followsYou: true,
        blocking: false,
      ),
    );
  }

  @override
  Future<Result<void>> reject(String userId, {String? idempotencyKey}) async {
    _pending.removeWhere((r) => r.requester.id == userId);
    return const Result<void>.ok(null);
  }
}
