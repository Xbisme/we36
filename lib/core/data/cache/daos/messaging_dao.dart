import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/tables/conversations_table.dart';
import 'package:we36/core/data/cache/tables/messages_table.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/data/messaging/message.dart';

part 'messaging_dao.g.dart';

/// DAO for the persisted Direct-Messages cache (#012): the conversation list +
/// per-conversation message threads (the latter also the offline outbox). Maps
/// drift rows ↔ domain [Conversation]/[Message], exposes the reactive reads the
/// list + chat watch, and clears on logout (Constitution I/IX). Dedupe of
/// inbound/echoed messages is by [Message.clientKey] (primary key) — an upsert on
/// the same key updates in place, so a message never appears twice (SC-004).
@DriftAccessor(tables: [Conversations, Messages])
class MessagingDao extends DatabaseAccessor<AppDatabase>
    with _$MessagingDaoMixin {
  MessagingDao(super.attachedDatabase);

  // ---- conversations -----------------------------------------------------

  /// Reactive conversation list, newest-activity first — the render source for
  /// the Messages tab (transient typing/presence are decorated by the Cubit).
  Stream<List<Conversation>> watchConversations() {
    final query = select(conversations)
      ..orderBy([(t) => OrderingTerm.desc(t.lastActivityAt)]);
    return query.watch().map((rows) => rows.map(_toConversation).toList());
  }

  /// One-shot conversation read (reconcile checks / tests).
  Future<List<Conversation>> getConversations() async {
    final query = select(conversations)
      ..orderBy([(t) => OrderingTerm.desc(t.lastActivityAt)]);
    return (await query.get()).map(_toConversation).toList();
  }

  /// Upsert a single conversation (list reconcile / realtime bump).
  Future<void> upsertConversation(Conversation c) =>
      into(conversations).insertOnConflictUpdate(_conversationCompanion(c));

  /// Upsert many conversations (first load / page reconcile).
  Future<void> upsertConversations(List<Conversation> list) => batch(
    (b) => b.insertAllOnConflictUpdate(
      conversations,
      list.map(_conversationCompanion).toList(),
    ),
  );

  /// One-shot conversation read by id.
  Future<Conversation?> getConversation(String id) async {
    final row = await (select(
      conversations,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toConversation(row);
  }

  /// Clear a conversation's unread count on view (mark-read).
  Future<void> markConversationRead(String id) =>
      (update(conversations)..where((t) => t.id.equals(id))).write(
        const ConversationsCompanion(unreadCount: Value(0)),
      );

  /// Apply an inbound message to a cached conversation — refresh the preview +
  /// activity and increment unread. No-op if the conversation is not cached.
  Future<void> bumpForInbound(
    String conversationId, {
    required DateTime at,
    String? preview,
  }) async {
    final existing = await (select(
      conversations,
    )..where((t) => t.id.equals(conversationId))).getSingleOrNull();
    if (existing == null) return;
    await (update(
      conversations,
    )..where((t) => t.id.equals(conversationId))).write(
      ConversationsCompanion(
        lastMessagePreview: Value(preview),
        lastActivityAt: Value(at),
        unreadCount: Value(existing.unreadCount + 1),
      ),
    );
  }

  // ---- messages (thread + outbox) ---------------------------------------

  /// Reactive thread for [conversationId], oldest→newest — the chat render
  /// source. One canonical copy per message.
  Stream<List<Message>> watchThread(String conversationId) {
    final query = select(messages)
      ..where((t) => t.conversationId.equals(conversationId))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    return query.watch().map((rows) => rows.map(_toMessage).toList());
  }

  /// One-shot thread read (paging reconcile / tests).
  Future<List<Message>> getThread(String conversationId) async {
    final query = select(messages)
      ..where((t) => t.conversationId.equals(conversationId))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    return (await query.get()).map(_toMessage).toList();
  }

  /// Upsert a single message. Deduped by **server id when present** (a server
  /// echo / history reload of an optimistic send carries the same `serverId` but
  /// a different `clientKey` — reuse the existing row's `clientKey` so it merges
  /// in place instead of duplicating), else by [Message.clientKey].
  Future<void> upsertMessage(Message m) async {
    final serverId = m.serverId;
    if (serverId != null) {
      // Use get() (not getSingleOrNull) — a device that accumulated duplicates
      // before this dedup landed can have >1 row per serverId; collapse them.
      final existing = await (select(
        messages,
      )..where((t) => t.serverId.equals(serverId))).get();
      if (existing.isNotEmpty) {
        final keep = existing.first.clientKey;
        if (existing.length > 1) {
          await (delete(messages)..where(
                (t) =>
                    t.serverId.equals(serverId) &
                    t.clientKey.equals(keep).not(),
              ))
              .go();
        }
        await into(messages).insertOnConflictUpdate(
          _messageCompanion(m.copyWith(clientKey: keep)),
        );
        return;
      }
    }
    await into(messages).insertOnConflictUpdate(_messageCompanion(m));
  }

  /// Upsert many messages (history page reconcile) — each server-id-deduped.
  Future<void> upsertMessages(List<Message> list) async {
    for (final m in list) {
      await upsertMessage(m);
    }
  }

  /// Whether a message with [serverId] is already cached (inbound dedupe).
  Future<bool> hasServerMessage(String serverId) async {
    final rows = await (select(
      messages,
    )..where((t) => t.serverId.equals(serverId))).get();
    return rows.isNotEmpty;
  }

  /// One-shot message read by client key (echo reconcile / retry).
  Future<Message?> getByClientKey(String clientKey) async {
    final row = await (select(
      messages,
    )..where((t) => t.clientKey.equals(clientKey))).getSingleOrNull();
    return row == null ? null : _toMessage(row);
  }

  /// Advance a message's delivery state (POST reconcile / receipts). Matches by
  /// [clientKey] when given, else by [serverId].
  Future<void> advanceDelivery({
    required DeliveryState state,
    String? clientKey,
    String? serverId,
  }) {
    final query = update(messages)
      ..where(
        (t) => clientKey != null
            ? t.clientKey.equals(clientKey)
            : t.serverId.equals(serverId!),
      );
    return query.write(
      MessagesCompanion(deliveryState: Value(state.name)),
    );
  }

  /// Mark my own sent messages in a conversation as `read` — the peer's read
  /// receipt (`message.read` carries an `upToMessageId`; we read the whole
  /// thread for simplicity). Only touches delivered/sent rows.
  Future<void> markMineRead(String conversationId) =>
      (update(messages)..where(
            (t) =>
                t.conversationId.equals(conversationId) & t.isMine.equals(true),
          ))
          .write(const MessagesCompanion(deliveryState: Value('read')));

  /// The offline outbox — messages still `sending` or `failed`, oldest first,
  /// flushed on reconnect (R4/SC-006).
  Future<List<Message>> pendingOutbox() async {
    final query = select(messages)
      ..where(
        (t) => t.deliveryState.isIn([
          DeliveryState.sending.name,
          DeliveryState.failed.name,
        ]),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    return (await query.get()).map(_toMessage).toList();
  }

  /// Clear all messaging cache on logout / forced re-login.
  Future<void> clearUserScoped() => transaction(() async {
    await delete(messages).go();
    await delete(conversations).go();
  });

  // ---- mapping -----------------------------------------------------------

  ConversationsCompanion _conversationCompanion(Conversation c) =>
      ConversationsCompanion.insert(
        id: c.id,
        participantJson: jsonEncode(c.participant.toJson()),
        lastActivityAt: c.lastActivityAt,
        lastMessagePreview: Value(c.lastMessagePreview),
        unreadCount: Value(c.unreadCount),
      );

  Conversation _toConversation(CachedConversation row) => Conversation(
    id: row.id,
    participant: UserSummary.fromJson(
      (jsonDecode(row.participantJson) as Map).cast<String, dynamic>(),
    ),
    lastActivityAt: row.lastActivityAt,
    unreadCount: row.unreadCount,
    lastMessagePreview: row.lastMessagePreview,
  );

  MessagesCompanion _messageCompanion(Message m) => MessagesCompanion.insert(
    clientKey: m.clientKey,
    serverId: Value(m.serverId),
    conversationId: m.conversationId,
    authorId: m.authorId,
    isMine: m.isMine,
    kind: m.kind.name,
    contentJson: jsonEncode(m.content.toJson()),
    createdAt: m.createdAt,
    deliveryState: m.deliveryState.name,
  );

  Message _toMessage(CachedMessage row) => Message(
    clientKey: row.clientKey,
    serverId: row.serverId,
    conversationId: row.conversationId,
    authorId: row.authorId,
    isMine: row.isMine,
    kind: MessageKind.values.byName(row.kind),
    content: MessageContent.fromJson(
      (jsonDecode(row.contentJson) as Map).cast<String, dynamic>(),
    ),
    createdAt: row.createdAt,
    deliveryState: DeliveryState.values.byName(row.deliveryState),
  );
}
