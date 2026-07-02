import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/comments/comment.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/post/presentation/cubit/comments_state.dart';
import 'package:we36/features/post/presentation/widgets/comment_input.dart';
import 'package:we36/features/post/presentation/widgets/comment_tile.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// Golden coverage for the comment widgets (tile + reply indent + input) in
/// light + dark (T043). Regenerate baselines with `flutter test --update-goldens`.
void main() {
  Comment top() => Comment(
    id: 'c0',
    postId: 'p1',
    author: const CommentAuthor(id: 'u1', username: 'maya', isVerified: true),
    text: 'golden hour by the water @friend #goldenhour',
    createdAt: DateTime.utc(2026, 7, 2, 9),
    likeCount: 12,
    viewerHasLiked: true,
    isOwn: false,
    replyCount: 1,
  );

  Comment reply() => Comment(
    id: 'c0-r0',
    postId: 'p1',
    author: const CommentAuthor(id: 'u2', username: 'leo', isVerified: false),
    text: 'stunning 😍',
    createdAt: DateTime.utc(2026, 7, 2, 9, 5),
    likeCount: 2,
    viewerHasLiked: false,
    isOwn: true,
    parentId: 'c0',
  );

  Widget host(Widget child, ThemeMode mode) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: mode,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Center(child: SizedBox(width: 390, child: child)),
    ),
  );

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    final suffix = mode == ThemeMode.light ? 'light' : 'dark';

    testWidgets('comment list golden — $suffix', (tester) async {
      await tester.pumpWidget(
        host(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommentTile(comment: top()),
              CommentTile(comment: reply()),
            ],
          ),
          mode,
        ),
      );
      await tester.pump();
      await expectLater(
        find.byType(Column).first,
        matchesGoldenFile('goldens/comment_list_$suffix.png'),
      );
    });

    testWidgets('comment input golden — $suffix', (tester) async {
      await tester.pumpWidget(
        host(
          CommentInput(
            onSubmit: (_) async => true,
            replyContext: const ReplyContext(parentId: 'c0', handle: '@maya'),
          ),
          mode,
        ),
      );
      await tester.pump();
      await expectLater(
        find.byType(CommentInput),
        matchesGoldenFile('goldens/comment_input_$suffix.png'),
      );
    });
  }
}
