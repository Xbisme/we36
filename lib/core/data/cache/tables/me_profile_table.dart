import 'package:drift/drift.dart';

/// Single-row cache of the authenticated user (#003) — lets the app open to the
/// last-known profile instantly and route offline on cold start (the
/// [profileCompleted] mirror). Drift's row class is `CachedMeProfile` to avoid
/// clashing with the `MeProfile` domain model. Wiped on logout / forced
/// re-login (Constitution I).
@DataClassName('CachedMeProfile')
class MeProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get username => text().nullable()();
  TextColumn get displayName => text().nullable()();
  TextColumn get avatarMediaId => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get bio => text().nullable()();
  TextColumn get website => text().nullable()();
  TextColumn get pronouns => text().nullable()();
  BoolColumn get isPrivate => boolean()();
  BoolColumn get isVerified => boolean()();
  BoolColumn get profileCompleted => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
