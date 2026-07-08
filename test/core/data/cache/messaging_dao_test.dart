import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/data/messaging/message.dart';

/// DAO-level tests for the #012 Direct-Messages cache. Drives a real in-memory
/// `AppDatabase` in plain `test()` (real async — never inside `testWidgets`,
/// which deadlocks on drift I/O; the #009 gate learning).
void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  Conversation convo(String id, {int unread = 0, int minute = 0}) =>
      Conversation(
        id: id,
        participant: UserSummary(id: 'p_$id', isVerified: false, username: id),
        lastActivityAt: DateTime.utc(2026).add(Duration(minutes: minute)),
        unreadCount: unread,
        lastMessagePreview: 'hi from $id',
      );

  Message msg(
    String key,
    String convoId, {
    bool mine = true,
    DeliveryState state = DeliveryState.sent,
    int minute = 0,
    String? serverId,
  }) => Message(
    clientKey: key,
    serverId: serverId,
    conversationId: convoId,
    authorId: mine ? 'me' : 'peer',
    isMine: mine,
    kind: MessageKind.text,
    content: MessageContent.text(body: 'body $key'),
    createdAt: DateTime.utc(2026).add(Duration(minutes: minute)),
    deliveryState: state,
  );

  test('database is at schema v9 (v8→v9 adds Conversations + Messages)', () {
    expect(db.schemaVersion, 9);
  });

  test('conversations watch emits newest-activity first', () async {
    final dao = db.messagingDao;
    await dao.upsertConversations([
      convo('a', minute: 1),
      convo('b', minute: 3),
      convo('c', minute: 2),
    ]);
    final list = await dao.watchConversations().first;
    expect(list.map((c) => c.id).toList(), ['b', 'c', 'a']);
  });

  test('thread watch emits oldest→newest for the conversation', () async {
    final dao = db.messagingDao;
    await dao.upsertMessages([
      msg('m2', 'a', minute: 2),
      msg('m1', 'a', minute: 1),
      msg('x1', 'b', minute: 1),
    ]);
    final thread = await dao.watchThread('a').first;
    expect(thread.map((m) => m.clientKey).toList(), ['m1', 'm2']);
  });

  test('upsert by clientKey dedupes (in-place update, SC-004)', () async {
    final dao = db.messagingDao;
    await dao.upsertMessage(msg('m1', 'a', state: DeliveryState.sending));
    await dao.upsertMessage(msg('m1', 'a', serverId: 'srv-1'));
    final thread = await dao.getThread('a');
    expect(thread.length, 1);
    expect(thread.single.deliveryState, DeliveryState.sent);
    expect(thread.single.serverId, 'srv-1');
  });

  test('advanceDelivery by serverId advances state', () async {
    final dao = db.messagingDao;
    await dao.upsertMessage(msg('m1', 'a', serverId: 'srv-1'));
    await dao.advanceDelivery(serverId: 'srv-1', state: DeliveryState.read);
    final thread = await dao.getThread('a');
    expect(thread.single.deliveryState, DeliveryState.read);
  });

  test(
    'pendingOutbox returns only sending/failed rows, oldest first',
    () async {
      final dao = db.messagingDao;
      await dao.upsertMessages([
        msg('ok', 'a', minute: 1),
        msg('send', 'a', state: DeliveryState.sending, minute: 2),
        msg('fail', 'a', state: DeliveryState.failed, minute: 3),
      ]);
      final outbox = await dao.pendingOutbox();
      expect(outbox.map((m) => m.clientKey).toList(), ['send', 'fail']);
    },
  );

  test(
    'bumpForInbound updates preview + activity + unread (no-op if absent)',
    () async {
      final dao = db.messagingDao;
      await dao.upsertConversation(convo('a', unread: 1, minute: 1));
      await dao.bumpForInbound(
        'a',
        at: DateTime.utc(2026).add(const Duration(minutes: 5)),
        preview: 'new!',
      );
      final c = await dao.getConversation('a');
      expect(c!.unreadCount, 2);
      expect(c.lastMessagePreview, 'new!');
      // Absent conversation → no throw.
      await dao.bumpForInbound('missing', at: DateTime.utc(2026));
    },
  );

  test('markConversationRead clears unread', () async {
    final dao = db.messagingDao;
    await dao.upsertConversation(convo('a', unread: 3));
    await dao.markConversationRead('a');
    expect((await dao.getConversation('a'))!.unreadCount, 0);
  });

  test('clearUserScoped wipes conversations + messages', () async {
    final dao = db.messagingDao;
    await dao.upsertConversation(convo('a'));
    await dao.upsertMessage(msg('m1', 'a'));
    await db.clearUserScoped();
    expect(await dao.getConversations(), isEmpty);
    expect(await dao.getThread('a'), isEmpty);
  });
}
