import 'package:injectable/injectable.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/moderation/block_repository.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// In-memory blocking (#014) — the impl that runs in `environment: 'fake'` and
/// hermetic tests. Full block/unblock + blocked list; idempotent.
@LazySingleton(as: BlockRepository, env: ['fake'])
class FakeBlockRepository implements BlockRepository {
  final Map<String, UserSummary> _blocked = {
    'u_blocked_1': const UserSummary(
      id: 'u_blocked_1',
      isVerified: false,
      username: 'spam.account',
      displayName: 'Spam Account',
    ),
  };

  ViewerRelationship _severed({required bool blocking}) => ViewerRelationship(
    following: false,
    requested: false,
    followsYou: false,
    blocking: blocking,
  );

  @override
  Future<Result<ViewerRelationship>> block(String userId) async {
    _blocked.putIfAbsent(
      userId,
      () => UserSummary(id: userId, isVerified: false, username: userId),
    );
    return Result<ViewerRelationship>.ok(_severed(blocking: true));
  }

  @override
  Future<Result<ViewerRelationship>> unblock(String userId) async {
    _blocked.remove(userId);
    return Result<ViewerRelationship>.ok(_severed(blocking: false));
  }

  @override
  Future<Result<CursorPage<UserSummary>>> listBlocked({String? cursor}) async =>
      Result<CursorPage<UserSummary>>.ok(
        CursorPage<UserSummary>(
          items: List<UserSummary>.unmodifiable(_blocked.values),
          nextCursor: null,
          hasMore: false,
        ),
      );
}
