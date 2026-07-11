import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/close_friends/close_friends_repository.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/me/me_repository.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Live close-friends management over the backend (#014, B#014). The add-picker
/// candidates are the current user's followers (the accounts eligible to be
/// close friends — the backend requires a candidate to already follow you).
@LazySingleton(as: CloseFriendsRepository, env: ['real'])
class CloseFriendsRepositoryImpl implements CloseFriendsRepository {
  const CloseFriendsRepositoryImpl(this._api, this._me);

  final ApiClient _api;
  final MeRepository _me;

  @override
  Future<Result<CursorPage<UserSummary>>> list({String? cursor}) =>
      _api.get<CursorPage<UserSummary>>(
        ApiEndpoints.closeFriends,
        query: cursor == null ? null : {'cursor': cursor},
        decode: (data) => CursorPage<UserSummary>.fromJson(
          (data as Map).cast<String, dynamic>(),
          UserSummary.fromJson,
        ),
      );

  @override
  Future<Result<CursorPage<UserSummary>>> candidates({String? cursor}) async {
    final me = await _me.getMe();
    final myId = me.valueOrNull?.id;
    if (myId == null) {
      return me.fold(
        (_) => const Result<CursorPage<UserSummary>>.ok(
          CursorPage(items: [], nextCursor: null, hasMore: false),
        ),
        Result<CursorPage<UserSummary>>.err,
      );
    }
    // My followers = the accounts eligible to be added (they already follow me).
    return _api.get<CursorPage<UserSummary>>(
      ApiEndpoints.userFollowers(myId),
      query: cursor == null ? null : {'cursor': cursor},
      decode: (data) => CursorPage<UserSummary>.fromJson(
        (data as Map).cast<String, dynamic>(),
        (item) =>
            UserSummary.fromJson((item['user'] as Map).cast<String, dynamic>()),
      ),
    );
  }

  @override
  Future<Result<void>> add(String userId) => _api.post<void>(
    ApiEndpoints.closeFriend(userId),
    idempotent: true,
    decode: (_) {},
  );

  @override
  Future<Result<void>> remove(String userId) => _api.delete<void>(
    ApiEndpoints.closeFriend(userId),
    decode: (_) {},
  );
}
