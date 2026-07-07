import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/feed/post.dart';
import 'package:we36/core/data/profile/account_row.dart';
import 'package:we36/core/data/profile/profile_view.dart';
import 'package:we36/core/data/user/user.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/profile/presentation/widgets/account_row_tile.dart';
import 'package:we36/features/profile/presentation/widgets/follow_button.dart';
import 'package:we36/features/profile/presentation/widgets/private_gate.dart';
import 'package:we36/features/profile/presentation/widgets/profile_header.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// Golden coverage (#010 T051) for the profile chrome in light + dark.
ViewerRelationship _rel({bool following = false, bool requested = false}) =>
    ViewerRelationship(
      following: following,
      requested: requested,
      followsYou: false,
      blocking: false,
    );

ProfileView _view() => ProfileView(
  user: const User(
    id: 'u_alice',
    username: 'alice_travel',
    displayName: 'Alice Travel',
    isPrivate: false,
    isVerified: true,
    followersCount: 12300,
    followingCount: 311,
    postsCount: 87,
    bio: 'Wandering the world.',
  ),
  relationship: _rel(),
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
  Size size = const Size(375, 220),
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
  testWidgets('ProfileHeader golden', (tester) async {
    await _golden(
      tester,
      'profile_header',
      Padding(
        padding: const EdgeInsets.all(16),
        child: ProfileHeader(
          view: _view(),
          website: 'alice.example',
          actions: const SizedBox(),
        ),
      ),
      size: const Size(375, 320),
    );
  });

  testWidgets('FollowButton states golden', (tester) async {
    await _golden(
      tester,
      'follow_button',
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final r in [
            _rel(),
            _rel(following: true),
            _rel(requested: true),
          ])
            Padding(
              padding: const EdgeInsets.all(6),
              child: FollowButton(
                relationship: r,
                username: 'alice_travel',
                onFollow: () {},
                onUnfollow: () {},
                onWithdraw: () {},
              ),
            ),
        ],
      ),
    );
  });

  testWidgets('PrivateGate golden', (tester) async {
    await _golden(tester, 'private_gate', const PrivateGate());
  });

  testWidgets('AccountRowTile golden', (tester) async {
    await _golden(
      tester,
      'account_row_tile',
      AccountRowTile(
        row: AccountRow(
          user: const UserSummary(
            id: 'u_bob',
            username: 'bob_makes',
            displayName: 'Bob Makes',
            isVerified: false,
          ),
          relationship: _rel(),
        ),
        onFollow: () {},
        onUnfollow: () {},
      ),
      size: const Size(375, 80),
    );
  });
}
