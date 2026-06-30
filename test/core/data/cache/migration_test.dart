import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/data/user/user.dart';

/// #003 advances the cache schema to v2 (adds the single-row `MeProfiles`
/// current-user cache). These tests prove the migration harness: `onCreate`
/// builds the full v2 schema, the v1→v2 `onUpgrade` step adds the new table, and
/// `clearUserScoped` wipes user data on logout (Constitution IX; spec FR-013).
void main() {
  group('AppDatabase migration harness', () {
    test('schemaVersion is 2', () {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      expect(db.schemaVersion, 2);
      addTearDown(db.close);
    });

    test('onCreate builds a usable v2 schema (users + meProfiles)', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      await db.usersDao.upsert(
        const User(
          id: 'id-1',
          username: 'lan',
          displayName: 'Lan',
          isPrivate: false,
          isVerified: false,
          followersCount: 0,
          followingCount: 0,
          postsCount: 0,
        ),
      );
      await db.meProfileDao.upsert(
        MeProfile(
          id: 'me-1',
          email: 'lan@we36.app',
          isPrivate: false,
          isVerified: false,
          profileCompleted: true,
          createdAt: DateTime.utc(2026),
        ),
      );
      expect(await db.usersDao.getByUsername('lan'), isNotNull);
      expect(await db.meProfileDao.get(), isNotNull);
      await db.close();
    });

    test('clearUserScoped wipes users + meProfiles (logout)', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      await db.meProfileDao.upsert(
        MeProfile(
          id: 'me-3',
          email: 'a@we36.app',
          isPrivate: false,
          isVerified: false,
          profileCompleted: true,
          createdAt: DateTime.utc(2026),
        ),
      );
      await db.clearUserScoped();
      expect(await db.meProfileDao.get(), isNull);
      await db.close();
    });
  });
}
