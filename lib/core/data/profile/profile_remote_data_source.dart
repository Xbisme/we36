import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/profile/account_row.dart';
import 'package:we36/core/data/profile/profile_view.dart';
import 'package:we36/core/data/user/user.dart';
import 'package:we36/core/domain/result.dart';

/// Remote source for profile + follow (#010) via the shared [ApiClient]. Decodes
/// the B#010 envelope into domain models; follow carries an `Idempotency-Key`
/// (unfollow is idempotent by DELETE semantics).
@lazySingleton
class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._api);

  final ApiClient _api;

  Future<Result<ProfileView>> getProfile(String username) =>
      _api.get<ProfileView>(
        ApiEndpoints.userByUsername(username),
        decode: (data) => _decodeProfile((data as Map).cast<String, dynamic>()),
      );

  /// Maps the backend's flat public-profile projection (`PublicProfileDto`) into
  /// the client [ProfileView]. The backend returns identity fields at the top
  /// level (singular `followerCount`/`postCount`) and does **not** send
  /// `isMe`/`gated`; `isMe` is resolved by the caller (own-profile screen) and
  /// `gated` follows from privacy + the viewer relationship (private && not an
  /// approved follower ⇒ following is false).
  static ProfileView _decodeProfile(Map<String, dynamic> json) {
    final relationship = ViewerRelationship.fromJson(
      (json['relationship'] as Map).cast<String, dynamic>(),
    );
    final user = User(
      id: json['id'] as String,
      username: json['username'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      isPrivate: json['isPrivate'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
      followersCount: (json['followerCount'] as num?)?.toInt() ?? 0,
      followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
      postsCount: (json['postCount'] as num?)?.toInt() ?? 0,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
    );
    return ProfileView(
      user: user,
      relationship: relationship,
      gated: user.isPrivate && !relationship.following,
    );
  }

  Future<Result<FollowResult>> follow(
    String userId, {
    String? idempotencyKey,
  }) => _api.post<FollowResult>(
    ApiEndpoints.userFollow(userId),
    idempotent: true,
    idempotencyKey: idempotencyKey,
    decode: _decodeFollow,
  );

  Future<Result<FollowResult>> unfollow(String userId) =>
      _api.delete<FollowResult>(
        ApiEndpoints.userFollow(userId),
        decode: _decodeFollow,
      );

  Future<Result<CursorPage<AccountRow>>> followers(
    String userId, {
    String? cursor,
    String? query,
  }) => _api.get<CursorPage<AccountRow>>(
    ApiEndpoints.userFollowers(userId),
    query: _pageQuery(cursor, query),
    decode: _decodeAccounts,
  );

  Future<Result<CursorPage<AccountRow>>> following(
    String userId, {
    String? cursor,
    String? query,
  }) => _api.get<CursorPage<AccountRow>>(
    ApiEndpoints.userFollowing(userId),
    query: _pageQuery(cursor, query),
    decode: _decodeAccounts,
  );

  Future<Result<CursorPage<ExploreItem>>> posts(
    String userId, {
    String? cursor,
  }) => _api.get<CursorPage<ExploreItem>>(
    ApiEndpoints.userPosts(userId),
    query: _pageQuery(cursor, null),
    decode: _decodeItems,
  );

  Future<Result<CursorPage<ExploreItem>>> tagged(
    String userId, {
    String? cursor,
  }) => _api.get<CursorPage<ExploreItem>>(
    ApiEndpoints.userTagged(userId),
    query: _pageQuery(cursor, null),
    decode: _decodeItems,
  );

  static Map<String, dynamic>? _pageQuery(String? cursor, String? query) {
    final map = <String, dynamic>{
      'cursor': ?cursor,
      if (query != null && query.isNotEmpty) 'q': query,
    };
    return map.isEmpty ? null : map;
  }

  static FollowResult _decodeFollow(dynamic data) =>
      FollowResult.fromJson((data as Map).cast<String, dynamic>());

  static CursorPage<AccountRow> _decodeAccounts(dynamic data) =>
      CursorPage<AccountRow>.fromJson(
        (data as Map).cast<String, dynamic>(),
        AccountRow.fromJson,
      );

  static CursorPage<ExploreItem> _decodeItems(dynamic data) =>
      CursorPage<ExploreItem>.fromJson(
        (data as Map).cast<String, dynamic>(),
        ExploreItem.fromJson,
      );
}
