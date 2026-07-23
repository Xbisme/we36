import 'package:flutter/material.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';

/// Pill chip. `active` = soft-rose fill with an accent border and accent text;
/// inactive = neutral surface with secondary text. `hashtag` prefixes a `#`
/// glyph. Constitution VI.
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
    final fg = active ? tokens.accent : tokens.textSecondary;
    return Pressable(
      onTap: onTap,
      child: Semantics(
        button: onTap != null,
        label: label,
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: active ? tokens.accentSoft : tokens.surface2,
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: active ? Border.all(color: tokens.accent) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hashtag)
                Text(
                  '#',
                  style: AppTypography.label.copyWith(
                    color: active ? tokens.accent : tokens.textTertiary,
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
