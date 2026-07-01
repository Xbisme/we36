import 'package:drift/drift.dart' show Migrator;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/data/user/user.dart';

/// Cache schema migration harness. #003 → v2 (`MeProfiles`); #004 → v3 (`Posts`
/// feed cache + `StorySeenSegments` seen-state); #007 → v4 (`ComposeDrafts`
/// single persisted draft). These tests prove: `onCreate` builds the full current
/// schema, the `onUpgrade` steps are non-destructive and additive, and
/// `clearUserScoped` wipes all user-scoped data on logout (Constitution IX/I).
ComposeDraftRow _draft(String id) => ComposeDraftRow(
  id: id,
  idempotencyKey: 'key-$id',
  payload: '{}',
  createdAt: DateTime.utc(2026, 7),
  updatedAt: DateTime.utc(2026, 7),
);

Post _post(String id) => Post(
  id: id,
  author: const UserSummary(id: 'u1', username: 'lan', isVerified: false),
  media: const [],
  hashtags: const [],
  taggedUsers: const [],
  commentsDisabled: false,
  likeCount: 10,
  saveCount: 0,
  commentCount: 0,
  viewerHasLiked: false,
  viewerHasSaved: false,
  createdAt: DateTime.utc(2026, 7),
);

MeProfile _me(String id) => MeProfile(
  id: id,
  email: '$id@we36.app',
  isPrivate: false,
  isVerified: false,
  profileCompleted: true,
  createdAt: DateTime.utc(2026),
);

void main() {
  group('AppDatabase migration harness', () {
    test('schemaVersion is 4', () {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      expect(db.schemaVersion, 4);
      addTearDown(db.close);
    });

    test('onCreate builds a usable v4 schema (all tables)', () async {
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
      await db.meProfileDao.upsert(_me('me-1'));
      await db.postsDao.upsertAll([_post('post-1')]);
      await db.storySeenDao.markSeen('seg-1', 'author-1');
      await db.composeDraftDao.save(_draft('draft-1'));

      expect(await db.usersDao.getByUsername('lan'), isNotNull);
      expect(await db.meProfileDao.get(), isNotNull);
      expect(await db.postsDao.getById('post-1'), isNotNull);
      expect(await db.storySeenDao.getSeen(), contains('seg-1'));
      expect(await db.composeDraftDao.current(), isNotNull);
      await db.close();
    });

    test(
      'onUpgrade(from<4) additively creates the compose draft table',
      () async {
        final db = AppDatabase.forTesting(NativeDatabase.memory());
        // Simulate a pre-v4 DB: drop the v4 table, keep a v3 row, run onUpgrade.
        await db.postsDao.upsertAll([_post('post-keep')]);
        await db.customStatement('DROP TABLE compose_drafts');

        await db.migration.onUpgrade(Migrator(db), 3, 4);

        // New table usable; the older post row survived (non-destructive).
        await db.composeDraftDao.save(_draft('draft-after'));
        expect(await db.composeDraftDao.current(), isNotNull);
        expect(await db.postsDao.getById('post-keep'), isNotNull);
        await db.close();
      },
    );

    test('onUpgrade(from<3) additively recreates the v3 tables', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      // Simulate a pre-v3 DB: drop the tables the v3 step introduces, then run
      // the real onUpgrade branch and prove it rebuilds them (non-destructive to
      // the pre-existing users/meProfiles).
      await db.meProfileDao.upsert(_me('me-keep'));
      await db.customStatement('DROP TABLE posts');
      await db.customStatement('DROP TABLE story_seen_segments');

      await db.migration.onUpgrade(Migrator(db), 2, 3);

      // New tables usable again; the older row survived.
      await db.postsDao.upsertAll([_post('post-after')]);
      await db.storySeenDao.markSeen('seg-after', 'a1');
      expect(await db.postsDao.getById('post-after'), isNotNull);
      expect(await db.storySeenDao.getSeen(), contains('seg-after'));
      expect(await db.meProfileDao.get(), isNotNull);
      await db.close();
    });

    test(
      'clearUserScoped wipes users + meProfiles + posts + seen + draft',
      () async {
        final db = AppDatabase.forTesting(NativeDatabase.memory());
        await db.meProfileDao.upsert(_me('me-3'));
        await db.postsDao.upsertAll([_post('post-x')]);
        await db.storySeenDao.markSeen('seg-x', 'author-x');
        await db.composeDraftDao.save(_draft('draft-x'));

        await db.clearUserScoped();

        expect(await db.meProfileDao.get(), isNull);
        expect(await db.postsDao.getById('post-x'), isNull);
        expect(await db.storySeenDao.getSeen(), isEmpty);
        expect(await db.composeDraftDao.current(), isNull);
        await db.close();
      },
    );
  });
}
