import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/comments/comment.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/post/presentation/widgets/comment_input.dart';
import 'package:we36/features/post/presentation/widgets/comment_tile.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// #006 polish (SC-008): comment widgets meet Semantics + text-scaling +
/// light/dark on both phone and tablet.
void main() {
  Comment comment({bool isReply = false, bool own = false}) => Comment(
    id: 'c1',
    postId: 'p1',
    author: const CommentAuthor(id: 'u', username: 'maya', isVerified: false),
    text: 'love this @friend #wow',
    createdAt: DateTime.utc(2026, 7, 2, 10),
    likeCount: 3,
    viewerHasLiked: false,
    isOwn: own,
    parentId: isReply ? 'c0' : null,
  );

  Widget host(
    Widget child, {
    ThemeMode mode = ThemeMode.light,
    double scale = 1,
  }) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: mode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: Scaffold(
          body: SizedBox(width: 400, child: child),
        ),
      ),
    );
  }

  testWidgets('comment tile renders with Semantics at 2x text, light + dark', (
    tester,
  ) async {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      await tester.pumpWidget(
        host(CommentTile(comment: comment()), mode: mode, scale: 2),
      );
      expect(tester.takeException(), isNull);
      // Comment content exposed to screen readers.
      expect(
        find.bySemanticsLabel(RegExp('maya: love this')),
        findsOneWidget,
      );
      expect(find.text('Reply'), findsOneWidget);
    }
  });

  testWidgets('reply tile (indented) renders without overflow at 2x', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(CommentTile(comment: comment(isReply: true)), scale: 2),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('comment input renders with a labelled Post action at 2x', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(CommentInput(onSubmit: (_) async => true), scale: 2),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Post'), findsOneWidget);
    // Quick-emoji row exposes insert Semantics.
    expect(find.bySemanticsLabel('Insert 🔥'), findsOneWidget);
  });
}
