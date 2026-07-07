import 'package:drift/drift.dart';

/// The persisted Saved-collections list (#011) — the one canonical collections
/// copy (Constitution IX), cached so the Saved screen opens to content on a cold
/// start while offline (spec FR-012). Each row is one `SavedCollection`; the
/// synthetic "All saved" default is stored too (id `all`, [isDefault] true) so
/// the grid renders it from cache. Ordered by [position] (default first, then
/// server order). Replaced on refresh; wiped on logout (Constitution I/IX).
/// Drift's row class is `CachedSavedCollection` to avoid clashing with the domain
/// model. The item grids themselves are live cursor pages — not cached here.
@DataClassName('CachedSavedCollection')
class SavedCollections extends Table {
  /// Server id (`all` for the synthetic default) — the primary key.
  TextColumn get id => text()();

  /// Display name.
  TextColumn get name => text()();

  /// "N saved" count.
  IntColumn get itemCount => integer()();

  /// JSON-encoded `List<String>` of up to 4 cover thumbnail refs.
  TextColumn get coverRefsJson => text()();

  /// True only for the "All saved" default (never renamable/deletable).
  BoolColumn get isDefault => boolean()();

  /// Last-updated timestamp (display + reconcile).
  DateTimeColumn get updatedAt => dateTime()();

  /// Render order (0-based; the default is written first).
  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
