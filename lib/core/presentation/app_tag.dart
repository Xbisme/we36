import 'package:flutter/material.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/theme/app_colors.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_gradients.dart';
import 'package:we36/core/theme/app_typography.dart';

/// Pill chip. `active` fills with the brand gradient; `hashtag` prefixes a
/// violet `#` glyph. Constitution VI.
class AppTag extends StatelessWidget {
  const AppTag({
    required this.label,
    this.active = false,
    this.hashtag = false,
    this.onTap,
    super.key,
  });

  final String label;
  final bool active;
  final bool hashtag;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final fg = active ? tokens.textOnBrand : tokens.textPrimary;
    return Pressable(
      onTap: onTap,
      child: Semantics(
        button: onTap != null,
        label: label,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: active ? AppGradients.brand : null,
            color: active ? null : tokens.surface2,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hashtag)
                Text(
                  '#',
                  style: AppTypography.label.copyWith(
                    color: active ? fg : AppColors.violet500,
                  ),
                ),
              Text(label, style: AppTypography.label.copyWith(color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}
