// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_seen_dao.dart';

// ignore_for_file: type=lint
mixin _$StorySeenDaoMixin on DatabaseAccessor<AppDatabase> {
  $StorySeenSegmentsTable get storySeenSegments =>
      attachedDatabase.storySeenSegments;
  StorySeenDaoManager get managers => StorySeenDaoManager(this);
}

class StorySeenDaoManager {
  final _$StorySeenDaoMixin _db;
  StorySeenDaoManager(this._db);
  $$StorySeenSegmentsTableTableManager get storySeenSegments =>
      $$StorySeenSegmentsTableTableManager(
        _db.attachedDatabase,
        _db.storySeenSegments,
      );
}
