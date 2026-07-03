import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:we36/core/data/profile/profile_repository.dart';
import 'package:we36/core/data/profile/profile_view.dart';
import 'package:we36/core/data/profile/relationship_store.dart';
import 'package:we36/core/domain/result.dart';

/// The optimistic, idempotent follow mutation (#010 US2; FR-007/008/009). Applies
/// the intent to the canonical [RelationshipStore] immediately (so every surface
/// showing the account updates — SC-004), calls the backend with a stable
/// `Idempotency-Key`, and rolls the store back on failure. The repository seeds
/// the store with the server-authoritative relationship on success.
@lazySingleton
class FollowAction {
  FollowAction(this._repo, this._store);

  final ProfileRepository _repo;
  final RelationshipStore _store;
  final Uuid _uuid = const Uuid();

  /// Follow a public account (→ following) or request a private one (→ requested).
  Future<Result<FollowResult>> follow(
    String userId, {
    required bool isPrivate,
  }) async {
    final prev = _store.current(userId);
    _store.apply(
      userId,
      (c) =>
          isPrivate ? c.copyWith(requested: true) : c.copyWith(following: true),
    );
    final res = await _repo.follow(userId, idempotencyKey: _uuid.v7());
    if (res.isErr && prev != null) _store.seed(userId, prev);
    return res;
  }

  /// Unfollow or withdraw a pending request (→ follow).
  Future<Result<FollowResult>> unfollow(String userId) async {
    final prev = _store.current(userId);
    _store.apply(userId, (c) => c.copyWith(following: false, requested: false));
    final res = await _repo.unfollow(userId, idempotencyKey: _uuid.v7());
    if (res.isErr && prev != null) _store.seed(userId, prev);
    return res;
  }
}
