// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_dao.dart';

// ignore_for_file: type=lint
mixin _$ExploreDaoMixin on DatabaseAccessor<AppDatabase> {
  $ExploreItemsTable get exploreItems => attachedDatabase.exploreItems;
  ExploreDaoManager get managers => ExploreDaoManager(this);
}

class ExploreDaoManager {
  final _$ExploreDaoMixin _db;
  ExploreDaoManager(this._db);
  $$ExploreItemsTableTableManager get exploreItems =>
      $$ExploreItemsTableTableManager(_db.attachedDatabase, _db.exploreItems);
}
