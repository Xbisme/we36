import 'package:drift/drift.dart';

/// Canonical cached feed post (#004) — the single representation every screen
/// reads via `PostsDao.watchHomeFeed` (Constitution IX). Drift's row class is
/// `CachedPost` to avoid clashing with the `Post` domain model. The contract
/// media array is flattened to the first image here (`mediaImageUrl`); carousel
/// storage arrives with compose (#007). Wiped on logout / forced re-login
/// (Constitution I). Order key is [createdAt] (DESC = reverse-chronological).
@DataClassName('CachedPost')
class Posts extends Table {
  TextColumn get id => text()();
  TextColumn get authorId => text()();
  TextColumn get authorUsername => text().nullable()();
  TextColumn get authorDisplayName => text().nullable()();
  TextColumn get authorAvatarUrl => text().nullable()();
  BoolColumn get authorIsVerified => boolean()();
  TextColumn get caption => text().nullable()();
  TextColumn get mediaImageUrl => text().nullable()();
  IntColumn get mediaWidth => integer().nullable()();
  IntColumn get mediaHeight => integer().nullable()();
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
