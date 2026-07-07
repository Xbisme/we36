import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/profile/relationship_store.dart';

/// #010 T015: the canonical in-memory relationship store — seed/watch/apply/clear.
void main() {
  const rel = ViewerRelationship(
    following: false,
    requested: false,
    followsYou: true,
    blocking: false,
  );

  test('watch emits the seeded value then updates', () async {
    final store = RelationshipStore();
    final seen = <bool>[];
    final sub = store.watch('u1').listen((r) => seen.add(r.following));
    store.seed('u1', rel);
    await Future<void>.delayed(Duration.zero);
    store.apply('u1', (c) => c.copyWith(following: true));
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(seen, [false, true]);
  });

  test('current returns the latest value', () {
    final store = RelationshipStore();
    expect(store.current('u1'), isNull);
    store.seed('u1', rel);
    final followsYou = store.current('u1')!.followsYou;
    expect(followsYou, isTrue);
  });

  test('apply is a no-op when the account was never seeded', () {
    final store = RelationshipStore()
      ..apply('ghost', (c) => c.copyWith(following: true));
    expect(store.current('ghost'), isNull);
  });

  test('seed does not re-emit an identical value', () async {
    final store = RelationshipStore()..seed('u1', rel);
    final seen = <ViewerRelationship>[];
    final sub = store.watch('u1').listen(seen.add);
    await Future<void>.delayed(Duration.zero);
    store.seed('u1', rel); // identical → no emit
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(seen, [rel]);
  });

  test('clear drops all relationships', () {
    final store = RelationshipStore()
      ..seed('u1', rel)
      ..clear();
    expect(store.current('u1'), isNull);
  });
}
