import 'package:flutter/material.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/count_formatter.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// The posts / followers / following counts (#010 FR-001/029). Counts are
/// abbreviated (12.3k / 1.2M) and the followers/following entries are tappable
/// (→ the connections list) unless the profile is gated.
class ProfileStats extends StatelessWidget {
  const ProfileStats({
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    this.onTapFollowers,
    this.onTapFollowing,
    super.key,
  });

  final int postsCount;
  final int followersCount;
  final int followingCount;
  final VoidCallback? onTapFollowers;
  final VoidCallback? onTapFollowing;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final counts = CountFormatter(Localizations.localeOf(context).toString());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          child: _Stat(value: counts.format(postsCount), label: l10n.statPosts),
        ),
        Flexible(
          child: _Stat(
            value: counts.format(followersCount),
            label: l10n.statFollowers,
            onTap: onTapFollowers,
          ),
        ),
        Flexible(
          child: _Stat(
            value: counts.format(followingCount),
            label: l10n.statFollowing,
            onTap: onTapFollowing,
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.onTap});

  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Semantics(
      button: onTap != null,
      label: '$value $label',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                // Design D1/D2: stat value = display face, 18/w700.
                style: AppTypography.stat.copyWith(
                  fontSize: 18,
                  color: tokens.textPrimary,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                // Design: 12px label in textSecondary.
                style: AppTypography.caption.copyWith(
                  fontSize: 12,
                  color: tokens.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
