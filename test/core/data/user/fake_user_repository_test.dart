import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/user/fake_user_repository.dart';
import 'package:we36/core/data/user/user.dart';

void main() {
  group('FakeUserRepository (US2 / SC-001, SC-007)', () {
    test(
      'getByUsername returns ok with a contract-shaped user, no network',
      () async {
        final repo = FakeUserRepository();
        final result = await repo.getByUsername('maivu');

        expect(result.isOk, isTrue);
        final user = result.valueOrNull!;
        expect(user, isA<User>());
        expect(user.username, 'maivu');
        expect(user.id, isNotEmpty); // UUIDv7-shaped string id
        expect(user.displayName, 'Maivu');
        expect(user.followersCount, isA<int>());
      },
    );

    test('is deterministic — same username yields the same id', () async {
      final repo = FakeUserRepository();
      final a = (await repo.getByUsername('lan')).valueOrNull!;
      final b = (await repo.getByUsername('lan')).valueOrNull!;
      expect(a.id, b.id);
    });

    test('watchByUsername emits on get (reactive seam)', () async {
      final repo = FakeUserRepository();
      final emissions = <User?>[];
      final sub = repo.watchByUsername('huy').listen(emissions.add);

      await repo.getByUsername('huy');
      await Future<void>.delayed(Duration.zero);

      expect(
        emissions.whereType<User>().map((u) => u.username),
        contains('huy'),
      );
      await sub.cancel();
    });
  });
}
