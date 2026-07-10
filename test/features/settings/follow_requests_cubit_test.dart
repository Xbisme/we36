import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/social/follow_request.dart';
import 'package:we36/core/data/social/follow_requests_repository.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/settings/presentation/cubit/follow_requests_cubit.dart';

FollowRequest _req(String id) => FollowRequest(
  requester: UserSummary(id: id, isVerified: false, username: id),
  requestedAt: DateTime.utc(2026, 7, 9),
);

class _StubRepo implements FollowRequestsRepository {
  _StubRepo(this._items);
  List<FollowRequest> _items;
  bool failAccept = false;
  bool failReject = false;

  @override
  Future<Result<CursorPage<FollowRequest>>> list({String? cursor}) async =>
      Result<CursorPage<FollowRequest>>.ok(
        CursorPage<FollowRequest>(
          items: _items,
          nextCursor: null,
          hasMore: false,
        ),
      );

  @override
  Future<Result<ViewerRelationship>> accept(
    String userId, {
    String? idempotencyKey,
  }) async {
    if (failAccept) {
      return const Result<ViewerRelationship>.err(AppFailure.networkError());
    }
    _items = _items.where((r) => r.requester.id != userId).toList();
    return const Result<ViewerRelationship>.ok(
      ViewerRelationship(
        following: false,
        requested: false,
        followsYou: true,
        blocking: false,
      ),
    );
  }

  @override
  Future<Result<void>> reject(String userId, {String? idempotencyKey}) async {
    if (failReject) return const Result<void>.err(AppFailure.networkError());
    _items = _items.where((r) => r.requester.id != userId).toList();
    return const Result<void>.ok(null);
  }
}

void main() {
  group('FollowRequestsCubit (#014 US2)', () {
    test('load emits the pending list', () async {
      final cubit = FollowRequestsCubit(_StubRepo([_req('a'), _req('b')]));
      await cubit.load();
      expect(cubit.state.dataOrNull, hasLength(2));
      await cubit.close();
    });

    test('approve optimistically removes the row', () async {
      final cubit = FollowRequestsCubit(_StubRepo([_req('a'), _req('b')]));
      await cubit.load();
      await cubit.approve(_req('a'));
      expect(cubit.state.dataOrNull!.map((r) => r.requester.id), ['b']);
      await cubit.close();
    });

    test('decline optimistically removes the row', () async {
      final cubit = FollowRequestsCubit(_StubRepo([_req('a'), _req('b')]));
      await cubit.load();
      await cubit.decline(_req('b'));
      expect(cubit.state.dataOrNull!.map((r) => r.requester.id), ['a']);
      await cubit.close();
    });

    test('approve failure rolls back and reports an error', () async {
      final repo = _StubRepo([_req('a'), _req('b')])..failAccept = true;
      final cubit = FollowRequestsCubit(repo);
      await cubit.load();

      final errors = <AppFailure>[];
      final sub = cubit.errors.listen(errors.add);

      await cubit.approve(_req('a'));
      await Future<void>.delayed(Duration.zero); // flush broadcast delivery

      expect(cubit.state.dataOrNull, hasLength(2)); // rolled back
      expect(errors, hasLength(1));
      await sub.cancel();
      await cubit.close();
    });
  });
}
