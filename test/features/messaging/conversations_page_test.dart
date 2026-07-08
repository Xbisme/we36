import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/messaging/presentation/conversations_page.dart';
import 'package:we36/features/messaging/presentation/cubit/conversations_cubit.dart';
import 'package:we36/features/messaging/presentation/cubit/conversations_state.dart';
import 'package:we36/features/messaging/presentation/widgets/conversation_tile.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

import '../../helpers/messaging_test_doubles.dart';

/// #012 US1 T029: the conversation list renders rows + active-now rail + the
/// new-message action, plus the empty state — driven by a seeded stub cubit
/// (no real drift/socket inside testWidgets — the #009 gate learning).
void main() {
  Widget host(ConversationsState state) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: BlocProvider<ConversationsCubit>.value(
        value: StubConversationsCubit(state),
        // A no-op open callback keeps the render test free of navigation.
        child: ConversationsPage(onOpenConversation: (_, _) {}),
      ),
    ),
  );

  testWidgets('renders conversation rows + the new-message action', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      host(ConversationsState.loaded(conversations: stubConversations())),
    );
    await tester.pump();

    expect(find.byType(ConversationTile), findsNWidgets(2));
    expect(find.text('Ava Nguyen'), findsWidgets);
    expect(find.text('See you tomorrow!'), findsOneWidget);
    // The new-message (+) action is present.
    expect(find.bySemanticsLabel('New message'), findsOneWidget);
  });

  testWidgets('shows the empty state when there are no conversations', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      host(const ConversationsState.loaded(conversations: [])),
    );
    await tester.pump();

    expect(find.byType(ConversationTile), findsNothing);
    expect(find.text('No messages yet'), findsOneWidget);
  });
}
