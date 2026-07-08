import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/me/me_profile.dart';
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/data/realtime/fake_realtime_client.dart';
import 'package:we36/core/data/realtime/realtime_event.dart';
import 'package:we36/core/services/realtime/messaging_realtime_service.dart';
import 'package:we36/core/utils/app_logger.dart';

/// Verifies the sole realtime subscriber folds inbound socket events into the
/// drift cache + transient streams (Constitution VIII/XII) — driven by
/// `FakeRealtimeClient`, never a live socket.
void main() {
  late AppDatabase db;
  late FakeRealtimeClient client;
  late MessagingRealtimeService service;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    client = FakeRealtimeClient();
    service = MessagingRealtimeService(client, db, const AppLogger());
  });
  tearDown(() async {
    await service.dispose();
    await client.dispose();
    await db.close();
  });

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 50));

  // Flat B#012 MessageDto shape (senderId + top-level body).
  Map<String, dynamic> wireMessage(String id, {String body = 'hi'}) => {
    'id': id,
    'senderId': 'peer',
    'kind': 'text',
    'body': body,
    'createdAt': DateTime.utc(2026).toIso8601String(),
  };

  Future<void> seedConvo(String id) => db.messagingDao.upsertConversation(
    Conversation(
      id: id,
      participant: const UserSummary(id: 'peer', isVerified: false),
      lastActivityAt: DateTime.utc(2026),
    ),
  );

  test('message.new upserts the message + bumps the conversation', () async {
    await seedConvo('c1');
    client.emitInbound(
      MessageNew(conversationId: 'c1', message: wireMessage('srv-1')),
    );
    await settle();
    final thread = await db.messagingDao.getThread('c1');
    expect(thread.length, 1);
    final convo = await db.messagingDao.getConversation('c1');
    expect(convo!.unreadCount, 1);
    expect(convo.lastMessagePreview, 'hi');
  });

  test(
    'the server echo of my own send is skipped (no duplicate, no wrong-side)',
    () async {
      await db.meProfileDao.upsert(
        MeProfile(
          id: 'me',
          email: 'me@we36.app',
          isPrivate: false,
          isVerified: false,
          profileCompleted: true,
          createdAt: DateTime.utc(2026),
        ),
      );
      await seedConvo('c1');
      // A message.new whose senderId is me = the backend echoing my own send.
      client.emitInbound(
        MessageNew(
          conversationId: 'c1',
          message: {
            'id': 'srv-mine',
            'senderId': 'me',
            'kind': 'text',
            'body': 'hi say',
            'createdAt': DateTime.utc(2026).toIso8601String(),
          },
        ),
      );
      await settle();
      expect(await db.messagingDao.getThread('c1'), isEmpty);
    },
  );

  test('message.new from a new peer creates the conversation live', () async {
    // No conversation seeded — a first message (e.g. a request) from a new peer.
    client.emitInbound(
      MessageNew(
        conversationId: 'c_new',
        message: {
          'id': 'srv-new',
          'senderId': 'u_ava',
          'sender': {'id': 'u_ava', 'username': 'ava', 'isVerified': false},
          'kind': 'text',
          'body': 'hey!',
          'createdAt': DateTime.utc(2026).toIso8601String(),
        },
      ),
    );
    await settle();
    final convo = await db.messagingDao.getConversation('c_new');
    expect(convo, isNotNull);
    expect(convo!.participant.username, 'ava');
    expect(convo.unreadCount, 1);
    expect((await db.messagingDao.getThread('c_new')).length, 1);
  });

  test('a replayed message.new appears exactly once (SC-004)', () async {
    await seedConvo('c1');
    final evt = MessageNew(conversationId: 'c1', message: wireMessage('srv-1'));
    client
      ..emitInbound(evt)
      ..emitInbound(evt);
    await settle();
    expect((await db.messagingDao.getThread('c1')).length, 1);
  });

  test('message.delivered / message.read advance my sent message', () async {
    await db.messagingDao.upsertMessage(
      Message(
        clientKey: 'm1',
        serverId: 'srv-1',
        conversationId: 'c1',
        authorId: 'me',
        isMine: true,
        kind: MessageKind.text,
        content: const MessageContent.text(body: 'yo'),
        createdAt: DateTime.utc(2026),
        deliveryState: DeliveryState.sent,
      ),
    );
    client.emitInbound(
      const MessageDelivered(conversationId: 'c1', messageId: 'srv-1'),
    );
    await settle();
    expect(
      (await db.messagingDao.getThread('c1')).single.deliveryState,
      DeliveryState.delivered,
    );
    client.emitInbound(
      const MessageReadEvent(
        conversationId: 'c1',
        userId: 'peer',
        upToMessageId: 'srv-1',
      ),
    );
    await settle();
    expect(
      (await db.messagingDao.getThread('c1')).single.deliveryState,
      DeliveryState.read,
    );
  });

  test('typing + presence decorate the transient streams', () async {
    client.emitInbound(
      const TypingInbound(conversationId: 'c1', userId: 'peer'),
    );
    await settle();
    expect(service.isTyping('c1'), isTrue);

    client.emitInbound(const PresenceUpdate(userId: 'peer', online: true));
    await settle();
    expect(service.isOnline('peer'), isTrue);
  });

  test('a malformed message.new is skipped without crashing', () async {
    await seedConvo('c1');
    client
      ..emitInbound(
        const MessageNew(conversationId: 'c1', message: {'bogus': true}),
      )
      // A following valid event still processes.
      ..emitInbound(
        MessageNew(conversationId: 'c1', message: wireMessage('srv-9')),
      );
    await settle();
    expect((await db.messagingDao.getThread('c1')).length, 1);
  });
}
