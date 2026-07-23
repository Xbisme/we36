import 'package:flutter/material.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_typography.dart';

/// A small rose dot (unread indicator) or count pill. Constitution VI.
class AppBadge extends StatelessWidget {
  const AppBadge({this.count, super.key});

  /// When null, renders a dot; otherwise a count pill ("9", "99+").
  final int? count;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    if (count == null) {
      return Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: tokens.accent,
          shape: BoxShape.circle,
          border: Border.all(color: tokens.surface, width: 2),
        ),
      );
    }
    final text = count! > 99 ? '99+' : '$count';
    return Container(
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: tokens.accent,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: tokens.surface, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: AppTypography.caption.copyWith(
          color: tokens.textOnBrand,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          height: 1,
        ),
      ),
    );
  }
}
