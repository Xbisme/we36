import 'package:drift/drift.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/tables/me_profile_table.dart';
import 'package:we36/core/data/me/me_profile.dart' as domain;

part 'me_profile_dao.g.dart';

/// DAO for the single-row current-user cache. Maps drift rows ↔ the
/// [domain.MeProfile], exposes a reactive [watch], and a [clear] used when
/// wiping user-scoped data on logout (Constitution I/IX).
@DriftAccessor(tables: [MeProfiles])
class MeProfileDao extends DatabaseAccessor<AppDatabase>
    with _$MeProfileDaoMixin {
  MeProfileDao(super.attachedDatabase);

  Future<void> upsert(domain.MeProfile profile) =>
      into(meProfiles).insertOnConflictUpdate(_toCompanion(profile));

  Future<domain.MeProfile?> get() async {
    final row = await select(meProfiles).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Stream<domain.MeProfile?> watch() => select(
    meProfiles,
  ).watchSingleOrNull().map((row) => row == null ? null : _toDomain(row));

  Future<void> clear() => delete(meProfiles).go();

  MeProfilesCompanion _toCompanion(domain.MeProfile p) =>
      MeProfilesCompanion.insert(
        id: p.id,
        email: p.email,
        username: Value(p.username),
        displayName: Value(p.displayName),
        avatarMediaId: Value(p.avatarMediaId),
        avatarUrl: Value(p.avatarUrl),
        bio: Value(p.bio),
        website: Value(p.website),
        pronouns: Value(p.pronouns),
        isPrivate: p.isPrivate,
        isVerified: p.isVerified,
        profileCompleted: p.profileCompleted,
        createdAt: p.createdAt,
        cachedAt: DateTime.now().toUtc(),
      );

  domain.MeProfile _toDomain(CachedMeProfile row) => domain.MeProfile(
    id: row.id,
    email: row.email,
    username: row.username,
    displayName: row.displayName,
    avatarMediaId: row.avatarMediaId,
    avatarUrl: row.avatarUrl,
    bio: row.bio,
    website: row.website,
    pronouns: row.pronouns,
    isPrivate: row.isPrivate,
    isVerified: row.isVerified,
    profileCompleted: row.profileCompleted,
    createdAt: row.createdAt,
  );
}
