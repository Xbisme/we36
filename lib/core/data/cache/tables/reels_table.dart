import 'package:drift/drift.dart';

/// Canonical cached reel (#008) — the single representation every screen reads
/// via `ReelsDao.watchReelsFeed` (Constitution IX). Drift's row class is
/// `CachedReel` to avoid clashing with the `Reel` domain model. The single video
/// is flattened to its delivery + poster URLs and dimensions here; `isVideoReady`
/// gates playback (a processing reel shows its poster). Wiped on logout / forced
/// re-login (Constitution I). Order key is [createdAt] (DESC = reverse-chron).
@DataClassName('CachedReel')
class Reels extends Table {
  TextColumn get id => text()();
  TextColumn get authorId => text()();
  TextColumn get authorUsername => text().nullable()();
  TextColumn get authorDisplayName => text().nullable()();
  TextColumn get authorAvatarUrl => text().nullable()();
  BoolColumn get authorIsVerified => boolean()();
  TextColumn get caption => text().nullable()();
  TextColumn get videoUrl => text().nullable()();
  TextColumn get posterUrl => text().nullable()();
  IntColumn get videoWidth => integer().nullable()();
  IntColumn get videoHeight => integer().nullable()();
  IntColumn get videoDurationMs => integer().nullable()();
  BoolColumn get isVideoReady => boolean()();
  TextColumn get locationName => text().nullable()();
  IntColumn get likeCount => integer()();
  IntColumn get saveCount => integer()();
  IntColumn get commentCount => integer()();
  BoolColumn get viewerHasLiked => boolean()();
  BoolColumn get viewerHasSaved => boolean()();
  BoolColumn get commentsDisabled => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
