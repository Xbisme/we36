// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messaging_dao.dart';

// ignore_for_file: type=lint
mixin _$MessagingDaoMixin on DatabaseAccessor<AppDatabase> {
  $ConversationsTable get conversations => attachedDatabase.conversations;
  $MessagesTable get messages => attachedDatabase.messages;
  MessagingDaoManager get managers => MessagingDaoManager(this);
}

class MessagingDaoManager {
  final _$MessagingDaoMixin _db;
  MessagingDaoManager(this._db);
  $$ConversationsTableTableManager get conversations =>
      $$ConversationsTableTableManager(_db.attachedDatabase, _db.conversations);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db.attachedDatabase, _db.messages);
}
