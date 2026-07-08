import 'package:drift/drift.dart';

/// The persisted Activity feed (#013) — the one canonical notification copy
/// (Constitution IX), cached so the Activity screen opens to content on a cold
/// start / offline (spec FR-012). Each row is one server-grouped
/// `NotificationEntry`; actors + target are stored as JSON. Ordered by
/// [updatedAt] (latest activity, desc) — the feed keyset + time bucket. Read
/// state ([isRead]) mirrors the server marker; the unread count is NOT derived
/// from these rows (it rides the badge seam). Wiped on logout. Drift's row class
/// is `CachedNotification` to avoid clashing with the domain model.
@DataClassName('CachedNotification')
class Notifications extends Table {
  /// Server group id — the primary key (dedupe key for live folds).
  TextColumn get id => text()();

  /// `NotificationType` wire name.
  TextColumn get type => text()();

  /// JSON-encoded `List<ActorCard>` (most-recent actors, newest first).
  TextColumn get actorsJson => text()();

  /// Total distinct actors ("and N others" = actorCount - 1).
  IntColumn get actorCount => integer().withDefault(const Constant(1))();

  /// JSON-encoded `NotificationTarget` (null when deleted / not visible).
  TextColumn get targetJson => text().nullable()();

  /// Server read flag at fetch/fold time (drives the unread accent).
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();

  /// First activity time.
  DateTimeColumn get createdAt => dateTime()();

  /// Latest activity time — feed order key (desc) + time-section bucket.
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
