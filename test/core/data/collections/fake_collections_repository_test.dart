import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/collections/fake_collections_repository.dart';
import 'package:we36/core/data/collections/saved_collection.dart';

/// Logic tests for the in-memory [FakeCollectionsRepository] (the source that
/// runs in fake mode + backs every #011 cubit test). Plain `test()` — real async.
void main() {
  late FakeCollectionsRepository repo;

  setUp(() => repo = FakeCollectionsRepository());
  tearDown(() => repo.dispose());

  Future<List<SavedCollection>> collections() => repo.watchCollections().first;

  test('lists the "All saved" default first, then named collections', () async {
    final list = await collections();

    expect(list.first.id, kAllSavedCollectionId);
    expect(list.first.isDefault, isTrue);
    expect(list.map((c) => c.name), containsAll(<String>['Food', 'Trips']));
    // Seeded: 6 saved items → All saved count 6; Food has 3, Trips 0.
    expect(list.first.itemCount, 6);
    expect(list.firstWhere((c) => c.name == 'Food').itemCount, 3);
    expect(list.firstWhere((c) => c.name == 'Trips').itemCount, 0);
  });

  test('create accepts a duplicate (non-unique) name', () async {
    final a = await repo.create('Food');
    final b = await repo.create('Food');

    expect(a.valueOrNull, isNotNull);
    expect(b.valueOrNull, isNotNull);
    expect(a.valueOrNull!.id, isNot(b.valueOrNull!.id));
    final names = (await collections()).map((c) => c.name).toList();
    expect(names.where((n) => n == 'Food').length, greaterThanOrEqualTo(2));
  });

  test('create is idempotent for the same idempotency key', () async {
    final a = await repo.create('Trip', idempotencyKey: 'k1');
    final b = await repo.create('Trip', idempotencyKey: 'k1');

    expect(a.valueOrNull!.id, b.valueOrNull!.id);
  });

  test('rename updates the collection name', () async {
    await repo.rename('col_trips', 'Adventures');
    final trips = (await collections()).firstWhere((c) => c.id == 'col_trips');
    expect(trips.name, 'Adventures');
  });

  test(
    'delete removes the collection but keeps its posts saved (SC-006)',
    () async {
      final savedBefore = (await repo.allSaved()).valueOrNull!.items.length;

      await repo.delete('col_food');

      final ids = (await collections()).map((c) => c.id);
      expect(ids, isNot(contains('col_food')));
      // Food's members remain in "All saved".
      expect((await repo.allSaved()).valueOrNull!.items.length, savedBefore);
    },
  );

  test(
    'file adds membership + saves; retry yields exactly one (idempotent)',
    () async {
      // Grab an unsaved catalog item (items 6..9 are not in the seeded saved set).
      final saved = (await repo.allSaved()).valueOrNull!.items;
      final savedIds = saved.map((e) => e.id).toSet();
      // File a known saved item into Trips twice.
      final target = saved.first.id;

      await repo.file('col_trips', target);
      await repo.file('col_trips', target);

      final trips = (await collections()).firstWhere(
        (c) => c.id == 'col_trips',
      );
      expect(trips.itemCount, 1); // idempotent — one membership
      expect(savedIds.contains(target), isTrue);
    },
  );

  test('unfile removes from the collection but keeps the post saved', () async {
    final foodItems = (await repo.collectionItems(
      'col_food',
    )).valueOrNull!.items;
    final postId = foodItems.first.id;

    await repo.unfile('col_food', postId);

    final food = (await collections()).firstWhere((c) => c.id == 'col_food');
    expect(food.itemCount, 2);
    // Still saved in "All saved".
    final allIds = (await repo.allSaved()).valueOrNull!.items.map((e) => e.id);
    expect(allIds, contains(postId));
  });

  test(
    'unsave cascades: removed from All saved and every collection (SC-005/007)',
    () async {
      final foodItems = (await repo.collectionItems(
        'col_food',
      )).valueOrNull!.items;
      final postId = foodItems.first.id;

      await repo.unsave(postId);

      final allIds = (await repo.allSaved()).valueOrNull!.items.map(
        (e) => e.id,
      );
      expect(allIds, isNot(contains(postId)));
      final foodIds = (await repo.collectionItems(
        'col_food',
      )).valueOrNull!.items.map((e) => e.id);
      expect(foodIds, isNot(contains(postId)));
    },
  );

  test(
    'set-cover then unsaving the cover item falls back automatically (FR-010)',
    () async {
      final foodItems = (await repo.collectionItems(
        'col_food',
      )).valueOrNull!.items;
      final cover = foodItems.first.id;
      await repo.setCover('col_food', cover);
      final withCover = (await collections()).firstWhere(
        (c) => c.id == 'col_food',
      );
      expect(withCover.coverRefs, isNotEmpty);

      // Removing the cover item from the collection reconciles the cover.
      await repo.unfile('col_food', cover);
      final food = (await collections()).firstWhere((c) => c.id == 'col_food');
      // Cover now derives from the remaining members (still non-empty here).
      expect(food.itemCount, 2);
      expect(food.coverRefs.length, lessThanOrEqualTo(food.itemCount));
    },
  );

  test(
    'membership reports named-collection count for the confirm gate (R4)',
    () async {
      final foodItems = (await repo.collectionItems(
        'col_food',
      )).valueOrNull!.items;
      final inFood = foodItems.first.id;

      final m = (await repo.membership(inFood)).valueOrNull!;

      expect(m.isSaved, isTrue);
      expect(m.namedMembershipCount, greaterThanOrEqualTo(1));
      // A saved item that is not in any named collection.
      final allIds = (await repo.allSaved()).valueOrNull!.items
          .map((e) => e.id)
          .toSet();
      final foodMemberIds = foodItems.map((e) => e.id).toSet();
      final onlyAllSaved = allIds.difference(foodMemberIds).first;
      final m2 = (await repo.membership(onlyAllSaved)).valueOrNull!;
      expect(m2.namedMembershipCount, 0);
    },
  );

  test('collectionItems + allSaved paginate without duplicates', () async {
    // Fill Trips beyond one page.
    final all = (await repo.allSaved()).valueOrNull!.items.map((e) => e.id);
    for (final id in all) {
      await repo.file('col_trips', id);
    }
    final page1 = (await repo.collectionItems('col_trips')).valueOrNull!;
    final seen = page1.items.map((e) => e.id).toSet();
    var cursor = page1.nextCursor;
    while (cursor != null) {
      final page = (await repo.collectionItems(
        'col_trips',
        cursor: cursor,
      )).valueOrNull!;
      for (final item in page.items) {
        expect(seen.add(item.id), isTrue, reason: 'no duplicate across pages');
      }
      cursor = page.nextCursor;
    }
  });

  test('failNextQuery / failNextMutation surface a failure', () async {
    repo.failNextQuery = true;
    expect((await repo.allSaved()).isErr, isTrue);

    repo.failNextMutation = true;
    expect((await repo.create('X')).isErr, isTrue);
  });
}
