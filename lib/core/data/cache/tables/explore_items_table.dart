import 'package:drift/drift.dart';

/// The persisted Explore-grid snapshot (#009) — the only cached discovery
/// surface, so Explore opens to content on a cold start while offline (spec
/// FR-027). Ordering is server-defined and not derivable from the feed/reels
/// caches, so it is stored explicitly by [orderIndex]. Each row holds one
/// serialized `ExploreItem` (a kind-tagged post/reel) — display-only navigation
/// targets, so no competing canonical engagement copy (see plan Complexity
/// Tracking). Replaced on refresh; wiped on logout (Constitution I/IX). Drift's
/// row class is `CachedExploreItem` to avoid clashing with the domain model.
@DataClassName('CachedExploreItem')
class ExploreItems extends Table {
  /// Grid position (0-based) — preserves the server order; the primary key.
  IntColumn get orderIndex => integer()();

  /// The underlying post/reel id (dedupe within the snapshot).
  TextColumn get itemId => text()();

  /// Cell kind: `post` | `reel`.
  TextColumn get kind => text()();

  /// Serialized `ExploreItem` JSON (post/reel payload).
  TextColumn get payloadJson => text()();

  @override
  Set<Column<Object>> get primaryKey => {orderIndex};
}
