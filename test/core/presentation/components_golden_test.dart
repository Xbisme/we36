import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/presentation/bottom_nav.dart';
import 'package:we36/core/presentation/nav_item.dart';
import 'package:we36/core/presentation/post_card.dart';
import 'package:we36/core/presentation/sidebar_rail.dart';
import 'package:we36/core/theme/app_colors_x.dart';

import '../../helpers/pump_app.dart';

/// US4 golden coverage for the four chrome-defining components, in light + dark
/// (T035). Media providers are omitted on purpose — #001 is offline, so cards
/// render their placeholder surface (no network in tests).
void main() {
  const navItems = [
    NavItemData(icon: AppIcons.home, label: 'Home'),
    NavItemData(icon: AppIcons.search, label: 'Explore'),
    NavItemData(icon: AppIcons.reels, label: 'Reels'),
    NavItemData(icon: AppIcons.messages, label: 'Messages', badgeCount: 3),
    NavItemData(icon: AppIcons.profile, label: 'Profile'),
  ];

  Future<void> goldenFor(
    WidgetTester tester,
    String name,
    Widget child, {
    required Size size,
  }) async {
    for (final mode in ThemeMode.values.where((m) => m != ThemeMode.system)) {
      final suffix = mode == ThemeMode.dark ? 'dark' : 'light';
      await pumpApp(tester, child, surfaceSize: size, themeMode: mode);
      await tester.pumpAndSettle();
      await expectLater(
        find.byWidget(child),
        matchesGoldenFile('goldens/${name}_$suffix.png'),
      );
    }
  }

  testWidgets('PostCard', (tester) async {
    const card = Center(
      child: SizedBox(
        width: 360,
        child: PostCard(
          username: 'maivu',
          location: 'Da Nang, Vietnam',
          likesText: '1,204 likes',
          caption: 'Golden hour by the river 🌅',
          commentsText: 'View all 38 comments',
          timeText: '2 hours ago',
          liked: true,
        ),
      ),
    );
    await goldenFor(tester, 'post_card', card, size: const Size(400, 740));
  });

  testWidgets('Avatar ring/online/create variants', (tester) async {
    const avatars = Center(
      child: Wrap(
        spacing: 20,
        children: [
          Avatar(size: 64, ring: AvatarRing.unseen),
          Avatar(size: 64, ring: AvatarRing.seen),
          Avatar(size: 64, online: true),
          Avatar(size: 64, showCreateBadge: true),
        ],
      ),
    );
    await goldenFor(tester, 'avatar', avatars, size: const Size(380, 140));
  });

  testWidgets('BottomNav', (tester) async {
    final nav = Scaffold(
      bottomNavigationBar: BottomNav(
        items: navItems,
        currentIndex: 0,
        onSelect: (_) {},
      ),
    );
    await goldenFor(tester, 'bottom_nav', nav, size: const Size(390, 120));
  });

  testWidgets('SidebarRail full + compact', (tester) async {
    Widget rail({required bool compact}) => Builder(
      builder: (context) => ColoredBox(
        color: context.tokens.bgApp,
        child: SidebarRail(
          items: navItems,
          currentIndex: 0,
          compact: compact,
          profileName: 'Mai Vu',
          onSelect: (_) {},
        ),
      ),
    );
    await goldenFor(
      tester,
      'sidebar_rail_full',
      rail(compact: false),
      size: const Size(260, 640),
    );
    await goldenFor(
      tester,
      'sidebar_rail_compact',
      rail(compact: true),
      size: const Size(110, 640),
    );
  });
}
