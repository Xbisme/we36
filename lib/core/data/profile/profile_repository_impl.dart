import 'package:injectable/injectable.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/profile/account_row.dart';
import 'package:we36/core/data/profile/profile_remote_data_source.dart';
import 'package:we36/core/data/profile/profile_repository.dart';
import 'package:we36/core/data/profile/profile_view.dart';
import 'package:we36/core/data/profile/relationship_store.dart';
import 'package:we36/core/domain/result.dart';

/// Real [ProfileRepository] (`real` env): calls the backend via the remote source
/// and seeds the canonical [RelationshipStore] from every fetched profile / list
/// row / follow result, so the profile + lists observe one relationship copy
/// (Constitution IX; SC-004).
@LazySingleton(as: ProfileRepository, env: ['real'])
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remote, this._relationships);

  final ProfileRemoteDataSource _remote;
  final RelationshipStore _relationships;

  @override
  Future<Result<ProfileView>> getProfile(String username) async {
    final result = await _remote.getProfile(username);
    final view = result.valueOrNull;
    if (view != null && !view.isMe) {
      _relationships.seed(view.user.id, view.relationship);
    }
    return result;
  }

  @override
  Future<Result<FollowResult>> follow(
    String userId, {
    String? idempotencyKey,
  }) async {
    final result = await _remote.follow(userId, idempotencyKey: idempotencyKey);
    final value = result.valueOrNull;
    if (value != null) {
      _relationships
        ..seed(userId, value.relationship)
        ..notifyFollowChanged();
    }
    return result;
  }

  @override
  Future<Result<FollowResult>> unfollow(
    String userId, {
    String? idempotencyKey,
  }) async {
    final result = await _remote.unfollow(userId);
    final value = result.valueOrNull;
    if (value != null) {
      _relationships
        ..seed(userId, value.relationship)
        ..notifyFollowChanged();
    }
    return result;
  }

  @override
  Future<Result<CursorPage<AccountRow>>> followers(
    String userId, {
    String? cursor,
    String? query,
  }) async {
    final result = await _remote.followers(
      userId,
      cursor: cursor,
      query: query,
    );
    _seedRows(result.valueOrNull);
    return result;
  }

  @override
  Future<Result<CursorPage<AccountRow>>> following(
    String userId, {
    String? cursor,
    String? query,
  }) async {
    final result = await _remote.following(
      userId,
      cursor: cursor,
      query: query,
    );
    _seedRows(result.valueOrNull);
    return result;
  }

  @override
  Future<Result<CursorPage<ExploreItem>>> posts(
    String userId, {
    String? cursor,
  }) => _remote.posts(userId, cursor: cursor);

  @override
  Future<Result<CursorPage<ExploreItem>>> tagged(
    String userId, {
    String? cursor,
  }) => _remote.tagged(userId, cursor: cursor);

  void _seedRows(CursorPage<AccountRow>? page) {
    if (page == null) return;
    for (final row in page.items) {
      _relationships.seed(row.user.id, row.relationship);
    }
  }
}
