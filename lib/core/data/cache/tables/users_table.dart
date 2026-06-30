import 'package:drift/drift.dart';

/// The one reference cache table (#002): mirrors the `User` domain model + a
/// `cachedAt` staleness marker. Drift's generated row class is `CachedUser` (via
/// [DataClassName]) to avoid clashing with the domain `User`.
@DataClassName('CachedUser')
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get username => text().unique()();
  TextColumn get displayName => text()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get bio => text().nullable()();
  BoolColumn get isPrivate => boolean()();
  BoolColumn get isVerified => boolean()();
  IntColumn get followersCount => integer()();
  IntColumn get followingCount => integer()();
  IntColumn get postsCount => integer()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
