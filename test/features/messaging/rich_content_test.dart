import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/messaging/fake_messaging_repository.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/data/realtime/fake_realtime_client.dart';
import 'package:we36/core/services/realtime/messaging_realtime_service.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/core/utils/app_logger.dart';
import 'package:we36/features/messaging/domain/usecases/chat_usecases.dart';
import 'package:we36/features/messaging/presentation/cubit/chat_cubit.dart';
import 'package:we36/features/messaging/presentation/cubit/chat_state.dart';
import 'package:we36/features/messaging/presentation/widgets/message_bubble.dart';
import 'package:we36/features/messaging/presentation/widgets/shared_post_card.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// #012 US3 (T042): rich message content — photo/shared-post/sticker send + the
/// shared-post card deep-link / unavailable state.
void main() {
  group('sends via the chat cubit', () {
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

    test('sendSticker appends a sticker message', () async {
      await cubit.loadInitial('c_mia', peerId: 'u_mia');
      await settle();
      await cubit.sendSticker('🔥');
      await settle();
      final last = (cubit.state as ChatLoaded).messages.last;
      expect(last.kind, MessageKind.sticker);
      expect(last.content, const MessageContent.sticker(glyphId: '🔥'));
    });

    test('sendPhoto appends a photo message that reaches sent', () async {
      await cubit.loadInitial('c_mia', peerId: 'u_mia');
      await settle();
      await cubit.sendPhoto('media-1');
      await settle();
      final last = (cubit.state as ChatLoaded).messages.last;
      expect(last.kind, MessageKind.photo);
      expect(last.deliveryState, DeliveryState.sent);
    });

    test('sendSharedPost appends a shared-post message', () async {
      await cubit.loadInitial('c_mia', peerId: 'u_mia');
      await settle();
      await cubit.sendSharedPost(
        const PostRef(id: 'p1', kind: PostKind.post, authorName: 'ava'),
      );
      await settle();
      final last = (cubit.state as ChatLoaded).messages.last;
      expect(last.kind, MessageKind.sharedPost);
    });
  });

  group('shared-post card', () {
    Widget host(Widget child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: child)),
    );

    testWidgets('deep-links on tap when available', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        host(
          SharedPostCard(
            ref: const PostRef(
              id: 'p1',
              kind: PostKind.post,
              authorName: 'ava',
            ),
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byType(SharedPostCard));
      expect(tapped, isTrue);
    });

    testWidgets('shows an unavailable state and is not tappable', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        host(
          SharedPostCard(
            ref: const PostRef(
              id: 'p1',
              kind: PostKind.post,
              unavailable: true,
            ),
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('This content is unavailable'), findsOneWidget);
      await tester.tap(find.byType(SharedPostCard));
      expect(tapped, isFalse);
    });

    testWidgets('MessageBubble renders a sticker glyph', (tester) async {
      await tester.pumpWidget(
        host(
          MessageBubble(
            message: Message(
              clientKey: 'k1',
              conversationId: 'c1',
              authorId: 'peer',
              isMine: false,
              kind: MessageKind.sticker,
              content: const MessageContent.sticker(glyphId: '🎉'),
              createdAt: DateTime.utc(2026),
              deliveryState: DeliveryState.read,
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('🎉'), findsOneWidget);
    });
  });
}
