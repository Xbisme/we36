import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/services/realtime/messaging_realtime_service.dart';
import 'package:we36/features/messaging/domain/usecases/conversations_usecases.dart';
import 'package:we36/features/messaging/presentation/cubit/conversations_state.dart';

/// Drives the Messages-tab conversation list (#012 US1). Reads the one canonical
/// list reactively from the cache (renders offline-from-cache, FR-007),
/// reconciles in the background, decorates each row with live typing/presence
/// from the realtime service (transient), and applies the in-list search filter.
@injectable
class ConversationsCubit extends Cubit<ConversationsState> {
  ConversationsCubit(this._watch, this._load, this._realtime)
    : super(const ConversationsState.initial());

  final WatchConversations _watch;
  final LoadConversations _load;
  final MessagingRealtimeService _realtime;

  StreamSubscription<List<Conversation>>? _sub;
  StreamSubscription<Set<String>>? _typingSub;
  StreamSubscription<Map<String, bool>>? _presenceSub;

  List<Conversation> _latest = const [];
  String _query = '';
  bool _offline = false;
  bool _hasData = false;

  Future<void> loadInitial() async {
    emit(const ConversationsState.loading());
    _hasData = false;
    _offline = false;
    _sub ??= _watch().listen(_onData);
    _typingSub ??= _realtime.typing.listen((_) => _emitLoaded());
    _presenceSub ??= _realtime.presence.listen((_) => _emitLoaded());
    final res = await _load();
    _offline = res.isErr;
    if (_hasData) {
      _emitLoaded();
    } else if (res.isErr) {
      emit(ConversationsState.error(res.failureOrNull!));
    }
  }

  void _onData(List<Conversation> conversations) {
    _hasData = true;
    _latest = conversations;
    _emitLoaded();
  }

  /// Update the in-list search filter (matches participant name / handle).
  void search(String query) {
    _query = query;
    if (_hasData) _emitLoaded();
  }

  void _emitLoaded() {
    final decorated = _latest.map(_decorate).toList();
    final filtered = _query.trim().isEmpty
        ? decorated
        : decorated.where(_matchesQuery).toList();
    emit(
      ConversationsState.loaded(
        conversations: filtered,
        query: _query,
        isOffline: _offline,
      ),
    );
  }

  Conversation _decorate(Conversation c) => c.copyWith(
    isTyping: c.isTyping || _realtime.isTyping(c.id),
    participantOnline:
        c.participantOnline || _realtime.isOnline(c.participant.id),
  );

  bool _matchesQuery(Conversation c) {
    final q = _query.trim().toLowerCase();
    final name = (c.participant.displayName ?? '').toLowerCase();
    final handle = (c.participant.username ?? '').toLowerCase();
    return name.contains(q) || handle.contains(q);
  }

  Future<void> retry() => loadInitial();

  @override
  Future<void> close() async {
    await _sub?.cancel();
    await _typingSub?.cancel();
    await _presenceSub?.cancel();
    return super.close();
  }
}
