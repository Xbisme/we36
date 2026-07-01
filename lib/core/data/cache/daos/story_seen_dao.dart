import 'package:drift/drift.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/tables/story_seen_table.dart';

part 'story_seen_dao.g.dart';

/// DAO for persisted story seen-state (#004). Exposes a reactive set of seen
/// segment ids the rail watches to compute unseen rings, and a marker written
/// when a segment is viewed. Cleared on logout (Constitution I).
@DriftAccessor(tables: [StorySeenSegments])
class StorySeenDao extends DatabaseAccessor<AppDatabase>
    with _$StorySeenDaoMixin {
  StorySeenDao(super.attachedDatabase);

  Future<void> markSeen(String segmentId, String authorId) =>
      into(storySeenSegments).insertOnConflictUpdate(
        StorySeenSegmentsCompanion.insert(
          segmentId: segmentId,
          authorId: authorId,
          seenAt: DateTime.now().toUtc(),
        ),
      );

  /// Reactive set of seen segment ids — the rail recomputes ring state from this.
  Stream<Set<String>> watchSeen() => select(
    storySeenSegments,
  ).watch().map((rows) => rows.map((r) => r.segmentId).toSet());

  Future<Set<String>> getSeen() async {
    final rows = await select(storySeenSegments).get();
    return rows.map((r) => r.segmentId).toSet();
  }

  Future<void> clear() => delete(storySeenSegments).go();
}
