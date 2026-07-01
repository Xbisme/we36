import 'package:flutter/widgets.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_typography.dart';

/// Selection indicator over a grid cell: a rose filled circle with the 1-based
/// carousel order (or a check when order is null), or a hollow ring when unselected.
class SelectionBadge extends StatelessWidget {
  const SelectionBadge({required this.order, super.key});

  /// 1-based selection order, or null when the cell is not selected.
  final int? order;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final selected = order != null;
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? tokens.accent : const Color(0x33000000),
        border: Border.all(color: tokens.textOnBrand, width: 1.5),
      ),
      child: selected
          ? Text(
              '$order',
              style: AppTypography.caption.copyWith(
                color: tokens.textOnBrand,
                fontWeight: FontWeight.w700,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

/// A compact check badge (used when order numbering isn't needed).
class CheckBadge extends StatelessWidget {
  const CheckBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: tokens.accent),
      child: AppIcon(AppIcons.check, size: 16, color: tokens.textOnBrand),
    );
  }
}
