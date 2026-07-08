import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/features/messaging/presentation/cubit/conversations_cubit.dart';
import 'package:we36/features/messaging/presentation/cubit/conversations_state.dart';

/// Seeded conversations for messaging widget tests (no drift/socket) — mirrors
/// the fake-repo seed shape (one unread, one online).
List<Conversation> stubConversations() => [
  Conversation(
    id: 'c_ava',
    participant: const UserSummary(
      id: 'u_ava',
      isVerified: true,
      username: 'ava',
      displayName: 'Ava Nguyen',
    ),
    lastActivityAt: DateTime.utc(2026, 1, 3),
    unreadCount: 2,
    lastMessagePreview: 'See you tomorrow!',
    participantOnline: true,
  ),
  Conversation(
    id: 'c_leo',
    participant: const UserSummary(
      id: 'u_leo',
      isVerified: false,
      username: 'leo',
      displayName: 'Leo Tran',
    ),
    lastActivityAt: DateTime.utc(2026, 1, 2),
    lastMessagePreview: 'Nice shot 🔥',
  ),
];

/// A [ConversationsCubit] seeded with a fixed state (widget tests never drive the
/// real cubit over drift/socket — the #009 gate learning).
class StubConversationsCubit extends Cubit<ConversationsState>
    implements ConversationsCubit {
  StubConversationsCubit(super.initialState);

  @override
  Future<void> loadInitial() async {}

  @override
  void search(String query) {}

  @override
  Future<void> retry() async {}
}
