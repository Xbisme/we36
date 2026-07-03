import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/explore/presentation/cubit/search_state.dart';
import 'package:we36/features/explore/presentation/widgets/account_result_row.dart';
import 'package:we36/features/explore/presentation/widgets/category_chips.dart';
import 'package:we36/features/explore/presentation/widgets/discovery_grid_tile.dart';
import 'package:we36/features/explore/presentation/widgets/result_rows.dart';
import 'package:we36/features/explore/presentation/widgets/results_tabs.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// Golden coverage (#009 T051) for the discovery chrome widgets in light + dark.
UserSummary _user() => const UserSummary(
  id: 'u',
  username: 'alice_travel',
  displayName: 'Alice Travel',
  isVerified: true,
);

ExploreItem _reelItem() => ExploreItem(
  kind: ExploreItemKind.reel,
  reel: Reel(
    id: 'r1',
    author: _user(),
    video: const Media(
      id: 'm',
      kind: MediaKind.video,
      status: MediaStatus.ready,
    ),
    hashtags: const [],
    taggedUsers: const [],
    commentsDisabled: false,
    likeCount: 0,
    saveCount: 0,
    commentCount: 0,
    viewerHasLiked: false,
    viewerHasSaved: false,
    isVideoReady: true,
    createdAt: DateTime.utc(2026, 7),
  ),
);

Widget _host(Widget child, ThemeMode mode, {double width = 375}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: mode,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: Center(
      child: SizedBox(width: width, child: child),
    ),
  ),
);

Future<void> _golden(
  WidgetTester tester,
  String name,
  Widget child, {
  double width = 375,
  Size size = const Size(375, 120),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    await tester.pumpWidget(_host(child, mode, width: width));
    await tester.pump();
    final suffix = mode == ThemeMode.dark ? 'dark' : 'light';
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/${name}_$suffix.png'),
    );
  }
}

void main() {
  testWidgets('AccountResultRow golden', (tester) async {
    await _golden(
      tester,
      'account_result_row',
      AccountResultRow(
        result: AccountResult(
          user: _user(),
          relationship: const ViewerRelationship(
            following: false,
            requested: false,
            followsYou: false,
            blocking: false,
          ),
        ),
        onTap: () {},
      ),
      size: const Size(375, 72),
    );
  });

  testWidgets('HashtagResultRow golden', (tester) async {
    await _golden(
      tester,
      'hashtag_result_row',
      HashtagResultRow(
        result: const HashtagResult(tag: 'goldenhour', postCount: 1200000),
        onTap: () {},
      ),
      size: const Size(375, 72),
    );
  });

  testWidgets('ResultsTabs golden', (tester) async {
    await _golden(
      tester,
      'results_tabs',
      ResultsTabs(
        active: SearchTab.accounts,
        labels: const {
          SearchTab.top: 'Top',
          SearchTab.accounts: 'Accounts',
          SearchTab.tags: 'Tags',
          SearchTab.places: 'Places',
        },
        onSelect: (_) {},
      ),
      size: const Size(375, 56),
    );
  });

  testWidgets('CategoryChips golden', (tester) async {
    await _golden(
      tester,
      'category_chips',
      CategoryChips(onSelect: (_) {}),
      size: const Size(375, 48),
    );
  });

  testWidgets('DiscoveryGridTile (reel marker) golden', (tester) async {
    await _golden(
      tester,
      'discovery_grid_tile_reel',
      SizedBox(
        width: 120,
        height: 120,
        child: DiscoveryGridTile(item: _reelItem(), onTap: () {}),
      ),
      width: 120,
      size: const Size(120, 120),
    );
  });
}
