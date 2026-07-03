import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/tables/explore_items_table.dart';
import 'package:we36/core/data/discovery/explore_item.dart' as domain;

part 'explore_dao.g.dart';

/// DAO for the persisted Explore-grid snapshot (#009). Maps drift rows ↔
/// [domain.ExploreItem] via serialized JSON, exposes the reactive ordered
/// [watchExplore] the grid reads, replaces the snapshot on refresh, appends
/// pages, and clears on logout (Constitution I/IX).
@DriftAccessor(tables: [ExploreItems])
class ExploreDao extends DatabaseAccessor<AppDatabase> with _$ExploreDaoMixin {
  ExploreDao(super.attachedDatabase);

  /// Reactive Explore grid in server order — the single render source.
  Stream<List<domain.ExploreItem>> watchExplore({int limit = 300}) {
    final query = select(exploreItems)
      ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)])
      ..limit(limit);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  /// Replace the whole snapshot (first page / pull-to-refresh) — items the server
  /// no longer returns drop from cache.
  Future<void> replaceAll(List<domain.ExploreItem> items) =>
      transaction(() async {
        await delete(exploreItems).go();
        await _insertFrom(items, 0);
      });

  /// Append the next page after [fromIndex] (cursor pagination).
  Future<void> appendAll(
    List<domain.ExploreItem> items, {
    required int fromIndex,
  }) => _insertFrom(items, fromIndex);

  /// Current cached count (next append offset).
  Future<int> count() async {
    final c = exploreItems.orderIndex.count();
    final row = await (selectOnly(exploreItems)..addColumns([c])).getSingle();
    return row.read(c) ?? 0;
  }

  /// Clear the snapshot on logout / forced re-login.
  Future<void> clearUserScoped() => delete(exploreItems).go();

  Future<void> _insertFrom(List<domain.ExploreItem> items, int fromIndex) =>
      batch((b) {
        b.insertAllOnConflictUpdate(exploreItems, [
          for (var i = 0; i < items.length; i++)
            _toCompanion(items[i], fromIndex + i),
        ]);
      });

  ExploreItemsCompanion _toCompanion(domain.ExploreItem item, int index) =>
      ExploreItemsCompanion.insert(
        orderIndex: Value(index),
        itemId: item.id,
        kind: item.kind.name,
        payloadJson: jsonEncode(item.toJson()),
      );

  domain.ExploreItem _toDomain(CachedExploreItem row) =>
      domain.ExploreItem.fromJson(
        jsonDecode(row.payloadJson) as Map<String, dynamic>,
      );
}
