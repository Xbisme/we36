import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_shadows.dart';
import 'package:we36/core/theme/app_typography.dart';

/// Top-corner radius of the bottom-anchored action sheet (design: 24; no
/// AppRadius token maps to this exact value).
const double _sheetTopRadius = 24;

/// Radius of the separate Cancel card (design: 16).
const double _cancelRadius = 16;

/// One row in an action sheet.
class ActionSheetItem {
  const ActionSheetItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;
}

/// Shows the We36 bottom action sheet (rounded top, handle, rows, separate
/// Cancel). Constitution VI.
Future<void> showAppActionSheet(
  BuildContext context, {
  required List<ActionSheetItem> items,
  required String cancelLabel,
}) {
  final tokens = context.tokens;
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Full-bleed, bottom-anchored card with top-only rounded corners
            // and an upward-cast shadow (design G4).
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: tokens.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(_sheetTopRadius),
                ),
                boxShadow: AppShadows.lg,
              ),
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 38,
                    height: 4,
                    margin: const EdgeInsets.only(
                      top: 10,
                      bottom: AppSpacing.xs + 2,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.borderStrong,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  for (var i = 0; i < items.length; i++)
                    Pressable(
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        items[i].onTap();
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: i == 0
                              ? null
                              : Border(
                                  top: BorderSide(color: tokens.divider),
                                ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 15,
                        ),
                        child: Row(
                          children: [
                            AppIcon(
                              items[i].icon,
                              size: 22,
                              color: items[i].destructive ? tokens.error : null,
                            ),
                            const SizedBox(width: 14),
                            Text(
                              items[i].label,
                              style: AppTypography.body16.copyWith(
                                fontWeight: FontWeight.w500,
                                color: items[i].destructive
                                    ? tokens.error
                                    : tokens.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 18),
              child: GestureDetector(
                onTap: () => Navigator.of(sheetContext).pop(),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tokens.surface,
                    borderRadius: BorderRadius.circular(_cancelRadius),
                    boxShadow: AppShadows.sm,
                  ),
                  child: Text(
                    cancelLabel,
                    style: AppTypography.body16.copyWith(
                      fontWeight: FontWeight.w700,
                      color: tokens.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
