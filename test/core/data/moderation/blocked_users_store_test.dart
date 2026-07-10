import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/moderation/blocked_users_store.dart';

void main() {
  group('BlockedUsersStore (#014 US3)', () {
    test('add/remove/isBlocked track the set', () {
      final store = BlockedUsersStore();
      expect(store.isBlocked('u1'), isFalse);
      store.add('u1');
      expect(store.isBlocked('u1'), isTrue);
      store.remove('u1');
      expect(store.isBlocked('u1'), isFalse);
    });

    test('seed replaces the set', () {
      final store = BlockedUsersStore()
        ..add('old')
        ..seed(['a', 'b']);
      expect(store.current, {'a', 'b'});
      expect(store.isBlocked('old'), isFalse);
    });

    test('blockedIds emits the current set then changes', () async {
      final store = BlockedUsersStore()..add('a');
      final emissions = <Set<String>>[];
      final sub = store.blockedIds.listen(emissions.add);
      await Future<void>.delayed(Duration.zero);
      store.add('b');
      await Future<void>.delayed(Duration.zero);
      expect(emissions.first, {'a'});
      expect(emissions.last, {'a', 'b'});
      await sub.cancel();
    });

    test('clear empties the set', () {
      final store = BlockedUsersStore()
        ..seed(['a', 'b'])
        ..clear();
      expect(store.current, isEmpty);
    });
  });
}
