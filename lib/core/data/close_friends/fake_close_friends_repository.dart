import 'package:injectable/injectable.dart';
import 'package:we36/core/data/close_friends/close_friends_repository.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// In-memory close-friends management (#014) — the impl that runs in
/// `environment: 'fake'` and hermetic tests. Seeds a small list + eligible
/// candidates; add/remove are idempotent.
@LazySingleton(as: CloseFriendsRepository, env: ['fake'])
class FakeCloseFriendsRepository implements CloseFriendsRepository {
  static const _all = <String, UserSummary>{
    'u_cf_1': UserSummary(
      id: 'u_cf_1',
      isVerified: false,
      username: 'mia.k',
      displayName: 'Mia',
    ),
    'u_cf_2': UserSummary(
      id: 'u_cf_2',
      isVerified: false,
      username: 'theo',
      displayName: 'Theo',
    ),
    'u_cf_3': UserSummary(
      id: 'u_cf_3',
      isVerified: true,
      username: 'sam.builds',
      displayName: 'Sam',
    ),
  };

  final Set<String> _members = {'u_cf_1'};

  CursorPage<UserSummary> _page(Iterable<String> ids) => CursorPage(
    items: ids.map((id) => _all[id]!).toList(growable: false),
    nextCursor: null,
    hasMore: false,
  );

  @override
  Future<Result<CursorPage<UserSummary>>> list({String? cursor}) async =>
      Result<CursorPage<UserSummary>>.ok(_page(_members));

  @override
  Future<Result<CursorPage<UserSummary>>> candidates({String? cursor}) async =>
      Result<CursorPage<UserSummary>>.ok(
        _page(_all.keys.where((id) => !_members.contains(id))),
      );

  @override
  Future<Result<void>> add(String userId) async {
    if (_all.containsKey(userId)) _members.add(userId);
    return const Result<void>.ok(null);
  }

  @override
  Future<Result<void>> remove(String userId) async {
    _members.remove(userId);
    return const Result<void>.ok(null);
  }
}
