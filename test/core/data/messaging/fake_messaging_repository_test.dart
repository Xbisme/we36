import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/messaging/fake_messaging_repository.dart';
import 'package:we36/core/data/messaging/message.dart';

/// Tests the in-memory `fake` messaging graph the app + cubit tests run against
/// (Constitution VIII/XII) — optimistic + idempotent send, offline queue flush,
/// open-or-start (no duplicate), scripted inbound/presence.
void main() {
  late FakeMessagingRepository repo;

  setUp(() => repo = FakeMessagingRepository());

  test('seeds conversations, one unread, newest-activity first', () async {
    final list = await repo.watchConversations().first;
    expect(list, isNotEmpty);
    expect(list.any((c) => c.hasUnread), isTrue);
    // Sorted newest-first.
    for (var i = 0; i < list.length - 1; i++) {
      expect(
        list[i].lastActivityAt.isAfter(list[i + 1].lastActivityAt) ||
            list[i].lastActivityAt == list[i + 1].lastActivityAt,
        isTrue,
      );
    }
  });

  test('sendText appends optimistically and reaches sent', () async {
    final res = await repo.sendText('c_mia', 'hello');
    expect(res.isOk, isTrue);
    expect(res.valueOrNull!.deliveryState, DeliveryState.sent);
    final thread = await repo.watchThread('c_mia').first;
    expect(thread.last.previewBody, 'hello');
  });

  test(
    'a failed send can be retried into exactly one message (SC-003)',
    () async {
      repo.failNextSend = true;
      final first = await repo.sendText('c_mia', 'retry me');
      expect(first.isErr, isTrue);
      final failed = (await repo.watchThread('c_mia').first).single;
      expect(failed.deliveryState, DeliveryState.failed);

      final retry = await repo.retrySend(failed.clientKey);
      expect(retry.isOk, isTrue);
      final thread = await repo.watchThread('c_mia').first;
      expect(thread.length, 1); // exactly one — not duplicated
      expect(thread.single.deliveryState, DeliveryState.sent);
    },
  );

  test('offline send queues; going online flushes it (SC-006)', () async {
    repo.offline = true;
    final res = await repo.sendText('c_mia', 'queued');
    expect(res.isErr, isTrue);
    final queued = (await repo.watchThread('c_mia').first).single;
    expect(queued.deliveryState, DeliveryState.failed);

    repo.offline = false;
    final flushed = await repo.retrySend(queued.clientKey);
    expect(flushed.isOk, isTrue);
    expect((await repo.watchThread('c_mia').first).length, 1);
  });

  test(
    'openOrStartConversation opens the existing thread (no duplicate, SC-007)',
    () async {
      final before = (await repo.watchConversations().first).length;
      final res = await repo.openOrStartConversation('u_ava');
      expect(res.isOk, isTrue);
      expect(res.valueOrNull!.id, 'c_ava');
      final after = (await repo.watchConversations().first).length;
      expect(after, before); // no new conversation created
    },
  );

  test('openOrStartConversation with a new user creates one thread', () async {
    final before = (await repo.watchConversations().first).length;
    final res = await repo.openOrStartConversation('u_new');
    expect(res.isOk, isTrue);
    expect((await repo.watchConversations().first).length, before + 1);
  });

  test('markRead clears unread', () async {
    await repo.markRead('c_ava', 'x');
    final convo = (await repo.watchConversations().first).firstWhere(
      (c) => c.id == 'c_ava',
    );
    expect(convo.unreadCount, 0);
  });

  test('scriptInbound appends + bumps unread', () async {
    repo.scriptInbound('c_leo', 'ping');
    final thread = await repo.watchThread('c_leo').first;
    expect(thread.last.content, const MessageContent.text(body: 'ping'));
    final convo = (await repo.watchConversations().first).firstWhere(
      (c) => c.id == 'c_leo',
    );
    expect(convo.hasUnread, isTrue);
  });

  test('searchPeople matches by handle', () async {
    final res = await repo.searchPeople('ava');
    expect(res.valueOrNull!.items.any((u) => u.username == 'ava'), isTrue);
  });
}
