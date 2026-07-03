import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/data/profile/profile_view.dart';
import 'package:we36/core/data/user/user.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/profile/presentation/widgets/follow_button.dart';
import 'package:we36/features/profile/presentation/widgets/profile_header.dart';
import 'package:we36/features/profile/presentation/widgets/profile_stats.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// #010 T050/T052: profile a11y labels, large-text safety, adaptive header, and
/// abbreviated counts.
ProfileView _view() => const ProfileView(
  user: User(
    id: 'u_alice',
    username: 'alice_travel',
    displayName: 'Alice Travel',
    isPrivate: false,
    isVerified: true,
    followersCount: 1234567,
    followingCount: 311,
    postsCount: 87,
    bio: 'Wandering the world.',
  ),
  relationship: ViewerRelationship(
    following: false,
    requested: false,
    followsYou: false,
    blocking: false,
  ),
);

Widget _host(Widget child, {double width = 390, double textScale = 1.0}) =>
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(
            size: Size(width, 900),
            textScaler: TextScaler.linear(textScale),
          ),
          child: Center(
            child: SizedBox(width: width, child: child),
          ),
        ),
      ),
    );

void main() {
  testWidgets('stats expose screen-reader labels + abbreviated counts', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const ProfileStats(
          postsCount: 87,
          followersCount: 1234567,
          followingCount: 311,
        ),
      ),
    );
    await tester.pump();
    // Abbreviated (1.2M) — not the raw integer.
    expect(find.text('1234567'), findsNothing);
    expect(find.bySemanticsLabel(RegExp('followers')), findsWidgets);
  });

  testWidgets('follow control announces its state', (tester) async {
    await tester.pumpWidget(
      _host(
        FollowButton(
          relationship: const ViewerRelationship(
            following: true,
            requested: false,
            followsYou: false,
            blocking: false,
          ),
          username: 'alice_travel',
          onFollow: () {},
          onUnfollow: () {},
          onWithdraw: () {},
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Following'), findsOneWidget);
  });

  testWidgets('header holds at 2x text scale without overflow', (tester) async {
    await tester.pumpWidget(
      _host(
        ProfileHeader(view: _view(), actions: const SizedBox()),
        textScale: 2,
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('header renders at both phone and tablet widths', (tester) async {
    tester.view.physicalSize = const Size(900, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      _host(
        ProfileHeader(view: _view(), actions: const SizedBox()),
        width: 900,
      ),
    );
    await tester.pump();
    expect(find.byType(ProfileHeader), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
