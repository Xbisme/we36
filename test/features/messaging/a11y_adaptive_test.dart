import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/messaging/presentation/conversations_page.dart';
import 'package:we36/features/messaging/presentation/cubit/conversations_cubit.dart';
import 'package:we36/features/messaging/presentation/cubit/conversations_state.dart';
import 'package:we36/features/messaging/presentation/widgets/conversation_tile.dart';
import 'package:we36/features/messaging/presentation/widgets/message_bubble.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

import '../../helpers/messaging_test_doubles.dart';

/// #012 US6 (T050): messaging surfaces expose screen-reader labels and survive
/// 2× text scaling without overflow, in light + dark. Stub cubits — no real
/// drift/socket.
void main() {
  Widget host(Widget child, {double scale = 1.0, ThemeData? theme}) =>
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme ?? AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: Scaffold(body: child),
        ),
      );

  testWidgets('conversation tiles expose a semantic label with unread count', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        BlocProvider<ConversationsCubit>.value(
          value: StubConversationsCubit(
            ConversationsState.loaded(conversations: stubConversations()),
          ),
          child: ConversationsPage(onOpenConversation: (_, _) {}),
        ),
      ),
    );
    await tester.pump();
    // Unread conversation exposes "<name>, N unread".
    expect(find.bySemanticsLabel('Ava Nguyen, 2 unread'), findsOneWidget);
  });

  testWidgets('the list renders at 2x text scale without overflow (dark)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      host(
        BlocProvider<ConversationsCubit>.value(
          value: StubConversationsCubit(
            ConversationsState.loaded(conversations: stubConversations()),
          ),
          child: ConversationsPage(onOpenConversation: (_, _) {}),
        ),
        scale: 2,
        theme: AppTheme.dark,
      ),
    );
    await tester.pump();
    expect(find.byType(ConversationTile), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('a message bubble exposes a semantic label at 2x scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        MessageBubble(
          message: Message(
            clientKey: 'k1',
            conversationId: 'c1',
            authorId: 'me',
            isMine: true,
            kind: MessageKind.text,
            content: const MessageContent.text(body: 'hey there'),
            createdAt: DateTime.utc(2026),
            deliveryState: DeliveryState.read,
          ),
        ),
        scale: 2,
      ),
    );
    await tester.pump();
    expect(find.bySemanticsLabel('You: hey there'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
