import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';

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
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: tokens.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 38,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: tokens.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    for (final item in items)
                      Pressable(
                        onTap: () {
                          Navigator.of(sheetContext).pop();
                          item.onTap();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.md,
                          ),
                          child: Row(
                            children: [
                              AppIcon(
                                item.icon,
                                color: item.destructive ? tokens.error : null,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Text(
                                item.label,
                                style: AppTypography.body16.copyWith(
                                  color: item.destructive
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
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: () => Navigator.of(sheetContext).pop(),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: tokens.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Text(
                    cancelLabel,
                    style: AppTypography.label.copyWith(
                      color: tokens.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
