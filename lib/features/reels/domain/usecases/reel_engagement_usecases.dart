import 'package:injectable/injectable.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/reels/reels_repository.dart';
import 'package:we36/core/domain/result.dart';

/// Reel engagement use cases (Constitution III). Optimistic + idempotent,
/// reconciled in the repository (US2).

/// Toggle like on a reel.
@injectable
class ToggleReelLike {
  const ToggleReelLike(this._repo);
  final ReelsRepository _repo;
  Future<Result<EngagementState>> call(String reelId, {required bool like}) =>
      _repo.toggleLike(reelId, like: like);
}

/// Toggle save/bookmark on a reel.
@injectable
class ToggleReelSave {
  const ToggleReelSave(this._repo);
  final ReelsRepository _repo;
  Future<Result<EngagementState>> call(String reelId, {required bool save}) =>
      _repo.toggleSave(reelId, save: save);
}
