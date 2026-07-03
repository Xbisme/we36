import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/reels/presentation/widgets/processing_badge.dart';
import 'package:we36/features/reels/presentation/widgets/reel_action_rail.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// Golden coverage (T052) for the two overlay chrome widgets that sit over reel
/// video: the right-side [ReelActionRail] and the [ProcessingBadge]. Both paint
/// white-on-dark (they live above the video surface), so the golden hosts them
/// on a dark ColoredBox in light + dark themes.
Reel _reel() => Reel(
  id: 'r1',
  author: const UserSummary(id: 'u', username: 'maya', isVerified: false),
  video: const Media(
    id: 'm1',
    kind: MediaKind.video,
    status: MediaStatus.ready,
  ),
  hashtags: const [],
  taggedUsers: const [],
  commentsDisabled: false,
  likeCount: 1280,
  saveCount: 92,
  commentCount: 47,
  viewerHasLiked: true,
  viewerHasSaved: false,
  isVideoReady: true,
  createdAt: DateTime.utc(2026, 7),
  caption: 'trail run @maya #dawn',
);

Widget _host(Widget child, ThemeMode mode) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: mode,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: Center(
      child: ColoredBox(
        color: const Color(0xFF0E0E1A),
        child: Padding(padding: const EdgeInsets.all(24), child: child),
      ),
    ),
  ),
);

Future<void> _goldenBoth(
  WidgetTester tester,
  String name,
  Widget child,
) async {
  tester.view.physicalSize = const Size(240, 480);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    await tester.pumpWidget(_host(child, mode));
    await tester.pump();
    final suffix = mode == ThemeMode.dark ? 'dark' : 'light';
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/${name}_$suffix.png'),
    );
  }
}

void main() {
  testWidgets('ReelActionRail golden (light + dark)', (tester) async {
    await _goldenBoth(
      tester,
      'reel_action_rail',
      ReelActionRail(
        reel: _reel(),
        onLike: () {},
        onComment: () {},
        onShare: () {},
        onSave: () {},
        onMore: () {},
      ),
    );
  });

  testWidgets('ProcessingBadge golden (light + dark)', (tester) async {
    await _goldenBoth(tester, 'processing_badge', const ProcessingBadge());
  });
}
