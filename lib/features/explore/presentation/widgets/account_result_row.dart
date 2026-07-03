import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// One account search/recent result row (#009 US1, Screen 18): avatar + handle +
/// display name + a **read-only** Follow/Requested/Following label (the actual
/// follow action lands in #010, FR-006). Tapping the row opens the profile.
class AccountResultRow extends StatelessWidget {
  const AccountResultRow({
    required this.result,
    required this.onTap,
    super.key,
  });

  final AccountResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final user = result.user;
    final label = switch (result.relationship.label) {
      FollowLabel.following => l10n.following,
      FollowLabel.requested => l10n.requested,
      FollowLabel.follow => l10n.follow,
    };
    return Semantics(
      button: true,
      label: '@${user.username ?? ''}, ${user.displayName ?? ''}, $label',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Avatar(
                size: 44,
                image: user.avatarUrl == null
                    ? null
                    : CachedNetworkImageProvider(user.avatarUrl!),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.username ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.label.copyWith(
                              color: tokens.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (user.isVerified) ...[
                          const SizedBox(width: 4),
                          AppIcon(
                            AppIcons.check,
                            size: 14,
                            color: tokens.accent,
                          ),
                        ],
                      ],
                    ),
                    if (user.displayName != null)
                      Text(
                        user.displayName!,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          color: tokens.textTertiary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: result.relationship.following
                      ? tokens.textSecondary
                      : tokens.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
