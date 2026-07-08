import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/cache/daos/messaging_dao.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/data/messaging/messaging_remote_data_source.dart';
import 'package:we36/core/data/messaging/messaging_repository.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/data/realtime/realtime_client.dart';
import 'package:we36/core/data/realtime/realtime_event.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/session/session_controller.dart';

/// Real [MessagingRepository] (`env:['real']`). Conversations + threads are read
/// reactively from the drift cache (one canonical copy, Constitution IX); sends
/// are optimistic + idempotent over REST (R1) and reconcile the cached row in
/// place; typing/read ride the socket. The `Messages` table is the outbox —
/// `sending`/`failed` rows are re-sent on reconnect (SC-006). Inbound socket
/// events are folded into the cache by `MessagingRealtimeService`.
@LazySingleton(as: MessagingRepository, env: ['real'])
class MessagingRepositoryImpl implements MessagingRepository {
  MessagingRepositoryImpl(this._remote, this._db, this._client, this._session) {
    _connSub = _client.connectionState.listen((state) {
      if (state is RtConnected) unawaited(_flushOutbox());
    });
  }

  final MessagingRemoteDataSource _remote;
  final AppDatabase _db;
  final RealtimeClient _client;
  final SessionController _session;
  final Uuid _uuid = const Uuid();
  late final StreamSubscription<RealtimeConnectionState> _connSub;

  MessagingDao get _dao => _db.messagingDao;
  String get _myId => _session.profile?.id ?? 'me';

  @override
  Stream<List<Conversation>> watchConversations() => _dao.watchConversations();

  @override
  Future<Result<void>> refreshConversations() async {
    // List both the accepted inbox and pending requests — v1.0 surfaces both in
    // one list (no separate requests-inbox, clarified).
    final primary = await _remote.listConversations();
    if (primary.isErr) return Result<void>.err(primary.failureOrNull!);
    await _dao.upsertConversations(primary.valueOrNull!.items);
    final requests = await _remote.listConversations(filter: 'requests');
    // A failure listing requests must not blank the primary list — best-effort.
    if (requests.isOk) {
      await _dao.upsertConversations(requests.valueOrNull!.items);
    }
    return const Result<void>.ok(null);
  }

  @override
  Stream<List<Message>> watchThread(String conversationId) =>
      _dao.watchThread(conversationId);

  @override
  Future<Result<CursorPage<Message>>> loadHistory(
    String conversationId, {
    String? cursor,
  }) async {
    final res = await _remote.history(
      conversationId,
      currentUserId: _myId,
      cursor: cursor,
    );
    return res.fold((page) async {
      await _dao.upsertMessages(page.items);
      return Result<CursorPage<Message>>.ok(page);
    }, (f) => Future.value(Result<CursorPage<Message>>.err(f)));
  }

  @override
  Future<Result<Message>> sendText(String conversationId, String body) => _send(
    conversationId,
    MessageKind.text,
    MessageContent.text(body: body),
    {'body': body},
  );

  @override
  Future<Result<Message>> sendPhoto(String conversationId, String mediaId) =>
      _send(
        conversationId,
        MessageKind.photo,
        MessageContent.photo(mediaId: mediaId),
        {'mediaId': mediaId},
      );

  @override
  Future<Result<Message>> sendSharedPost(String conversationId, PostRef ref) =>
      _send(
        conversationId,
        MessageKind.sharedPost,
        MessageContent.sharedPost(ref: ref),
        {'sharedPostId': ref.id},
      );

  @override
  Future<Result<Message>> sendSticker(String conversationId, String glyphId) =>
      _send(
        conversationId,
        MessageKind.sticker,
        MessageContent.sticker(glyphId: glyphId),
        {'stickerId': glyphId},
      );

  Future<Result<Message>> _send(
    String conversationId,
    MessageKind kind,
    MessageContent content,
    Map<String, dynamic> wireContent,
  ) async {
    final clientKey = _uuid.v7();
    final optimistic = Message(
      clientKey: clientKey,
      conversationId: conversationId,
      authorId: _myId,
      isMine: true,
      kind: kind,
      content: content,
      createdAt: DateTime.now().toUtc(),
      deliveryState: DeliveryState.sending,
    );
    await _dao.upsertMessage(optimistic);
    return _post(conversationId, clientKey, kind, wireContent);
  }

  Future<Result<Message>> _post(
    String conversationId,
    String clientKey,
    MessageKind kind,
    Map<String, dynamic> wireContent,
  ) async {
    final res = await _remote.send(
      conversationId,
      clientKey: clientKey,
      kind: kind,
      content: wireContent,
    );
    return res.fold(
      (serverMsg) async {
        final reconciled = serverMsg.copyWith(
          clientKey: clientKey,
          deliveryState: DeliveryState.sent,
        );
        await _dao.upsertMessage(reconciled);
        return Result<Message>.ok(reconciled);
      },
      (f) async {
        await _dao.advanceDelivery(
          clientKey: clientKey,
          state: DeliveryState.failed,
        );
        return Result<Message>.err(f);
      },
    );
  }

  @override
  Future<Result<Message>> retrySend(String clientKey) async {
    final msg = await _dao.getByClientKey(clientKey);
    if (msg == null) {
      return const Result<Message>.err(AppFailure.messageFailed());
    }
    await _dao.advanceDelivery(
      clientKey: clientKey,
      state: DeliveryState.sending,
    );
    return _post(msg.conversationId, clientKey, msg.kind, _wire(msg.content));
  }

  @override
  Future<Result<void>> markRead(
    String conversationId,
    String upToMessageId,
  ) async {
    await _dao.markConversationRead(conversationId);
    _client.send(
      ConversationRead(
        conversationId: conversationId,
        upToMessageId: upToMessageId,
      ),
    );
    return _remote.markRead(conversationId, upToMessageId);
  }

  @override
  void emitTyping(String conversationId, {required bool started}) => _client
      .send(started ? TypingStart(conversationId) : TypingStop(conversationId));

  @override
  Future<Result<Conversation>> openOrStartConversation(String userId) async {
    final res = await _remote.openOrStart(userId);
    if (res.isOk) await _dao.upsertConversation(res.valueOrNull!);
    return res;
  }

  @override
  Future<Result<CursorPage<UserSummary>>> searchPeople(String query) =>
      _remote.searchPeople(query);

  Future<void> _flushOutbox() async {
    final pending = await _dao.pendingOutbox();
    for (final m in pending.where((m) => m.isMine)) {
      await _dao.advanceDelivery(
        clientKey: m.clientKey,
        state: DeliveryState.sending,
      );
      await _post(m.conversationId, m.clientKey, m.kind, _wire(m.content));
    }
  }

  static Map<String, dynamic> _wire(MessageContent content) =>
      switch (content) {
        TextContent(:final body) => {'body': body},
        PhotoContent(:final mediaId) => {'mediaId': mediaId},
        SharedPostContent(:final ref) => {'sharedPostId': ref.id},
        StickerContent(:final glyphId) => {'stickerId': glyphId},
      };

  /// Tear down the connection-state subscription (app lifetime otherwise).
  Future<void> dispose() => _connSub.cancel();
}
