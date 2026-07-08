import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/data/messaging/messaging_repository.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

/// In-memory [MessagingRepository] (`fake` env) — a small self-contained 1-1
/// messaging graph so the app builds/tests zero-network (Constitution VIII). It
/// seeds a few conversations (one unread, one with an online + typing peer, one
/// empty) + threads, sends optimistically with a deterministic client key, and
/// exposes hooks to script inbound/typing/presence and simulate offline for the
/// cubit tests. Uses no wall-clock (deterministic seeded timestamps — the
/// post-#10 time-bomb learning) and drives no real socket.
@LazySingleton(as: MessagingRepository, env: ['fake'])
class FakeMessagingRepository implements MessagingRepository {
  FakeMessagingRepository() {
    _seed();
  }

  /// Test seams.
  bool offline = false;
  bool failNextSend = false;

  /// When set, the next send fails with this specific failure (e.g. a backend
  /// `forbidden` block verdict, FR-027) and the optimistic row is marked failed.
  AppFailure? nextSendFailure;

  final StreamController<void> _changes = StreamController<void>.broadcast();
  final Map<String, Conversation> _conversations = {};
  final Map<String, List<Message>> _threads = {};
  int _seq = 0;

  DateTime _stamp() => DateTime.utc(2026).add(Duration(minutes: _seq++));
  String _key() => 'ck-${_seq++}';

  void _seed() {
    final peers = [
      const UserSummary(
        id: 'u_ava',
        isVerified: true,
        username: 'ava',
        displayName: 'Ava Nguyen',
      ),
      const UserSummary(
        id: 'u_leo',
        isVerified: false,
        username: 'leo',
        displayName: 'Leo Tran',
      ),
      const UserSummary(
        id: 'u_mia',
        isVerified: false,
        username: 'mia',
        displayName: 'Mia Pham',
      ),
    ];
    // Conversation with unread + an online, typing peer.
    _conversations['c_ava'] = Conversation(
      id: 'c_ava',
      participant: peers[0],
      lastActivityAt: _stamp(),
      unreadCount: 2,
      lastMessagePreview: 'See you tomorrow!',
      isTyping: true,
      participantOnline: true,
    );
    _threads['c_ava'] = [
      _inbound('c_ava', 'u_ava', 'Hey! Are we still on?'),
      _inbound('c_ava', 'u_ava', 'See you tomorrow!'),
    ];
    // A read conversation, peer offline.
    _conversations['c_leo'] = Conversation(
      id: 'c_leo',
      participant: peers[1],
      lastActivityAt: _stamp(),
      lastMessagePreview: 'Nice shot 🔥',
    );
    _threads['c_leo'] = [_mine('c_leo', 'Nice shot 🔥')];
    // A brand-new empty conversation, peer online.
    _conversations['c_mia'] = Conversation(
      id: 'c_mia',
      participant: peers[2],
      lastActivityAt: _stamp(),
      participantOnline: true,
    );
    _threads['c_mia'] = [];
  }

  Message _inbound(String convoId, String authorId, String body) => Message(
    clientKey: _key(),
    conversationId: convoId,
    authorId: authorId,
    isMine: false,
    kind: MessageKind.text,
    content: MessageContent.text(body: body),
    createdAt: _stamp(),
    deliveryState: DeliveryState.read,
  );

  Message _mine(String convoId, String body) => Message(
    clientKey: _key(),
    conversationId: convoId,
    authorId: 'me',
    isMine: true,
    kind: MessageKind.text,
    content: MessageContent.text(body: body),
    createdAt: _stamp(),
    deliveryState: DeliveryState.read,
  );

  void _emit() {
    if (!_changes.isClosed) _changes.add(null);
  }

  List<Conversation> _snapshot() {
    final list = _conversations.values.toList()
      ..sort((a, b) => b.lastActivityAt.compareTo(a.lastActivityAt));
    return list;
  }

  @override
  Stream<List<Conversation>> watchConversations() async* {
    yield _snapshot();
    yield* _changes.stream.map((_) => _snapshot());
  }

  @override
  Future<Result<void>> refreshConversations() async {
    if (offline) return const Result.err(AppFailure.offline());
    return const Result.ok(null);
  }

  @override
  Stream<List<Message>> watchThread(String conversationId) async* {
    yield List.of(_threads[conversationId] ?? const []);
    yield* _changes.stream.map(
      (_) => List.of(_threads[conversationId] ?? const []),
    );
  }

  @override
  Future<Result<CursorPage<Message>>> loadHistory(
    String conversationId, {
    String? cursor,
  }) async {
    if (offline) return const Result.err(AppFailure.offline());
    // Single seeded page — no older history in the fake.
    return Result.ok(
      CursorPage<Message>(
        items: List.of(_threads[conversationId] ?? const []),
        nextCursor: null,
        hasMore: false,
      ),
    );
  }

  @override
  Future<Result<Message>> sendText(String conversationId, String body) =>
      _send(conversationId, MessageKind.text, MessageContent.text(body: body));

  @override
  Future<Result<Message>> sendPhoto(String conversationId, String mediaId) =>
      _send(
        conversationId,
        MessageKind.photo,
        MessageContent.photo(mediaId: mediaId, url: 'https://cdn/$mediaId.jpg'),
      );

