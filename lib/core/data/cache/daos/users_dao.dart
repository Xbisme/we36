import 'package:drift/drift.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/tables/users_table.dart';
import 'package:we36/core/data/user/user.dart' as domain;

part 'users_dao.g.dart';

/// DAO for the reference cache table. Maps drift rows ↔ the domain `User`, and
/// exposes a reactive `watch` so a single canonical cached value is observed by
/// all readers (Constitution IX).
@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.attachedDatabase);

  Future<void> upsert(domain.User user) =>
      into(users).insertOnConflictUpdate(_toCompanion(user));

  Future<domain.User?> getByUsername(String username) async {
    final row = await (select(
      users,
    )..where((t) => t.username.equals(username))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Stream<domain.User?> watchByUsername(String username) {
    return (select(users)..where((t) => t.username.equals(username)))
        .watchSingleOrNull()
        .map((row) => row == null ? null : _toDomain(row));
  }

  UsersCompanion _toCompanion(domain.User u) => UsersCompanion.insert(
    id: u.id,
    username: u.username,
    displayName: u.displayName,
    avatarUrl: Value(u.avatarUrl),
    bio: Value(u.bio),
    isPrivate: u.isPrivate,
    isVerified: u.isVerified,
    followersCount: u.followersCount,
    followingCount: u.followingCount,
    postsCount: u.postsCount,
    cachedAt: DateTime.now().toUtc(),
  );

  domain.User _toDomain(CachedUser row) => domain.User(
    id: row.id,
    username: row.username,
    displayName: row.displayName,
    avatarUrl: row.avatarUrl,
    bio: row.bio,
    isPrivate: row.isPrivate,
    isVerified: row.isVerified,
    followersCount: row.followersCount,
    followingCount: row.followingCount,
    postsCount: row.postsCount,
  );
}
