import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/collections/saved_collection.dart';

/// DAO-level tests for the #011 Saved-collections cache. Drives a real in-memory
/// `AppDatabase` in plain `test()` (real async — never inside `testWidgets`,
/// which deadlocks on drift I/O; the #009 gate learning).
void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  SavedCollection col(
    String id, {
    bool isDefault = false,
    int itemCount = 0,
    List<String> covers = const [],
  }) => SavedCollection(
    id: id,
    name: id,
    itemCount: itemCount,
    coverRefs: covers,
    isDefault: isDefault,
    updatedAt: DateTime.utc(2026),
  );

  test(
    'the database is at schema v9 (SavedCollections present since v8)',
    () {
      expect(db.schemaVersion, 9);
    },
  );

  test(
    'replaceAll + watchCollections emit in position order (default first)',
    () async {
      final dao = db.savedCollectionsDao;
      await dao.replaceAll([
        col('all', isDefault: true, itemCount: 6),
        col('col_b', itemCount: 2),
        col('col_a', itemCount: 1),
      ]);

      final list = await dao.watchCollections().first;

      expect(list.map((e) => e.id).toList(), ['all', 'col_b', 'col_a']);
      expect(list.first.isDefault, isTrue);
      expect(list.first.itemCount, 6);
    },
  );

  test('replaceAll round-trips coverRefs JSON', () async {
    final dao = db.savedCollectionsDao;
    await dao.replaceAll([
      col('col_a', covers: ['https://cdn/1.webp', 'https://cdn/2.webp']),
    ]);

    final list = await dao.getCollections();

    expect(list.single.coverRefs, ['https://cdn/1.webp', 'https://cdn/2.webp']);
  });

  test('upsert updates an existing row; deleteById removes it', () async {
    final dao = db.savedCollectionsDao;
    await dao.replaceAll([col('col_a', itemCount: 1)]);

    await dao.upsert(col('col_a', itemCount: 5), position: 0);
    expect((await dao.getCollections()).single.itemCount, 5);

    await dao.deleteById('col_a');
    expect(await dao.getCollections(), isEmpty);
  });

  test('clearUserScoped empties the cache (logout)', () async {
    final dao = db.savedCollectionsDao;
    await dao.replaceAll([col('all', isDefault: true), col('col_a')]);

    await dao.clearUserScoped();

    expect(await dao.getCollections(), isEmpty);
  });
}
