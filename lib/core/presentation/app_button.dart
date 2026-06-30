import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_gradients.dart';
import 'package:we36/core/theme/app_shadows.dart';
import 'package:we36/core/theme/app_typography.dart';

enum AppButtonKind { primary, secondary, ghost }

enum AppButtonSize { sm, md }

/// The We36 button: gradient pill (primary), bordered pill (secondary), or
/// transparent (ghost). Press = scale 0.97. Constitution VI.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    this.onPressed,
    this.kind = AppButtonKind.primary,
    this.size = AppButtonSize.md,
    this.fullWidth = false,
    this.leadingIcon,
    this.danger = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonKind kind;
  final AppButtonSize size;
  final bool fullWidth;
  final IconData? leadingIcon;

  /// Destructive primary action — solid error fill instead of brand gradient.
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final disabled = onPressed == null;
    final height = size == AppButtonSize.sm ? 36.0 : 48.0;
    final hPad = size == AppButtonSize.sm ? AppSpacing.lg : AppSpacing.xl;

    final isPrimary = kind == AppButtonKind.primary;
    final fg = switch (kind) {
      AppButtonKind.primary => tokens.textOnBrand,
      AppButtonKind.secondary => tokens.textPrimary,
      AppButtonKind.ghost => tokens.accent,
    };

    final content = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          AppIcon(leadingIcon!, size: 18, color: fg),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          label,
          style: AppTypography.label.copyWith(color: fg),
        ),
      ],
    );

    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: Pressable(
        onTap: onPressed,
        child: Semantics(
          button: true,
          enabled: !disabled,
          label: label,
          child: Container(
            height: height,
            width: fullWidth ? double.infinity : null,
            padding: EdgeInsets.symmetric(horizontal: hPad),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: isPrimary && !danger ? AppGradients.brand : null,
              color: switch (kind) {
                AppButtonKind.primary => danger ? tokens.error : null,
                AppButtonKind.secondary => tokens.surface2,
                AppButtonKind.ghost => Colors.transparent,
              },
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: kind == AppButtonKind.secondary
                  ? Border.all(color: tokens.border)
                  : null,
              boxShadow: isPrimary && !disabled ? AppShadows.brand : null,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
