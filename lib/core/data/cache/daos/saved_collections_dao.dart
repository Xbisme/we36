import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/tables/saved_collections_table.dart';
import 'package:we36/core/data/collections/saved_collection.dart' as domain;

part 'saved_collections_dao.g.dart';

/// DAO for the persisted Saved-collections list (#011). Maps drift rows ↔
/// [domain.SavedCollection], exposes the reactive ordered [watchCollections] the
/// grid reads, replaces the cached list on refresh, and clears on logout
/// (Constitution I/IX).
@DriftAccessor(tables: [SavedCollections])
class SavedCollectionsDao extends DatabaseAccessor<AppDatabase>
    with _$SavedCollectionsDaoMixin {
  SavedCollectionsDao(super.attachedDatabase);

  /// Reactive collections list in render order (default first) — the single
  /// render source for the Saved grid.
  Stream<List<domain.SavedCollection>> watchCollections() {
    final query = select(savedCollections)
      ..orderBy([(t) => OrderingTerm.asc(t.position)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  /// One-shot read (background reconcile checks / tests).
  Future<List<domain.SavedCollection>> getCollections() async {
    final query = select(savedCollections)
      ..orderBy([(t) => OrderingTerm.asc(t.position)]);
    return (await query.get()).map(_toDomain).toList();
  }

  /// Replace the whole cached list (first load / reconcile) — collections the
  /// server no longer returns drop from cache.
  Future<void> replaceAll(List<domain.SavedCollection> collections) =>
      transaction(() async {
        await delete(savedCollections).go();
        await batch((b) {
          b.insertAll(savedCollections, [
            for (var i = 0; i < collections.length; i++)
              _toCompanion(collections[i], i),
          ]);
        });
      });

  /// Upsert a single collection (optimistic create/rename/set-cover/file/remove).
  Future<void> upsert(
    domain.SavedCollection collection, {
    required int position,
  }) => into(savedCollections).insertOnConflictUpdate(
    _toCompanion(collection, position),
  );

  /// Remove one collection by id (optimistic delete).
  Future<void> deleteById(String id) =>
      (delete(savedCollections)..where((t) => t.id.equals(id))).go();

  /// Clear the cached list on logout / forced re-login.
  Future<void> clearUserScoped() => delete(savedCollections).go();

  SavedCollectionsCompanion _toCompanion(
    domain.SavedCollection c,
    int position,
  ) => SavedCollectionsCompanion.insert(
    id: c.id,
    name: c.name,
    itemCount: c.itemCount,
    coverRefsJson: jsonEncode(c.coverRefs),
    isDefault: c.isDefault,
    updatedAt: c.updatedAt,
    position: position,
  );

  domain.SavedCollection _toDomain(CachedSavedCollection row) =>
      domain.SavedCollection(
        id: row.id,
        name: row.name,
        itemCount: row.itemCount,
        coverRefs: (jsonDecode(row.coverRefsJson) as List)
            .map((e) => e as String)
            .toList(),
        isDefault: row.isDefault,
        updatedAt: row.updatedAt,
      );
}
