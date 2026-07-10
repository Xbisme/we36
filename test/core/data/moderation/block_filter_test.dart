import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/moderation/block_filter.dart';
import 'package:we36/core/data/moderation/blocked_users_store.dart';

void main() {
  group('filterBlocked (#014 US3, FR-014)', () {
    test('hides blocked authors and re-filters on block change', () async {
      final source = StreamController<List<String>>();
      final blocked = BlockedUsersStore();
      final out = filterBlocked<String>(source.stream, blocked, (s) => s);

      final emissions = <List<String>>[];
      final sub = out.listen(emissions.add);

      source.add(['a', 'b', 'c']);
      await Future<void>.delayed(Duration.zero);
      expect(emissions.last, ['a', 'b', 'c']);

      blocked.add('b');
      await Future<void>.delayed(Duration.zero);
      expect(emissions.last, ['a', 'c']);

      await sub.cancel();
      await source.close();
    });

    test('first emission is the source, not the empty block set', () async {
      final source = StreamController<List<String>>();
      final blocked = BlockedUsersStore();
      final out = filterBlocked<String>(source.stream, blocked, (s) => s);

      final firstFuture = out.first;
      source.add(['x', 'y']);
      expect(await firstFuture, ['x', 'y']);
      await source.close();
    });
  });
}
