import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_text_field.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/stories/domain/models/story_text_overlay.dart';

/// Prompts for a story text overlay (add or edit), capped at
/// [kStoryTextMaxLength] characters (FR-004, AS-2.6). Returns the entered text,
/// or null if dismissed/empty.
Future<String?> promptStoryText(
  BuildContext context, {
  String initial = '',
}) {
  final controller = TextEditingController(text: initial);
  final tokens = context.tokens;
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: tokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.storyAddText,
              style: AppTypography.h3.copyWith(color: tokens.textPrimary),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: context.l10n.storyAddText,
              controller: controller,
              inputFormatters: [
                LengthLimitingTextInputFormatter(kStoryTextMaxLength),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: context.l10n.storyShare,
              size: AppButtonSize.sm,
              onPressed: () {
                final text = controller.text.trim();
                Navigator.of(dialogContext).pop(text.isEmpty ? null : text);
              },
            ),
          ],
        ),
      ),
    ),
  );
}
