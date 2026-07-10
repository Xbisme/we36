import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/messaging/fake_messaging_repository.dart';
import 'package:we36/core/data/moderation/blocked_users_store.dart';
import 'package:we36/core/data/realtime/fake_realtime_client.dart';
import 'package:we36/core/services/preferences/presence_visibility.dart';
import 'package:we36/core/services/realtime/messaging_realtime_service.dart';
import 'package:we36/core/utils/app_logger.dart';
import 'package:we36/features/messaging/domain/usecases/conversations_usecases.dart';
import 'package:we36/features/messaging/presentation/cubit/conversations_cubit.dart';
import 'package:we36/features/messaging/presentation/cubit/conversations_state.dart';

/// #012 US1: the conversation-list cubit — cache-first load, unread derivation,
/// typing/presence decoration, in-list search, offline flag. Driven by the fake
/// repo + a real realtime service (never a live socket).
void main() {
  late FakeMessagingRepository repo;
  late AppDatabase db;
  late FakeRealtimeClient client;
  late MessagingRealtimeService service;
  late ConversationsCubit cubit;

  setUp(() {
    repo = FakeMessagingRepository();
    db = AppDatabase.forTesting(NativeDatabase.memory());
    client = FakeRealtimeClient();
    service = MessagingRealtimeService(
      client,
      db,
      const AppLogger(),
      PresenceVisibility(),
    );
    cubit = ConversationsCubit(
      WatchConversations(repo, BlockedUsersStore()),
      LoadConversations(repo),
      service,
    );
  });
  tearDown(() async {
    await cubit.close();
    await service.dispose();
    await client.dispose();
    await db.close();
  });

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 20));

  test('loadInitial emits loaded with the seeded conversations', () async {
    await cubit.loadInitial();
    await settle();
    final s = cubit.state;
    expect(s, isA<ConversationsLoaded>());
    expect((s as ConversationsLoaded).conversations, isNotEmpty);
  });

  test('unreadCount reflects conversations with unread messages', () async {
    await cubit.loadInitial();
    await settle();
    expect(cubit.state.unreadCount, greaterThan(0));
  });

  test('seeded typing + presence surface on the row', () async {
    await cubit.loadInitial();
    await settle();
    final s = cubit.state as ConversationsLoaded;
    final ava = s.conversations.firstWhere((c) => c.id == 'c_ava');
    expect(ava.isTyping, isTrue);
    expect(ava.participantOnline, isTrue);
  });

  test('search filters by participant handle/name', () async {
    await cubit.loadInitial();
    await settle();
    cubit.search('leo');
    await settle();
    final s = cubit.state as ConversationsLoaded;
    expect(
      s.conversations.every((c) => c.participant.username == 'leo'),
      isTrue,
    );
  });

  test('an offline reconcile keeps the cache and flags offline', () async {
    repo.offline = true;
    await cubit.loadInitial();
    await settle();
    final s = cubit.state;
    // Cache still rendered from the watch stream, with the offline hint set.
    expect(s, isA<ConversationsLoaded>());
    expect((s as ConversationsLoaded).isOffline, isTrue);
    expect(s.conversations, isNotEmpty);
  });
}
