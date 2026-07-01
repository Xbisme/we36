import 'package:drift/drift.dart';

/// Persisted story **seen-state** (#004). Only the viewer-specific seen marker
/// is durable — story reels/segments themselves are synthesized deterministically
/// by the fake each launch (a future backend stories spec owns full caching).
/// A reel's ring is `unseen` while any of its segments is absent here. Wiped on
/// logout / forced re-login (Constitution I). Row class `SeenSegment`.
@DataClassName('SeenSegment')
class StorySeenSegments extends Table {
  TextColumn get segmentId => text()();
  TextColumn get authorId => text()();
  DateTimeColumn get seenAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {segmentId};
}
