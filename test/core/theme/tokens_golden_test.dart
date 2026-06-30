import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_gradients.dart';
import 'package:we36/core/theme/app_typography.dart';

import '../../helpers/pump_app.dart';

/// US3 golden: a token gallery (semantic color swatches + brand gradients +
/// type scale) captured in light and dark so any unintended token or type drift
/// is caught by `flutter test`. (T027)
void main() {
  group('Token gallery golden (US3)', () {
    testWidgets('light', (tester) async {
      await pumpApp(
        tester,
        const _TokenGallery(),
        surfaceSize: const Size(420, 900),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(_TokenGallery),
        matchesGoldenFile('goldens/tokens_light.png'),
      );
    });

    testWidgets('dark', (tester) async {
      await pumpApp(
        tester,
        const _TokenGallery(),
        surfaceSize: const Size(420, 900),
        themeMode: ThemeMode.dark,
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(_TokenGallery),
        matchesGoldenFile('goldens/tokens_dark.png'),
      );
    });
  });
}

class _TokenGallery extends StatelessWidget {
  const _TokenGallery();

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final swatches = <(String, Color)>[
      ('bgApp', t.bgApp),
      ('surface', t.surface),
      ('surface2', t.surface2),
      ('border', t.border),
      ('textPrimary', t.textPrimary),
      ('textSecondary', t.textSecondary),
      ('accent', t.accent),
      ('accentSoft', t.accentSoft),
      ('iconActive', t.iconActive),
      ('success', t.success),
      ('warning', t.warning),
      ('error', t.error),
    ];
    return Scaffold(
      backgroundColor: t.bgApp,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Semantic color swatches.
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (name, color) in swatches)
                  _Swatch(name: name, color: color, border: t.border),
              ],
            ),
            const SizedBox(height: 16),
            // Brand gradients (only ever on highlights, never a page wash).
            const Row(
              children: [
                _GradientChip(label: 'brand', gradient: AppGradients.brand),
                SizedBox(width: 8),
                _GradientChip(label: 'story', gradient: AppGradients.story),
              ],
            ),
            const SizedBox(height: 16),
            // Type scale.
            Text(
              'Display',
              style: AppTypography.displayLarge.copyWith(color: t.textPrimary),
            ),
            Text(
              'Heading 1',
              style: AppTypography.h1.copyWith(color: t.textPrimary),
            ),
            Text(
              'Heading 2',
              style: AppTypography.h2.copyWith(color: t.textPrimary),
            ),
            Text(
              'Heading 3',
              style: AppTypography.h3.copyWith(color: t.textPrimary),
            ),
            Text(
              'Body 16 — the quick brown fox',
              style: AppTypography.body16.copyWith(color: t.textPrimary),
            ),
            Text(
              'Label',
              style: AppTypography.label.copyWith(color: t.textPrimary),
            ),
            Text(
              'Caption',
              style: AppTypography.caption.copyWith(color: t.textSecondary),
            ),
            Text(
              '12,480',
              style: AppTypography.stat.copyWith(color: t.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.name,
    required this.color,
    required this.border,
  });

  final String name;
  final Color color;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: border),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 56,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(
              color: context.tokens.textSecondary,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}

class _GradientChip extends StatelessWidget {
  const _GradientChip({required this.label, required this.gradient});

  final String label;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTypography.label.copyWith(color: Colors.white),
      ),
    );
  }
}
