import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/user/user.dart';

/// #002 ships schema v1 (the first schema), so there is no prior version to
/// migrate yet. This proves the migration harness: `onCreate` builds a usable
/// schema. Step-wise `onUpgrade` tests are added when a v2 table change lands.
void main() {
  group('AppDatabase migration harness (US4)', () {
    test('schemaVersion is 1', () {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      expect(db.schemaVersion, 1);
      addTearDown(db.close);
    });

    test('onCreate builds a usable schema (insert + read works)', () async {
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
      expect(await db.usersDao.getByUsername('lan'), isNotNull);
      await db.close();
    });
  });
}
