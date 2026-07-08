import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/messaging/presentation/widgets/chat_composer.dart';
import 'package:we36/features/messaging/presentation/widgets/delivery_status.dart';
import 'package:we36/features/messaging/presentation/widgets/message_bubble.dart';
import 'package:we36/features/messaging/presentation/widgets/typing_indicator.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// #012 US2 T039: the chat surface widgets render — own/other bubbles, the
/// per-message delivery status, the typing indicator, and the composer send.
/// Rendered directly (no drift/socket) — the #009 gate learning.
void main() {
  Widget host(Widget child) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  Message text(String body, {required bool mine, DeliveryState? state}) =>
      Message(
        clientKey: 'k-$body',
        conversationId: 'c1',
        authorId: mine ? 'me' : 'peer',
        isMine: mine,
        kind: MessageKind.text,
        content: MessageContent.text(body: body),
        createdAt: DateTime.utc(2026),
        deliveryState:
            state ?? (mine ? DeliveryState.sent : DeliveryState.read),
      );

  testWidgets('own + other bubbles render with a delivery status on mine', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        Column(
          children: [
            MessageBubble(message: text('Hi there', mine: false)),
            MessageBubble(
              message: text('Hey!', mine: true, state: DeliveryState.read),
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Hi there'), findsOneWidget);
    expect(find.text('Hey!'), findsOneWidget);
    expect(find.byType(DeliveryStatus), findsOneWidget);
    expect(find.text('Seen'), findsOneWidget);
  });

  testWidgets('a failed message shows the failed status', (tester) async {
    await tester.pumpWidget(
      host(
        MessageBubble(
          message: text('oops', mine: true, state: DeliveryState.failed),
          onRetry: () {},
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Not delivered'), findsOneWidget);
  });

  testWidgets('the typing indicator renders', (tester) async {
    await tester.pumpWidget(host(const TypingIndicator()));
    await tester.pump();
    expect(find.byType(TypingIndicator), findsOneWidget);
    expect(find.bySemanticsLabel('typing'), findsOneWidget);
  });

  testWidgets('the composer sends typed text', (tester) async {
    String? sent;
    await tester.pumpWidget(
      host(
        ChatComposer(
          onSendText: (t) => sent = t,
          onTyping: (_) {},
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), 'hello world');
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pump();
    expect(sent, 'hello world');
  });
}
