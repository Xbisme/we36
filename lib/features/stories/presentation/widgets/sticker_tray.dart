import 'package:flutter/material.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/stories/presentation/widgets/story_stickers.dart';

/// Bottom-sheet picker for the fixed story sticker set (#005 US2). Returns the
/// chosen sticker key (emoji), or null if dismissed.
Future<String?> showStickerTray(BuildContext context) {
  final tokens = context.tokens;
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: tokens.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.storyStickers,
              style: AppTypography.h3.copyWith(color: tokens.textPrimary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              children: [
                for (final sticker in kStoryStickers)
                  Pressable(
                    onTap: () => Navigator.of(sheetContext).pop(sticker),
                    child: Semantics(
                      button: true,
                      label: 'Sticker $sticker',
                      child: Text(
                        sticker,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
