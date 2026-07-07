import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/profile/account_row.dart';
import 'package:we36/core/data/profile/profile_view.dart';
import 'package:we36/core/domain/result.dart';

/// The profile + follow-graph data seam (#010, B#010 contract; Constitution
/// VIII/IX). Screens consume this via use cases — never HTTP directly. A real
/// impl (`env:['real']`) and an in-memory fake (`env:['fake']`, the one that
/// runs) exist. Follow/unfollow are idempotent (client key) and seed the
/// canonical `RelationshipStore`; grids and lists are live-query cursor pages.
abstract interface class ProfileRepository {
  /// A full profile by handle (`GET /users/{username}`) — identity + counts +
  /// the viewer relationship + the server-authoritative `gated` flag.
  Future<Result<ProfileView>> getProfile(String username);

  /// Follow (`POST /users/{id}/follow`) — following (public) or requested
  /// (private). Idempotent via [idempotencyKey]; returns the updated relationship
  /// + reconciled follower count.
  Future<Result<FollowResult>> follow(String userId, {String? idempotencyKey});

  /// Unfollow **or** withdraw a pending request (`DELETE /users/{id}/follow`).
  /// Idempotent; returns the updated relationship + reconciled follower count.
  Future<Result<FollowResult>> unfollow(
    String userId, {
    String? idempotencyKey,
  });

  /// Followers list (`GET /users/{id}/followers`), cursor + optional server-side
  /// [query] search (FR-015). Blocked accounts are server-filtered (FR-016).
  Future<Result<CursorPage<AccountRow>>> followers(
    String userId, {
    String? cursor,
    String? query,
  });

  /// Following list (`GET /users/{id}/following`), cursor + optional search.
  Future<Result<CursorPage<AccountRow>>> following(
    String userId, {
    String? cursor,
    String? query,
  });

  /// A user's Posts grid (`GET /users/{id}/posts`), cursor. Gated ⇒ forbidden.
  Future<Result<CursorPage<ExploreItem>>> posts(
    String userId, {
    String? cursor,
  });

  /// A user's Tagged grid (`GET /users/{id}/tagged`), cursor. Gated ⇒ forbidden.
  Future<Result<CursorPage<ExploreItem>>> tagged(
    String userId, {
    String? cursor,
  });
}
