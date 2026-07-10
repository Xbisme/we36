import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/close_friends/close_friends_repository.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Live close-friends management over the backend (#014, B#014). The candidate
/// picker binds to the current user's followers at cutover (kept empty here as
/// the app runs `environment: 'fake'`).
@LazySingleton(as: CloseFriendsRepository, env: ['real'])
class CloseFriendsRepositoryImpl implements CloseFriendsRepository {
  const CloseFriendsRepositoryImpl(this._api);

  final ApiClient _api;

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
  Future<Result<CursorPage<UserSummary>>> candidates({String? cursor}) async =>
      // TODO(#014): bind to the current user's followers at cutover (B#014).
      const Result<CursorPage<UserSummary>>.ok(
        CursorPage(items: [], nextCursor: null, hasMore: false),
      );

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
