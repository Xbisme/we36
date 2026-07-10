import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/close_friends/close_friends_repository.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/settings/presentation/cubit/close_friends_cubit.dart';

UserSummary _u(String id) =>
    UserSummary(id: id, isVerified: false, username: id);

class _StubRepo implements CloseFriendsRepository {
  _StubRepo(this._members);
  List<UserSummary> _members;
  bool failAdd = false;

  CursorPage<UserSummary> _page(List<UserSummary> items) =>
      CursorPage(items: items, nextCursor: null, hasMore: false);

  @override
  Future<Result<CursorPage<UserSummary>>> list({String? cursor}) async =>
      Result<CursorPage<UserSummary>>.ok(_page(_members));

  @override
  Future<Result<CursorPage<UserSummary>>> candidates({String? cursor}) async =>
      Result<CursorPage<UserSummary>>.ok(_page([_u('cand')]));

  @override
  Future<Result<void>> add(String userId) async {
    if (failAdd) {
      return const Result<void>.err(AppFailure.validation(fields: {}));
    }
    _members = [_u(userId), ..._members];
    return const Result<void>.ok(null);
  }

  @override
  Future<Result<void>> remove(String userId) async {
    _members = _members.where((u) => u.id != userId).toList();
    return const Result<void>.ok(null);
  }
}

void main() {
  group('CloseFriendsCubit (#014 US4)', () {
    test('load emits members', () async {
      final cubit = CloseFriendsCubit(_StubRepo([_u('a')]));
      await cubit.load();
      expect(cubit.state.dataOrNull, hasLength(1));
      await cubit.close();
    });

    test('add optimistically inserts the member', () async {
      final cubit = CloseFriendsCubit(_StubRepo([_u('a')]));
      await cubit.load();
      await cubit.add(_u('b'));
      expect(cubit.state.dataOrNull!.map((u) => u.id), containsAll(['a', 'b']));
      await cubit.close();
    });

    test('remove optimistically drops the member', () async {
      final cubit = CloseFriendsCubit(_StubRepo([_u('a'), _u('b')]));
      await cubit.load();
      await cubit.remove(_u('a'));
      expect(cubit.state.dataOrNull!.map((u) => u.id), ['b']);
      await cubit.close();
    });

    test('add failure rolls back and reports the error', () async {
      final cubit = CloseFriendsCubit(_StubRepo([_u('a')])..failAdd = true);
      await cubit.load();
      final errors = <AppFailure>[];
      final sub = cubit.errors.listen(errors.add);
      await cubit.add(_u('b'));
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.dataOrNull, hasLength(1)); // rolled back
      expect(errors, hasLength(1));
      await sub.cancel();
      await cubit.close();
    });
  });
}
