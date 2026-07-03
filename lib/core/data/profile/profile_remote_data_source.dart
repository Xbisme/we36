import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/profile/account_row.dart';
import 'package:we36/core/data/profile/profile_view.dart';
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
        decode: (data) =>
            ProfileView.fromJson((data as Map).cast<String, dynamic>()),
      );

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
