import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/daos/me_profile_dao.dart';
import 'package:we36/core/data/cache/daos/posts_dao.dart';
import 'package:we36/core/data/cache/daos/story_seen_dao.dart';
import 'package:we36/core/data/cache/daos/users_dao.dart';
import 'package:we36/core/data/cache/tables/me_profile_table.dart';
import 'package:we36/core/data/cache/tables/posts_table.dart';
import 'package:we36/core/data/cache/tables/story_seen_table.dart';
import 'package:we36/core/data/cache/tables/users_table.dart';

part 'app_database.g.dart';

/// The single local cache database (Constitution IX): reactive reads + versioned,
/// non-destructive migrations. #002 ships the base + the `Users` reference table;
/// #003 adds the single-row `MeProfiles` current-user cache; #004 adds the
/// canonical `Posts` feed cache + `StorySeenSegments` seen-state. Per-feature
/// tables are added by their features.
@lazySingleton
@DriftDatabase(
  tables: [Users, MeProfiles, Posts, StorySeenSegments],
  daos: [UsersDao, MeProfileDao, PostsDao, StorySeenDao],
)
class AppDatabase extends _$AppDatabase {
  /// Production: opens the on-device SQLite file.
  AppDatabase() : super(driftDatabase(name: 'we36'));

  /// Testing seam: inject an in-memory executor (`NativeDatabase.memory()`).
  @visibleForTesting
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Non-destructive, step-wise upgrades (Constitution IX).
      if (from < 2) {
        // v2 (#003): add the single-row current-user cache.
        await m.createTable(meProfiles);
      }
      if (from < 3) {
        // v3 (#004): add the canonical feed cache + story seen-state.
        await m.createTable(posts);
        await m.createTable(storySeenSegments);
      }
    },
  );

  /// Wipe all user-scoped cached data on logout / forced re-login so nothing
  /// leaks to the next account on a shared device (Constitution I; spec FR-012/
  /// FR-013). Device-level state (e.g. onboarding flag) is NOT touched.
  Future<void> clearUserScoped() async {
    await meProfileDao.clear();
    await delete(users).go();
    await delete(posts).go();
    await delete(storySeenSegments).go();
  }
}
