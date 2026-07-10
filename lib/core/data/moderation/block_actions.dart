import 'package:injectable/injectable.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/moderation/block_repository.dart';
import 'package:we36/core/data/moderation/blocked_users_store.dart';
import 'package:we36/core/data/profile/relationship_store.dart';
import 'package:we36/core/domain/result.dart';

/// Core orchestration of an optimistic block/unblock (#014, US3). Flips the
/// canonical `RelationshipStore` (mutual sever, FR-015) and the cross-feature
/// `BlockedUsersStore` immediately, then confirms with the backend and rolls
/// back on failure. Exposed as a core service so any feature (profile, reel,
/// comment, DM, story) can block without importing `features/settings`
/// (Constitution XI).
@lazySingleton
class BlockActions {
  BlockActions(this._repo, this._relationships, this._blocked);

  final BlockRepository _repo;
  final RelationshipStore _relationships;
  final BlockedUsersStore _blocked;

  /// Optimistically block [userId]. Severs the follow both ways locally.
  Future<Result<ViewerRelationship>> block(String userId) async {
    _relationships.apply(
      userId,
      (r) => r.copyWith(
        blocking: true,
        following: false,
        followsYou: false,
        requested: false,
      ),
    );
    _blocked.add(userId);

    final result = await _repo.block(userId);
    return result.fold(Result<ViewerRelationship>.ok, (failure) {
      // Rollback.
      _relationships.apply(userId, (r) => r.copyWith(blocking: false));
      _blocked.remove(userId);
      return Result<ViewerRelationship>.err(failure);
    });
  }

  /// Optimistically unblock [userId] (does NOT restore any prior follow).
  Future<Result<ViewerRelationship>> unblock(String userId) async {
    _relationships.apply(userId, (r) => r.copyWith(blocking: false));
    _blocked.remove(userId);

    final result = await _repo.unblock(userId);
    return result.fold(Result<ViewerRelationship>.ok, (failure) {
      _relationships.apply(userId, (r) => r.copyWith(blocking: true));
      _blocked.add(userId);
      return Result<ViewerRelationship>.err(failure);
    });
  }
}
