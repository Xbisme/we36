import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/daos/users_dao.dart';
import 'package:we36/core/data/cache/tables/users_table.dart';

part 'app_database.g.dart';

/// The single local cache database (Constitution IX): reactive reads + versioned,
/// non-destructive migrations. #002 ships the base + the one reference table
/// (`Users`); per-feature tables are added by their features.
@lazySingleton
@DriftDatabase(tables: [Users], daos: [UsersDao])
class AppDatabase extends _$AppDatabase {
  /// Production: opens the on-device SQLite file.
  AppDatabase() : super(driftDatabase(name: 'we36'));

  /// Testing seam: inject an in-memory executor (`NativeDatabase.memory()`).
  @visibleForTesting
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Non-destructive, step-wise upgrades land here as the schema grows
      // (Constitution IX). v1 is the initial schema — nothing to migrate yet.
    },
  );
}
