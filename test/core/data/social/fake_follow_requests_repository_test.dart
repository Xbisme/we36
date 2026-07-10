import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/social/fake_follow_requests_repository.dart';

void main() {
  group('FakeFollowRequestsRepository (#014 US2)', () {
    test('list returns seeded pending requests', () async {
      final repo = FakeFollowRequestsRepository();
      final page = (await repo.list()).valueOrNull!;
      expect(page.items, hasLength(2));
      expect(page.hasMore, isFalse);
    });

    test('accept removes the request and returns followsYou', () async {
      final repo = FakeFollowRequestsRepository();
      final rel = (await repo.accept('u_req_1')).valueOrNull!;
      expect(rel.followsYou, isTrue);
      final page = (await repo.list()).valueOrNull!;
      expect(page.items.any((r) => r.requester.id == 'u_req_1'), isFalse);
    });

    test('reject removes the request', () async {
      final repo = FakeFollowRequestsRepository();
      await repo.reject('u_req_2');
      final page = (await repo.list()).valueOrNull!;
      expect(page.items.any((r) => r.requester.id == 'u_req_2'), isFalse);
    });

    test('accept is idempotent (retry keeps exactly-once removal)', () async {
      final repo = FakeFollowRequestsRepository();
      await repo.accept('u_req_1');
      final retry = await repo.accept('u_req_1'); // already resolved
      expect(retry.valueOrNull, isNotNull);
      final page = (await repo.list()).valueOrNull!;
      expect(page.items, hasLength(1));
    });
  });
}
