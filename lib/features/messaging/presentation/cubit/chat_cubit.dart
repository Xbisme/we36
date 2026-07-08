import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/services/realtime/messaging_realtime_service.dart';
import 'package:we36/features/messaging/domain/usecases/chat_usecases.dart';
import 'package:we36/features/messaging/presentation/cubit/chat_state.dart';

/// Drives one conversation's chat (#012 US2). Reads the thread reactively from
/// the cache (renders offline, FR-014); the optimistic send + delivery-state
/// advance + inbound append all flow through the same reactive watch. Decorates
/// the header with the peer's live typing + presence, and marks the conversation
/// read on view (FR-013).
@injectable
class ChatCubit extends Cubit<ChatState> {
  ChatCubit(
    this._watch,
    this._history,
    this._sendText,
    this._sendPhoto,
    this._sendSharedPost,
    this._sendSticker,
    this._retry,
    this._markRead,
    this._emitTyping,
    this._realtime,
  ) : super(const ChatState.initial());

  final WatchThread _watch;
  final LoadHistory _history;
  final SendText _sendText;
  final SendPhoto _sendPhoto;
  final SendSharedPost _sendSharedPost;
  final SendSticker _sendSticker;
  final RetrySend _retry;
  final MarkRead _markRead;
  final EmitTyping _emitTyping;
  final MessagingRealtimeService _realtime;

  late String _conversationId;
  late String _peerId;
  List<Message> _latest = const [];
  bool _hasData = false;

  StreamSubscription<List<Message>>? _sub;
  StreamSubscription<Set<String>>? _typingSub;
  StreamSubscription<Map<String, bool>>? _presenceSub;

  Future<void> loadInitial(
    String conversationId, {
    required String peerId,
  }) async {
    _conversationId = conversationId;
    _peerId = peerId;
    emit(const ChatState.loading());
    _hasData = false;
    _sub ??= _watch(conversationId).listen(_onData);
    _typingSub ??= _realtime.typing.listen((_) => _reemit());
    _presenceSub ??= _realtime.presence.listen((_) => _reemit());
    final res = await _history(conversationId);
    if (res.isErr && !_hasData) emit(ChatState.error(res.failureOrNull!));
  }

  void _onData(List<Message> messages) {
    _hasData = true;
    _latest = messages;
    _markReadIfNeeded();
    _reemit();
  }

  void _reemit() {
    emit(
      ChatState.loaded(
        messages: _latest,
        peerTyping: _realtime.isTyping(_conversationId),
        peerOnline: _realtime.isOnline(_peerId),
      ),
    );
  }

  void _markReadIfNeeded() {
    if (_latest.isEmpty) return;
    final last = _latest.last;
    if (last.isMine) return;
    final upTo = last.serverId ?? last.clientKey;
    unawaited(_markRead(_conversationId, upTo));
  }

  Future<void> sendText(String body) async {
    final trimmed = body.trim();
    if (trimmed.isEmpty) return;
    _emitTyping(_conversationId, started: false);
    await _sendText(_conversationId, trimmed);
  }

  Future<void> sendPhoto(String mediaId) =>
      _sendPhoto(_conversationId, mediaId).then((_) {});

  Future<void> sendSharedPost(PostRef ref) =>
      _sendSharedPost(_conversationId, ref).then((_) {});

  Future<void> sendSticker(String glyphId) =>
      _sendSticker(_conversationId, glyphId).then((_) {});

  Future<void> retry(String clientKey) => _retry(clientKey).then((_) {});

  /// The composer reports typing activity (debounced by the widget).
  void onTyping({required bool active}) =>
      _emitTyping(_conversationId, started: active);

  Future<void> loadMore(String? cursor) async {
    if (cursor == null) return;
    await _history(_conversationId, cursor: cursor);
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    await _typingSub?.cancel();
    await _presenceSub?.cancel();
    return super.close();
  }
}
