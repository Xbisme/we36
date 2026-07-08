import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/messaging/presentation/widgets/conversation_tile.dart';
import 'package:we36/features/messaging/presentation/widgets/message_bubble.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// #012 US6 (T051): goldens for the messaging widgets, light + dark. Avatars have
/// no url (neutral placeholder) so the goldens stay deterministic (no network).
void main() {
  Widget frame(
    Widget child, {
    required bool dark,
    Size size = const Size(390, 96),
  }) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: dark ? AppTheme.dark : AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Center(
        child: SizedBox(width: size.width, height: size.height, child: child),
      ),
    ),
  );

  Conversation unread() => Conversation(
    id: 'c_ava',
    participant: const UserSummary(
      id: 'u_ava',
      isVerified: true,
      username: 'ava',
      displayName: 'Ava Nguyen',
    ),
    lastActivityAt: DateTime.utc(2026),
    unreadCount: 2,
    lastMessagePreview: 'See you tomorrow!',
    participantOnline: true,
  );

  Message msg(String body, {required bool mine}) => Message(
    clientKey: 'k-$body',
    conversationId: 'c1',
    authorId: mine ? 'me' : 'peer',
    isMine: mine,
    kind: MessageKind.text,
    content: MessageContent.text(body: body),
    createdAt: DateTime.utc(2026),
    deliveryState: DeliveryState.read,
  );

  for (final dark in [false, true]) {
    final suffix = dark ? 'dark' : 'light';

    testWidgets('conversation tile golden — $suffix', (tester) async {
      await tester.pumpWidget(
        frame(
          ConversationTile(conversation: unread(), onTap: () {}),
          dark: dark,
        ),
      );
      await tester.pump();
      await expectLater(
        find.byType(ConversationTile),
        matchesGoldenFile('goldens/conversation_tile_$suffix.png'),
      );
    });

    testWidgets('message bubbles golden — $suffix', (tester) async {
      await tester.pumpWidget(
        frame(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MessageBubble(message: msg('Hey! Are we still on?', mine: false)),
              MessageBubble(message: msg('Yes — see you at 6', mine: true)),
            ],
          ),
          dark: dark,
          size: const Size(390, 220),
        ),
      );
      await tester.pump();
      await expectLater(
        find.byType(Column).first,
        matchesGoldenFile('goldens/message_bubbles_$suffix.png'),
      );
    });
  }
}
