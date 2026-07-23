import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:we36/core/data/comments/comment.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/count_formatter.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/core/utils/relative_time_formatter.dart';
import 'package:we36/features/post/presentation/widgets/comment_text.dart';

/// One comment row (Screen 15): avatar + name + text + time, a like glyph with
/// its count, and Reply / more actions. Replies render indented one level
/// (40px, avatar 28). Pending optimistic entries render muted with no like
/// control (Constitution III/VI).
class CommentTile extends StatelessWidget {
  const CommentTile({
    required this.comment,
    this.onLike,
    this.onReply,
    this.onMore,
    super.key,
  });

  final Comment comment;
  final VoidCallback? onLike;
  final VoidCallback? onReply;
  final VoidCallback? onMore;

  ImageProvider<Object>? _avatar(String? url) {
    if (url == null || !url.startsWith('http')) return null;
    return ResizeImage(CachedNetworkImageProvider(url), width: 96);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final counts = CountFormatter(locale);
    final time = RelativeTimeFormatter(
      labels: locale == 'vi'
          ? const RelativeTimeLabels.vi()
          : const RelativeTimeLabels.en(),
    );
    final isReply = comment.isReply;
    final name = comment.author.username ?? comment.author.displayName ?? '';

    return Opacity(
      opacity: comment.pending ? 0.5 : 1,
      child: Padding(
        padding: EdgeInsets.only(
          left: isReply ? 40 + AppSpacing.lg : AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.sm,
          bottom: AppSpacing.sm,
        ),
        child: Semantics(
          label: '$name: ${comment.text}',
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Avatar(
                size: isReply ? 28 : 34,
                image: _avatar(comment.author.avatarUrl),
                initials: name.isEmpty
                    ? null
                    : name.characters.first.toUpperCase(),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name row only — time moves into the meta row (design B7).
                    Text(
                      name,
                      style: AppTypography.label.copyWith(
                        color: tokens.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    CommentText(comment.text),
                    const SizedBox(height: AppSpacing.xs),
                    // Meta row: `time · N likes · Reply` (gap 16, 12/600, tertiary).
                    _MetaRow(
                      time: time.format(comment.createdAt, now: DateTime.now()),
                      likes: comment.likeCount > 0
                          ? l10n.feedLikesCount(
                              counts.format(comment.likeCount),
                            )
                          : null,
                      replyLabel: comment.pending ? null : l10n.commentReply,
                      onReply: onReply,
                    ),
                  ],
                ),
              ),
              if (!comment.pending) ...[
                _LikeButton(
                  liked: comment.viewerHasLiked,
                  onTap: onLike,
                  label: name,
                ),
                IconButton(
                  onPressed: onMore,
                  icon: const AppIcon(AppIcons.more, size: 18),
                  visualDensity: VisualDensity.compact,
                  tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The single meta row under a comment: `time · N likes · Reply` (design B7 —
/// gap 16, 12px / weight 600, tertiary). Segments render only when present.
class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.time,
    required this.likes,
    required this.replyLabel,
    this.onReply,
  });

  final String time;
  final String? likes;
  final String? replyLabel;
  final VoidCallback? onReply;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final style = AppTypography.caption.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: tokens.textTertiary,
    );
    // Wrap (not Row) so the segments reflow instead of overflowing on an
    // indented reply at large text scales.
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.xs,
      children: [
        Text(time, style: style),
        if (likes != null) Text(likes!, style: style),
        if (replyLabel != null)
          GestureDetector(
            onTap: onReply,
            child: Text(replyLabel!, style: style),
          ),
      ],
    );
  }
}

class _LikeButton extends StatelessWidget {
  const _LikeButton({required this.liked, required this.label, this.onTap});

  final bool liked;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Semantics(
      button: true,
      label: liked ? 'Unlike $label' : 'Like $label',
      child: IconButton(
        onPressed: onTap,
        visualDensity: VisualDensity.compact,
        icon: AppIcon(
          AppIcons.like,
          size: 15,
          active: liked,
          color: liked ? tokens.accent : null,
        ),
      ),
    );
  }
}
