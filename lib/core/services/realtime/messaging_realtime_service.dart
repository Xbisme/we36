import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/daos/messaging_dao.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/data/messaging/messaging_dto.dart';
import 'package:we36/core/data/realtime/realtime_client.dart';
import 'package:we36/core/data/realtime/realtime_event.dart';
import 'package:we36/core/utils/app_logger.dart';

/// The single subscriber to the realtime socket for Direct Messages (#012,
/// Constitution VIII) — Cubits/widgets never touch [RealtimeClient]. It folds
/// each inbound event into the canonical drift cache (`message.new` → upsert +
/// bump; `message.delivered`/`message.read` → advance delivery) and pushes
/// ephemeral `typing`/`presence` onto transient streams (never persisted, R3).
/// Inbound is deduped by server id / client key so a replayed event appears once
/// (SC-004). A malformed payload is skipped with a redacted warn (Constitution
/// IX) — one bad message never crashes the thread.
@lazySingleton
class MessagingRealtimeService {
  MessagingRealtimeService(this._client, this._db, this._logger) {
    _sub = _client.events.listen(_onEvent);
  }

  final RealtimeClient _client;
  final AppDatabase _db;
  final AppLogger _logger;

  late final StreamSubscription<InboundEvent> _sub;

  MessagingDao get _dao => _db.messagingDao;

  /// Duration a typing indicator stays live without a repeat signal.
  static const Duration _typingTtl = Duration(seconds: 4);

  final StreamController<Map<String, bool>> _presence =
      StreamController<Map<String, bool>>.broadcast();
  final Map<String, bool> _online = {};

  final StreamController<Set<String>> _typing =
      StreamController<Set<String>>.broadcast();
  final Set<String> _typingConversationIds = {};
  final Map<String, Timer> _typingTimers = {};

  /// Transient presence stream: the current `userId → online` map. Decorates
  /// conversation rows + chat headers; not persisted.
  Stream<Map<String, bool>> get presence => _presence.stream;

  /// Whether [userId] is currently online (last known).
  bool isOnline(String userId) => _online[userId] ?? false;

  /// Transient typing stream: the set of conversation ids with a live typing
  /// signal.
  Stream<Set<String>> get typing => _typing.stream;

  /// Whether [conversationId] currently has a live typing signal.
  bool isTyping(String conversationId) =>
      _typingConversationIds.contains(conversationId);

  Future<void> _onEvent(InboundEvent event) async {
    try {
      switch (event) {
        case MessageNew(:final conversationId, :final message):
          await _onMessageNew(conversationId, message);
        case MessageDelivered(:final messageId):
          await _dao.advanceDelivery(
            serverId: messageId,
            state: DeliveryState.delivered,
          );
        case MessageReadEvent(:final messageId):
          await _dao.advanceDelivery(
            serverId: messageId,
            state: DeliveryState.read,
          );
        case TypingInbound(:final conversationId):
          _onTyping(conversationId);
        case PresenceUpdate(:final userId, :final online):
          _onPresence(userId, online: online);
        case UnknownInbound() || NotificationNew():
          // Ignored by #012 (notifications are #013; unknowns are forward-compat).
          break;
      }
    } on Object catch (e) {
      // One bad payload must not crash the pipeline (redacted — no bodies/ids).
      _logger.warn('Dropped a malformed realtime event', data: {'e': '$e'});
    }
  }

  Future<void> _onMessageNew(
    String conversationId,
    Map<String, dynamic> raw,
  ) async {
    final serverId = raw['id'] as String?;
    // A real server message always carries an id; without one the payload is
    // malformed — skip it (one bad event never pollutes the thread).
    if (serverId == null) {
      _logger.warn('Dropped a message.new with no id');
      return;
    }
    // Dedupe by server id (reconnect replay → exactly once, SC-004).
    if (await _dao.hasServerMessage(serverId)) return;

    final incoming = messageFromWire(
      raw,
      isMine: false,
      conversationId: conversationId,
    );

    // If this echoes my own optimistic send (same clientKey already cached),
    // reconcile that row to `sent` instead of inserting a second bubble.
    final clientKey = raw['clientKey'] as String?;
    if (clientKey != null && await _dao.getByClientKey(clientKey) != null) {
      await _dao.advanceDelivery(
        clientKey: clientKey,
        state: DeliveryState.sent,
      );
      return;
    }

    await _dao.upsertMessage(
      incoming.copyWith(deliveryState: DeliveryState.read),
    );
    // Bump the conversation (preview + activity + unread) if it is cached.
    await _dao.bumpForInbound(
      conversationId,
      at: incoming.createdAt,
      preview: incoming.previewBody,
    );
  }

  void _onTyping(String conversationId) {
    _typingConversationIds.add(conversationId);
    if (!_typing.isClosed) _typing.add(Set.of(_typingConversationIds));
    _typingTimers[conversationId]?.cancel();
    _typingTimers[conversationId] = Timer(_typingTtl, () {
      _typingConversationIds.remove(conversationId);
      if (!_typing.isClosed) _typing.add(Set.of(_typingConversationIds));
    });
  }

  void _onPresence(String userId, {required bool online}) {
    _online[userId] = online;
    if (!_presence.isClosed) _presence.add(Map.of(_online));
  }

  /// Tear down (call when retiring the singleton / in tests).
  Future<void> dispose() async {
    await _sub.cancel();
    for (final t in _typingTimers.values) {
      t.cancel();
    }
    await _presence.close();
    await _typing.close();
  }
}