  @override
  Future<Result<Message>> sendSharedPost(String conversationId, PostRef ref) =>
      _send(
        conversationId,
        MessageKind.sharedPost,
        MessageContent.sharedPost(ref: ref),
      );

  @override
  Future<Result<Message>> sendSticker(String conversationId, String glyphId) =>
      _send(
        conversationId,
        MessageKind.sticker,
        MessageContent.sticker(glyphId: glyphId),
      );

  Future<Result<Message>> _send(
    String conversationId,
    MessageKind kind,
    MessageContent content,
  ) async {
    final optimistic = Message(
      clientKey: _key(),
      conversationId: conversationId,
      authorId: 'me',
      isMine: true,
      kind: kind,
      content: content,
      createdAt: _stamp(),
      deliveryState: DeliveryState.sending,
    );
    _threads.putIfAbsent(conversationId, () => []).add(optimistic);
    _bumpConversation(conversationId, optimistic);
    _emit();
    return _deliver(optimistic);
  }

  Future<Result<Message>> _deliver(Message optimistic) async {
    final failure = nextSendFailure;
    if (offline || failNextSend || failure != null) {
      failNextSend = false;
      nextSendFailure = null;
      _replace(optimistic.copyWith(deliveryState: DeliveryState.failed));
      _emit();
      return Result.err(failure ?? const AppFailure.messageFailed());
    }
    final sent = optimistic.copyWith(
      serverId: 'srv-${optimistic.clientKey}',
      deliveryState: DeliveryState.sent,
    );
    _replace(sent);
    _emit();
    return Result.ok(sent);
  }

  @override
  Future<Result<Message>> retrySend(String clientKey) async {
    final msg = _find(clientKey);
    if (msg == null) {
      return const Result.err(AppFailure.messageFailed());
    }
    _replace(msg.copyWith(deliveryState: DeliveryState.sending));
    _emit();
    return _deliver(msg);
  }

  @override
  Future<Result<void>> markRead(
    String conversationId,
    String upToMessageId,
  ) async {
    final c = _conversations[conversationId];
    // Idempotent: only emit when the unread count actually changes, so a
    // mark-read triggered by a watch update does not loop back through it.
    if (c != null && c.unreadCount != 0) {
      _conversations[conversationId] = c.copyWith(unreadCount: 0);
      _emit();
    }
    return const Result.ok(null);
  }

  @override
  void emitTyping(String conversationId, {required bool started}) {
    // No-op in the fake (no socket); typing is scripted via [scriptTyping].
  }

  @override
  Future<Result<Conversation>> openOrStartConversation(String userId) async {
    if (offline) return const Result.err(AppFailure.offline());
    final existing = _conversations.values
        .where((c) => c.participant.id == userId)
        .toList();
    if (existing.isNotEmpty) return Result.ok(existing.first);
    final convo = Conversation(
      id: 'c_$userId',
      participant: UserSummary(id: userId, isVerified: false, username: userId),
      lastActivityAt: _stamp(),
    );
    _conversations[convo.id] = convo;
    _threads[convo.id] = [];
    _emit();
    return Result.ok(convo);
  }

  @override
  Future<Result<CursorPage<UserSummary>>> searchPeople(String query) async {
    final all = _conversations.values.map((c) => c.participant).toList();
    final matched = query.isEmpty
        ? all
        : all
              .where(
                (u) =>
                    (u.username ?? '').toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    (u.displayName ?? '').toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();
    return Result.ok(
      CursorPage<UserSummary>(items: matched, nextCursor: null, hasMore: false),
    );
  }

  // ---- test scripting hooks ----------------------------------------------

  /// Script an inbound message from the peer (cubit tests).
  void scriptInbound(String conversationId, String body) {
    final m = _inbound(conversationId, 'peer', body);
    _threads.putIfAbsent(conversationId, () => []).add(m);
    _bumpConversation(conversationId, m, incrementUnread: true);
    _emit();
  }

  /// Script the peer's typing state on a conversation row.
  void scriptTyping(String conversationId, {required bool typing}) {
    final c = _conversations[conversationId];
    if (c != null) {
      _conversations[conversationId] = c.copyWith(isTyping: typing);
      _emit();
    }
  }

  /// Script a peer's presence.
  void scriptPresence(String conversationId, {required bool online}) {
    final c = _conversations[conversationId];
    if (c != null) {
      _conversations[conversationId] = c.copyWith(participantOnline: online);
      _emit();
    }
  }

  Message? _find(String clientKey) {
    for (final thread in _threads.values) {
      for (final m in thread) {
        if (m.clientKey == clientKey) return m;
      }
    }
    return null;
  }

  void _replace(Message updated) {
    final thread = _threads[updated.conversationId];
    if (thread == null) return;
    final i = thread.indexWhere((m) => m.clientKey == updated.clientKey);
    if (i >= 0) thread[i] = updated;
  }

  void _bumpConversation(
    String conversationId,
    Message m, {
    bool incrementUnread = false,
  }) {
    final c = _conversations[conversationId];
    if (c == null) return;
    _conversations[conversationId] = c.copyWith(
      lastActivityAt: m.createdAt,
      lastMessagePreview: m.previewBody ?? c.lastMessagePreview,
      unreadCount: incrementUnread ? c.unreadCount + 1 : c.unreadCount,
    );
  }
}
