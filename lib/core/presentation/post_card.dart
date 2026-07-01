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
    this.mediaCarousel,
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

  /// Ordered providers for a multi-photo post (#007). When it holds more than
  /// one item the media area becomes a swipeable carousel with a page indicator;
  /// otherwise [media] renders as a single frame (back-compatible with #004).
  final List<ImageProvider<Object>>? mediaCarousel;
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
          // Media 4:5 — carousel for multi-photo posts, else a single frame
          // (placeholder when no provider — offline feeds render empty surface).
          AspectRatio(
            aspectRatio: 4 / 5,
            child: (mediaCarousel != null && mediaCarousel!.length > 1)
                ? _MediaCarousel(pages: mediaCarousel!)
                : media == null
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

/// Swipeable ordered media carousel with a page-indicator (#007 multi-photo).
class _MediaCarousel extends StatefulWidget {
  const _MediaCarousel({required this.pages});

  final List<ImageProvider<Object>> pages;

  @override
  State<_MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<_MediaCarousel> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.pages.length,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (context, i) => Semantics(
            label: 'Photo ${i + 1} of ${widget.pages.length}',
            child: Image(image: widget.pages[i], fit: BoxFit.cover),
          ),
        ),
        Positioned(
          bottom: AppSpacing.sm,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < widget.pages.length; i++)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _index
                        ? tokens.accent
                        : tokens.textOnBrand.withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
