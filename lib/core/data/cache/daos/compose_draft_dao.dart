import 'package:drift/drift.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/tables/compose_draft_table.dart';

part 'compose_draft_dao.g.dart';

/// DAO for the single persisted compose draft (#007). Upsert replaces the one
/// row so only a single draft ever exists (Q2). Cleared on logout.
@DriftAccessor(tables: [ComposeDrafts])
class ComposeDraftDao extends DatabaseAccessor<AppDatabase>
    with _$ComposeDraftDaoMixin {
  ComposeDraftDao(super.attachedDatabase);

  /// The current draft row, if any.
  Future<ComposeDraftRow?> current() =>
      (select(composeDrafts)..limit(1)).getSingleOrNull();

  /// Reactive current draft (null when none) — drives the resume affordance.
  Stream<ComposeDraftRow?> watchCurrent() =>
      (select(composeDrafts)..limit(1)).watchSingleOrNull();

  /// Upsert the single draft; clears any other row first so exactly one exists.
  Future<void> save(ComposeDraftRow row) async {
    await transaction(() async {
      await (delete(composeDrafts)..where((t) => t.id.isNotValue(row.id))).go();
      await into(composeDrafts).insertOnConflictUpdate(row);
    });
  }

  Future<void> clear() => delete(composeDrafts).go();
}
