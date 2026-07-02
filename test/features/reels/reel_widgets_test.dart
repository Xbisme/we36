import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/reels/presentation/widgets/reel_action_rail.dart';
import 'package:we36/features/reels/presentation/widgets/reel_view.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

Reel _reel({bool ready = true}) => Reel(
  id: 'r1',
  author: const UserSummary(id: 'u', username: 'maya', isVerified: false),
  video: Media(
    id: 'm1',
    kind: MediaKind.video,
    status: ready ? MediaStatus.ready : MediaStatus.processing,
  ),
  hashtags: const [],
  taggedUsers: const [],
  commentsDisabled: false,
  likeCount: 128,
  saveCount: 9,
  commentCount: 4,
  viewerHasLiked: true,
  viewerHasSaved: false,
  isVideoReady: ready,
  createdAt: DateTime.utc(2026, 7),
  caption: 'trail run @maya #dawn',
);

Widget _host(Widget child, {ThemeMode mode = ThemeMode.light, double scale = 1}) {
  return MaterialApp(
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: mode,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: Scaffold(body: SizedBox(width: 420, height: 800, child: child)),
    ),
  );
}

void main() {
  testWidgets('action rail exposes labelled controls in light + dark @2x', (
    tester,
  ) async {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      await tester.pumpWidget(
        _host(
          ReelActionRail(
            reel: _reel(),
            onLike: () {},
            onComment: () {},
            onShare: () {},
            onSave: () {},
            onMore: () {},
          ),
          mode: mode,
          scale: 2,
        ),
      );
      expect(tester.takeException(), isNull);
      // Every action-rail control is announced (SC-009 / FR-027).
      expect(find.bySemanticsLabel('Unlike'), findsOneWidget);
      expect(find.bySemanticsLabel('Comments'), findsOneWidget);
      expect(find.bySemanticsLabel('Save'), findsOneWidget);
      expect(find.bySemanticsLabel('Share'), findsOneWidget);
      expect(find.bySemanticsLabel('More options'), findsOneWidget);
    }
  });

  testWidgets('tapping the like control fires the callback', (tester) async {
    var liked = false;
    await tester.pumpWidget(
      _host(
        ReelActionRail(
          reel: _reel(),
          onLike: () => liked = true,
          onComment: () {},
          onShare: () {},
          onSave: () {},
          onMore: () {},
        ),
      ),
    );
    await tester.tap(find.bySemanticsLabel('Unlike'));
    expect(liked, isTrue);
  });

  testWidgets('ReelView under Reduce Motion shows the poster (no video)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        ReelView(
          reel: _reel(),
          player: null, // no player → poster path
          isActive: true,
          reduceMotion: true, // FR-026: no autoplay
          isPaused: false,
          onTap: () {},
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    // A reel exposes a semantics label for its author.
    expect(find.bySemanticsLabel(RegExp('Reel by maya')), findsOneWidget);
  });
}
