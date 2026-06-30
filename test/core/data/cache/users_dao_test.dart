import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/user/user.dart';

User _user(String username) => User(
  id: 'id-$username',
  username: username,
  displayName: username,
  isPrivate: false,
  isVerified: false,
  followersCount: 10,
  followingCount: 5,
  postsCount: 2,
);

void main() {
  group('UsersDao (US4 / SC-005)', () {
    test('data survives a DB restart (reopen the same file)', () async {
      final dir = await Directory.systemTemp.createTemp('we36_dao');
      final file = File('${dir.path}/we36.sqlite');

      var db = AppDatabase.forTesting(NativeDatabase(file));
      await db.usersDao.upsert(_user('maivu'));
      await db.close();

      // Relaunch: a fresh connection to the same file.
      db = AppDatabase.forTesting(NativeDatabase(file));
      final got = await db.usersDao.getByUsername('maivu');
      expect(got, isNotNull);
      expect(got!.username, 'maivu');
      await db.close();
      await dir.delete(recursive: true);
    });

    test('watchByUsername emits the updated value reactively', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final emissions = <User?>[];
      final sub = db.usersDao.watchByUsername('lan').listen(emissions.add);

      await db.usersDao.upsert(_user('lan'));
      await db.usersDao.upsert(_user('lan').copyWith(followersCount: 999));
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final users = emissions.whereType<User>().toList();
      expect(users.last.followersCount, 999); // single canonical value, updated
      await sub.cancel();
      await db.close();
    });
  });
}
