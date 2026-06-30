import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_icon_button.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/theme/app_colors.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';

/// The feed's primary surface: header, 4:5 media, action row, likes, caption,
/// "view all N comments", time. Pure presentation — callbacks out, no logic.
/// Constitution VI. (#001 feeds [media] a fake/asset provider — no network.)
class PostCard extends StatelessWidget {
  const PostCard({
    required this.username,
    required this.likesText,
    required this.caption,
    required this.timeText,
    this.media,
    this.avatar,
    this.location,
    this.commentsText,
    this.liked = false,
    this.saved = false,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onSave,
    this.onMore,
    super.key,
  });

  final String username;
  final ImageProvider<Object>? avatar;
  final ImageProvider<Object>? media;
  final String likesText;
  final String caption;
  final String timeText;
  final String? location;
  final String? commentsText;
  final bool liked;
  final bool saved;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onSave;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: tokens.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Avatar(size: 36, image: avatar, semanticLabel: username),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: AppTypography.label.copyWith(
                          color: tokens.textPrimary,
                        ),
                      ),
                      if (location != null)
                        Text(
                          location!,
                          style: AppTypography.caption.copyWith(
                            color: tokens.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                AppIconButton(
                  icon: AppIcons.more,
                  semanticLabel: 'More options',
                  onPressed: onMore,
                ),
              ],
            ),
          ),
          // Media 4:5 (placeholder when no provider — #001 is offline)
          AspectRatio(
            aspectRatio: 4 / 5,
            child: media == null
                ? ColoredBox(color: tokens.surface2)
                : Image(image: media!, fit: BoxFit.cover),
          ),
          // Action row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Row(
              children: [
                AppIconButton(
                  icon: AppIcons.like,
                  semanticLabel: 'Like',
                  active: liked,
                  color: liked ? AppColors.rose500 : null,
                  onPressed: onLike,
                ),
                AppIconButton(
                  icon: AppIcons.comment,
                  semanticLabel: 'Comment',
                  onPressed: onComment,
                ),
                AppIconButton(
                  icon: AppIcons.share,
                  semanticLabel: 'Share',
                  onPressed: onShare,
                ),
                const Spacer(),
                AppIconButton(
                  icon: AppIcons.save,
                  semanticLabel: 'Save',
                  active: saved,
                  onPressed: onSave,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  likesText,
                  style: AppTypography.stat.copyWith(
                    color: tokens.textPrimary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: AppTypography.body16.copyWith(
                      color: tokens.textPrimary,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: '$username ',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: caption),
                    ],
                  ),
                ),
                if (commentsText != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    commentsText!,
                    style: AppTypography.caption.copyWith(
                      color: tokens.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  timeText,
                  style: AppTypography.caption.copyWith(
                    color: tokens.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
