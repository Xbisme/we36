import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/domain/app_failure.dart';

part 'conversations_state.freezed.dart';

/// The Messages-tab conversation list (#012 US1; Constitution III 4-state). The
/// loaded state carries the decorated conversation list (typing/presence merged
/// from the realtime streams), the in-list search query, and an offline hint
/// when the background reconcile failed but the cache rendered.
@freezed
sealed class ConversationsState with _$ConversationsState {
  const ConversationsState._();

  const factory ConversationsState.initial() = ConversationsInitial;

  const factory ConversationsState.loading() = ConversationsLoading;

  const factory ConversationsState.loaded({
    required List<Conversation> conversations,
    @Default('') String query,
    @Default(false) bool isOffline,
  }) = ConversationsLoaded;

  const factory ConversationsState.error(AppFailure failure) =
      ConversationsError;

  /// The number of conversations with unread messages (tab badge source).
  int get unreadCount => switch (this) {
    ConversationsLoaded(:final conversations) =>
      conversations.where((c) => c.hasUnread).length,
    _ => 0,
  };

  /// Online participants, for the "active now" rail.
  List<Conversation> get onlineConversations => switch (this) {
    ConversationsLoaded(:final conversations) =>
      conversations.where((c) => c.participantOnline).toList(),
    _ => const [],
  };
}
