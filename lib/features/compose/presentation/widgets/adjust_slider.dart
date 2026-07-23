import 'package:flutter/material.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_gradients.dart';
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
                  trackShape: _GradientTrackShape(
                    gradient: AppGradients.brand,
                    inactiveColor: tokens.surface2,
                  ),
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

/// A slider track whose active segment is painted with the brand gradient
/// instead of a flat colour (Screen 12) — colour earns its place on the active
/// fill only (Constitution VI). The inactive remainder stays neutral.
class _GradientTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  const _GradientTrackShape({
    required this.gradient,
    required this.inactiveColor,
  });

  final Gradient gradient;
  final Color inactiveColor;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final radius = Radius.circular(trackRect.height / 2);

    // Inactive full track underneath.
    final canvas = context.canvas
      ..drawRRect(
        RRect.fromRectAndRadius(trackRect, radius),
        Paint()..color = inactiveColor,
      );

    // Active segment from the leading edge to the thumb, gradient-filled.
    final ltr = textDirection == TextDirection.ltr;
    final activeRect = ltr
        ? Rect.fromLTRB(
            trackRect.left,
            trackRect.top,
            thumbCenter.dx,
            trackRect.bottom,
          )
        : Rect.fromLTRB(
            thumbCenter.dx,
            trackRect.top,
            trackRect.right,
            trackRect.bottom,
          );
    if (activeRect.width <= 0) return;
    canvas.drawRRect(
      RRect.fromRectAndRadius(activeRect, radius),
      Paint()..shader = gradient.createShader(activeRect),
    );
  }
}
