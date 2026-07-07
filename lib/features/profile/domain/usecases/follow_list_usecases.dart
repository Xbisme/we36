import 'package:injectable/injectable.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/profile/account_row.dart';
import 'package:we36/core/data/profile/profile_repository.dart';
import 'package:we36/core/domain/result.dart';

/// Which connection list is showing (#010 US3).
enum FollowConnTab { followers, following }

/// Load one page of a profile's followers or following list (cursor + optional
/// server-side search).
@injectable
class LoadConnections {
  const LoadConnections(this._repo);
  final ProfileRepository _repo;

  Future<Result<CursorPage<AccountRow>>> call(
    String userId,
    FollowConnTab tab, {
    String? cursor,
    String? query,
  }) => tab == FollowConnTab.followers
      ? _repo.followers(userId, cursor: cursor, query: query)
      : _repo.following(userId, cursor: cursor, query: query);
}
