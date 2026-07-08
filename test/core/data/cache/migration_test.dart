import 'package:drift/drift.dart' show Migrator;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/data/user/user.dart';

/// Cache schema migration harness. #003 → v2 (`MeProfiles`); #004 → v3 (`Posts`
/// feed cache + `StorySeenSegments` seen-state); #007 → v4 (`ComposeDrafts`
/// single persisted draft); #008 → v5 (`Reels` feed cache). These tests prove:
/// `onCreate` builds the full current schema, the `onUpgrade` steps are
/// non-destructive and additive, and `clearUserScoped` wipes all user-scoped data
/// on logout (Constitution IX/I).
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

Reel _reel(String id) => Reel(
  id: id,
  author: const UserSummary(id: 'u1', username: 'lan', isVerified: false),
  video: const Media(
    id: 'v-1',
    kind: MediaKind.video,
    status: MediaStatus.ready,
  ),
  hashtags: const [],
  taggedUsers: const [],
  commentsDisabled: false,
  likeCount: 5,
  saveCount: 0,
  commentCount: 0,
  viewerHasLiked: false,
  viewerHasSaved: false,
  isVideoReady: true,
  createdAt: DateTime.utc(2026, 7),
);

SavedCollection _collection(String id) => SavedCollection(
  id: id,
  name: 'Board $id',
  itemCount: 0,
  updatedAt: DateTime.utc(2026),
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
    test('schemaVersion is 9', () {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      expect(db.schemaVersion, 9);
      addTearDown(db.close);
    });

    test(
      'onUpgrade(from<9) additively creates the messaging tables (#012)',
      () async {
        final db = AppDatabase.forTesting(NativeDatabase.memory());
        addTearDown(db.close);
        // Simulate a v8 DB upgrading to v9: Conversations + Messages are added.
        await db.migration.onUpgrade(Migrator(db), 8, 9);
        // Write+read round-trips prove the tables exist and are usable.
        await db.messagingDao.markConversationRead('none');
        expect(await db.messagingDao.getConversations(), isEmpty);
        expect(await db.messagingDao.getThread('none'), isEmpty);
      },
    );

    test(
      'onUpgrade(from<8) additively creates the saved-collections table (#011)',
      () async {
        final db = AppDatabase.forTesting(NativeDatabase.memory());
        addTearDown(db.close);
        // Simulate a v7 DB upgrading to v8: the SavedCollections table is added.
        await db.migration.onUpgrade(Migrator(db), 7, 8);
        // A write+read round-trip proves the table exists and is usable.
        await db.savedCollectionsDao.replaceAll(const []);
        expect(await db.savedCollectionsDao.getCollections(), isEmpty);
      },
    );

    test(
      'onUpgrade(from<7) additively creates the explore-items table (#009)',
      () async {
        final db = AppDatabase.forTesting(NativeDatabase.memory());
        addTearDown(db.close);
        // Simulate a v6 DB upgrading to v7: the ExploreItems table is added.
        await db.migration.onUpgrade(Migrator(db), 6, 7);
        // A write+read round-trip proves the table exists and is usable.
        await db.exploreDao.replaceAll(const []);
        expect(await db.exploreDao.watchExplore().first, isEmpty);
      },
    );

    test(
      'onUpgrade(from<6) additively adds the post media-urls column',
      () async {
        final db = AppDatabase.forTesting(NativeDatabase.memory());
        await db.postsDao.upsertAll([_post('post-keep')]);
        await db.customStatement(
          'ALTER TABLE posts DROP COLUMN media_urls_json',
        );
        await db.migration.onUpgrade(Migrator(db), 5, 6);
        // Column back + the older row survived (non-destructive).
        expect(await db.postsDao.getById('post-keep'), isNotNull);
        await db.close();
      },
    );

    test('onCreate builds a usable v5 schema (all tables)', () async {
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
      await db.reelsDao.upsertAll([_reel('reel-1')]);

      expect(await db.usersDao.getByUsername('lan'), isNotNull);
      expect(await db.meProfileDao.get(), isNotNull);
      expect(await db.postsDao.getById('post-1'), isNotNull);
      expect(await db.storySeenDao.getSeen(), contains('seg-1'));
      expect(await db.composeDraftDao.current(), isNotNull);
      expect(await db.reelsDao.getById('reel-1'), isNotNull);
      await db.close();
    });

    test(
      'onUpgrade(from<5) additively creates the reels table',
      () async {
        final db = AppDatabase.forTesting(NativeDatabase.memory());
        // Simulate a pre-v5 DB: drop the v5 table + v6 column, keep a v4 row.
        await db.postsDao.upsertAll([_post('post-keep')]);
        await db.customStatement('DROP TABLE reels');
        await db.customStatement(
          'ALTER TABLE posts DROP COLUMN media_urls_json',
        );

        await db.migration.onUpgrade(Migrator(db), 4, 6);

        // New table usable; the older post row survived (non-destructive).
        await db.reelsDao.upsertAll([_reel('reel-after')]);
        expect(await db.reelsDao.getById('reel-after'), isNotNull);
        expect(await db.postsDao.getById('post-keep'), isNotNull);
        await db.close();
      },
    );

    test(
      'onUpgrade(from<4) additively creates the compose draft table',
      () async {
        final db = AppDatabase.forTesting(NativeDatabase.memory());
        // Simulate a pre-v4 DB: drop the v4 table + v6 column, keep a v3 row.
        await db.postsDao.upsertAll([_post('post-keep')]);
        await db.customStatement('DROP TABLE compose_drafts');
        await db.customStatement(
          'ALTER TABLE posts DROP COLUMN media_urls_json',
        );

        await db.migration.onUpgrade(Migrator(db), 3, 6);

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
        await db.reelsDao.upsertAll([_reel('reel-x')]);
        await db.savedCollectionsDao.replaceAll([_collection('col-x')]);

        await db.clearUserScoped();

        expect(await db.meProfileDao.get(), isNull);
        expect(await db.postsDao.getById('post-x'), isNull);
        expect(await db.storySeenDao.getSeen(), isEmpty);
        expect(await db.composeDraftDao.current(), isNull);
        expect(await db.reelsDao.getById('reel-x'), isNull);
        expect(await db.savedCollectionsDao.getCollections(), isEmpty);
        await db.close();
      },
    );
  });
}
