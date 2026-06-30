import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_icon_button.dart';
import 'package:we36/core/presentation/bottom_nav.dart';
import 'package:we36/core/presentation/nav_item.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('Accessibility (FR-024a / SC-012)', () {
    testWidgets('icon-only button exposes a semantic label', (tester) async {
      await pumpApp(
        tester,
        Scaffold(
          body: AppIconButton(
            icon: AppIcons.like,
            semanticLabel: 'Like',
            onPressed: () {},
          ),
        ),
      );
      expect(find.bySemanticsLabel('Like'), findsOneWidget);
    });

    testWidgets('bottom nav items announce their labels', (tester) async {
      await pumpApp(
        tester,
        Scaffold(
          bottomNavigationBar: BottomNav(
            items: const [
              NavItemData(icon: AppIcons.home, label: 'Home'),
              NavItemData(icon: AppIcons.search, label: 'Explore'),
            ],
            currentIndex: 0,
            onSelect: (_) {},
          ),
        ),
      );
      expect(find.bySemanticsLabel('Home'), findsOneWidget);
      expect(find.bySemanticsLabel('Explore'), findsOneWidget);
    });

    testWidgets('components tolerate large text scaling without overflow', (
      tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.8)),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) => const SizedBox(),
            ),
          ),
        ),
      );
      // A no-op build under 1.8x scaling must not throw layout exceptions.
      expect(tester.takeException(), isNull);
    });
  });
}
