import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/theme/app_colors.dart';
import 'package:we36/core/theme/app_colors_x.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('Design tokens (US3)', () {
    testWidgets('context.tokens resolves the light palette', (tester) async {
      late AppColorsX tokens;
      await pumpApp(
        tester,
        Builder(
          builder: (context) {
            tokens = context.tokens;
            return const SizedBox();
          },
        ),
      );
      expect(tokens.bgApp, AppColors.gray50);
      expect(tokens.accent, AppColors.rose500);
    });

    testWidgets('dark palette is ink-tinted, never pure black', (tester) async {
      late AppColorsX tokens;
      await pumpApp(
        tester,
        Builder(
          builder: (context) {
            tokens = context.tokens;
            return const SizedBox();
          },
        ),
        themeMode: ThemeMode.dark,
      );
      expect(tokens.bgApp, AppColors.darkBg);
      expect(tokens.bgApp, isNot(const Color(0xFF000000)));
    });
  });
}
