import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/close_friends/fake_close_friends_repository.dart';

void main() {
  group('FakeCloseFriendsRepository (#014 US4)', () {
    test('list returns seeded members; candidates exclude members', () async {
      final repo = FakeCloseFriendsRepository();
      final members = (await repo.list()).valueOrNull!;
      final candidates = (await repo.candidates()).valueOrNull!;
      expect(members.items, hasLength(1));
      expect(
        candidates.items.any((u) => u.id == members.items.first.id),
        isFalse,
      );
    });

    test('add then remove is idempotent', () async {
      final repo = FakeCloseFriendsRepository();
      await repo.add('u_cf_2');
      await repo.add('u_cf_2'); // idempotent
      expect((await repo.list()).valueOrNull!.items, hasLength(2));
      await repo.remove('u_cf_2');
      expect((await repo.list()).valueOrNull!.items, hasLength(1));
    });
  });
}
