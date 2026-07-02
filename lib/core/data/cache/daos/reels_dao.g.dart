// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reels_dao.dart';

// ignore_for_file: type=lint
mixin _$ReelsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ReelsTable get reels => attachedDatabase.reels;
  ReelsDaoManager get managers => ReelsDaoManager(this);
}

class ReelsDaoManager {
  final _$ReelsDaoMixin _db;
  ReelsDaoManager(this._db);
  $$ReelsTableTableManager get reels =>
      $$ReelsTableTableManager(_db.attachedDatabase, _db.reels);
}
