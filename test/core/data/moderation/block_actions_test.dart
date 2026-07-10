import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/moderation/block_actions.dart';
import 'package:we36/core/data/moderation/block_repository.dart';
import 'package:we36/core/data/moderation/blocked_users_store.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/profile/relationship_store.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

class _StubBlockRepo implements BlockRepository {
  bool fail = false;

  @override
  Future<Result<ViewerRelationship>> block(String userId) async => fail
      ? const Result<ViewerRelationship>.err(AppFailure.networkError())
      : const Result<ViewerRelationship>.ok(
          ViewerRelationship(
            following: false,
            requested: false,
            followsYou: false,
            blocking: true,
          ),
        );

  @override
  Future<Result<ViewerRelationship>> unblock(String userId) async => fail
      ? const Result<ViewerRelationship>.err(AppFailure.networkError())
      : const Result<ViewerRelationship>.ok(
          ViewerRelationship(
            following: false,
            requested: false,
            followsYou: false,
            blocking: false,
          ),
        );

  @override
  Future<Result<CursorPage<UserSummary>>> listBlocked({String? cursor}) async =>
      const Result<CursorPage<UserSummary>>.ok(
        CursorPage(items: [], nextCursor: null, hasMore: false),
      );
}

ViewerRelationship _following() => const ViewerRelationship(
  following: true,
  requested: false,
  followsYou: true,
  blocking: false,
);

void main() {
  group('BlockActions (#014 US3)', () {
    test('block severs the follow both ways and marks blocked', () async {
      final rel = RelationshipStore()..seed('u1', _following());
      final blocked = BlockedUsersStore();
      final actions = BlockActions(_StubBlockRepo(), rel, blocked);

      await actions.block('u1');

      final r = rel.current('u1')!;
      expect(r.blocking, isTrue);
      expect(r.following, isFalse);
      expect(r.followsYou, isFalse);
      expect(blocked.isBlocked('u1'), isTrue);
    });

    test('block rolls back on failure', () async {
      final rel = RelationshipStore()..seed('u1', _following());
      final blocked = BlockedUsersStore();
      final actions = BlockActions(_StubBlockRepo()..fail = true, rel, blocked);

      final result = await actions.block('u1');

      expect(result.isOk, isFalse);
      expect(rel.current('u1')!.blocking, isFalse);
      expect(blocked.isBlocked('u1'), isFalse);
    });

    test('unblock clears blocked but does not restore the follow', () async {
      final rel = RelationshipStore()
        ..seed(
          'u1',
          const ViewerRelationship(
            following: false,
            requested: false,
            followsYou: false,
            blocking: true,
          ),
        );
      final blocked = BlockedUsersStore()..add('u1');
      final actions = BlockActions(_StubBlockRepo(), rel, blocked);

      await actions.unblock('u1');

      expect(rel.current('u1')!.blocking, isFalse);
      expect(rel.current('u1')!.following, isFalse); // not restored
      expect(blocked.isBlocked('u1'), isFalse);
    });
  });
}
