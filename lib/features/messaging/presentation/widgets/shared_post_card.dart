import 'package:flutter/material.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// A shared post/reel card bubble (#012 US3, Screen 26): a thumbnail + author,
/// tapping deep-links to the post (#006) / reel (#008). Renders a graceful
/// "unavailable" state when the referenced content was removed (FR-017).
class SharedPostCard extends StatelessWidget {
  const SharedPostCard({required this.ref, this.onTap, super.key});

  final PostRef ref;
  final VoidCallback? onTap;

  /// Corner radius of the shared-post card (Screen E2). No exact [AppRadius]
  /// token sits between `md` (12) and `lg` (20), so the design value is inline.
  static const double _cardRadius = 16;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final unavailable = ref.unavailable;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: unavailable ? null : onTap,
          child: Container(
            // ~64% of the thread width (Screen E2).
            width: constraints.maxWidth * 0.64,
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(_cardRadius),
              border: Border.all(color: tokens.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: unavailable
                      ? Container(
                          color: tokens.surfaceSunken,
                          alignment: Alignment.center,
                          child: Text(
                            l10n.dmSharedUnavailable,
                            textAlign: TextAlign.center,
                            style: AppTypography.caption.copyWith(
                              color: tokens.textTertiary,
                            ),
                          ),
                        )
                      : (ref.thumbUrl == null
                            ? Container(color: tokens.surfaceSunken)
                            : Image.network(
                                ref.thumbUrl!,
                                fit: BoxFit.cover,
                                cacheWidth: 440,
                              )),
                ),
                if (!unavailable)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.sm,
                    ),
                    // Author is bold; a post title would follow when present
                    // (PostRef currently carries only the author name).
                    child: Text(
                      ref.authorName ?? l10n.dmSharedPost,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        color: tokens.textPrimary,
                        fontWeight: FontWeight.w700,
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
}
