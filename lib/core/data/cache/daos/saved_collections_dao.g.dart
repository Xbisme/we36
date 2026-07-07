// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_collections_dao.dart';

// ignore_for_file: type=lint
mixin _$SavedCollectionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SavedCollectionsTable get savedCollections =>
      attachedDatabase.savedCollections;
  SavedCollectionsDaoManager get managers => SavedCollectionsDaoManager(this);
}

class SavedCollectionsDaoManager {
  final _$SavedCollectionsDaoMixin _db;
  SavedCollectionsDaoManager(this._db);
  $$SavedCollectionsTableTableManager get savedCollections =>
      $$SavedCollectionsTableTableManager(
        _db.attachedDatabase,
        _db.savedCollections,
      );
}
