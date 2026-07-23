import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_gradients.dart';
import 'package:we36/core/theme/app_shadows.dart';
import 'package:we36/core/theme/app_typography.dart';

enum AppButtonKind { primary, secondary, ghost }

enum AppButtonSize { sm, md, lg }

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
    // Design SIZES (_ds Button): sm 36/14px pad/font14/icon16 · md 44/20/15/18
    // · lg 52/28/16/20.
    final (height, hPad, fontSize, iconSize) = switch (size) {
      AppButtonSize.sm => (36.0, 14.0, 14.0, 16.0),
      AppButtonSize.md => (44.0, 20.0, 15.0, 18.0),
      AppButtonSize.lg => (52.0, 28.0, 16.0, 20.0),
    };

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
          AppIcon(leadingIcon!, size: iconSize, color: fg),
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTypography.label.copyWith(color: fg, fontSize: fontSize),
          ),
        ),
      ],
    );

    return Opacity(
      opacity: disabled ? 0.45 : 1,
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
                AppButtonKind.secondary => tokens.surface,
                AppButtonKind.ghost => Colors.transparent,
              },
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: kind == AppButtonKind.secondary
                  ? Border.all(color: tokens.borderStrong)
                  : null,
              // Design: primary rests on shadow-sm; the heavier brand glow is a
              // hover-only affordance (no hover on touch).
              boxShadow: isPrimary && !disabled ? AppShadows.sm : null,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
