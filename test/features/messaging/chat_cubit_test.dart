import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/messaging/fake_messaging_repository.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/data/realtime/fake_realtime_client.dart';
import 'package:we36/core/data/realtime/realtime_event.dart';
import 'package:we36/core/services/realtime/messaging_realtime_service.dart';
import 'package:we36/core/utils/app_logger.dart';
import 'package:we36/features/messaging/domain/usecases/chat_usecases.dart';
import 'package:we36/features/messaging/presentation/cubit/chat_cubit.dart';
import 'package:we36/features/messaging/presentation/cubit/chat_state.dart';

/// #012 US2: the chat cubit — optimistic send + delivery advance, idempotent
/// retry, live inbound append, typing decoration, mark-read on view. Driven by
/// the fake repo + a real realtime service (never a live socket).
void main() {
  late FakeMessagingRepository repo;
  late AppDatabase db;
  late FakeRealtimeClient client;
  late MessagingRealtimeService service;
  late ChatCubit cubit;

  setUp(() {
    repo = FakeMessagingRepository();
    db = AppDatabase.forTesting(NativeDatabase.memory());
    client = FakeRealtimeClient();
    service = MessagingRealtimeService(client, db, const AppLogger());
    cubit = ChatCubit(
      WatchThread(repo),
      LoadHistory(repo),
      SendText(repo),
      SendPhoto(repo),
      SendSharedPost(repo),
      SendSticker(repo),
      RetrySend(repo),
      MarkRead(repo),
      EmitTyping(repo),
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

  ChatLoaded loaded() => cubit.state as ChatLoaded;

  test('loadInitial emits loaded with the seeded thread', () async {
    await cubit.loadInitial('c_ava', peerId: 'u_ava');
    await settle();
    expect(cubit.state, isA<ChatLoaded>());
    expect(loaded().messages, isNotEmpty);
  });

  test(
    'sendText appends optimistically and advances to sent (SC-002)',
    () async {
      await cubit.loadInitial('c_mia', peerId: 'u_mia');
      await settle();
      await cubit.sendText('hello');
      await settle();
      final msgs = loaded().messages;
      expect(msgs.last.previewBody, 'hello');
      expect(msgs.last.deliveryState, DeliveryState.sent);
    },
  );

  test(
    'a failed send retries into exactly one sent message (SC-003)',
    () async {
      await cubit.loadInitial('c_mia', peerId: 'u_mia');
      await settle();
      repo.failNextSend = true;
      await cubit.sendText('retry me');
      await settle();
      final failed = loaded().messages.singleWhere((m) => m.isMine);
      expect(failed.deliveryState, DeliveryState.failed);

      await cubit.retry(failed.clientKey);
      await settle();
      final mine = loaded().messages.where((m) => m.isMine).toList();
      expect(mine.length, 1);
      expect(mine.single.deliveryState, DeliveryState.sent);
    },
  );

  test('a scripted inbound message appends live (FR-011)', () async {
    await cubit.loadInitial('c_leo', peerId: 'u_leo');
    await settle();
    final before = loaded().messages.length;
    repo.scriptInbound('c_leo', 'ping');
    await settle();
    expect(loaded().messages.length, before + 1);
    expect(loaded().messages.last.previewBody, 'ping');
  });

  test('a typing event decorates peerTyping (FR-012)', () async {
    await cubit.loadInitial('c_leo', peerId: 'u_leo');
    await settle();
    client.emitInbound(
      const TypingInbound(conversationId: 'c_leo', userId: 'u_leo'),
    );
    await settle();
    expect(loaded().peerTyping, isTrue);
  });

  test(
    'opening an unread conversation marks it read (FR-013/SC-005)',
    () async {
      await cubit.loadInitial('c_ava', peerId: 'u_ava');
      await settle();
      final ava = (await repo.watchConversations().first).firstWhere(
        (c) => c.id == 'c_ava',
      );
      expect(ava.unreadCount, 0);
    },
  );
}
