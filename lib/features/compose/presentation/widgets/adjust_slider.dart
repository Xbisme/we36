import 'package:flutter/material.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';

/// A labelled -1..1 adjustment slider (Brightness / Contrast / Warmth) with a
/// brand-tinted active track and a white knob (Screen 12). Neutral chrome —
/// colour earns its place on the active fill only (Constitution VI).
class AdjustSlider extends StatelessWidget {
  const AdjustSlider({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Human label (already localized by the caller).
  final String label;

  /// Current value in -1.0..1.0 (0 = neutral).
  final double value;

  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Semantics(
      slider: true,
      label: label,
      value: '${(value * 100).round()}',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            SizedBox(
              width: 84,
              child: Text(
                label,
                style: AppTypography.label.copyWith(
                  color: tokens.textSecondary,
                ),
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 3,
                  activeTrackColor: tokens.accent,
                  inactiveTrackColor: tokens.surface2,
                  thumbColor: tokens.textOnBrand,
                  overlayColor: tokens.accent.withValues(alpha: 0.12),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 9,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 18,
                  ),
                ),
                child: Slider(
                  value: value.clamp(-1.0, 1.0),
                  min: -1,
                  onChanged: onChanged,
                ),
              ),
            ),
            SizedBox(
              width: 36,
              child: Text(
                '${(value * 100).round()}',
                textAlign: TextAlign.end,
                style: AppTypography.caption.copyWith(
                  color: tokens.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
