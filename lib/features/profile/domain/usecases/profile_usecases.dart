import 'package:injectable/injectable.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/data/me/me_repository.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/profile/profile_repository.dart';
import 'package:we36/core/data/profile/profile_view.dart';
import 'package:we36/core/domain/result.dart';

/// Which grid a profile is showing (#010 FR-002/003).
enum ProfileTab { posts, tagged }

/// Reactive read of the cached current-user identity (header cold-start, FR-005).
@injectable
class WatchMe {
  const WatchMe(this._repo);
  final MeRepository _repo;
  Stream<MeProfile?> call() => _repo.watchMe();
}

/// Reconcile the current-user identity from the backend.
@injectable
class FetchMe {
  const FetchMe(this._repo);
  final MeRepository _repo;
  Future<Result<MeProfile>> call() => _repo.getMe();
}

/// Load a full profile by handle (own or other) — identity + counts +
/// relationship + gating.
@injectable
class LoadProfile {
  const LoadProfile(this._repo);
  final ProfileRepository _repo;
  Future<Result<ProfileView>> call(String username) =>
      _repo.getProfile(username);
}

/// Load one page of a profile's Posts or Tagged grid.
@injectable
class LoadProfileGrid {
  const LoadProfileGrid(this._repo);
  final ProfileRepository _repo;
  Future<Result<CursorPage<ExploreItem>>> call(
    String userId,
    ProfileTab tab, {
    String? cursor,
  }) => tab == ProfileTab.posts
      ? _repo.posts(userId, cursor: cursor)
      : _repo.tagged(userId, cursor: cursor);
}
