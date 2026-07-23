import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// One account search/recent result row (#009 US1, Screen 18): avatar (ringed
/// for the lead result) + handle + display name + a Follow/Requested/Following
/// pill button. The follow action is wired in #010 (FR-006); the button renders
/// live now. Tapping the row opens the profile.
class AccountResultRow extends StatelessWidget {
  const AccountResultRow({
    required this.result,
    required this.onTap,
    this.first = false,
    this.onFollowToggle,
    super.key,
  });

  final AccountResult result;
  final VoidCallback onTap;

  /// The lead result carries an unseen-style avatar ring (explore.jsx C3).
  final bool first;

  /// Follow/unfollow handler. Wired in #010; until then the pill still renders
  /// as an enabled button.
  final VoidCallback? onFollowToggle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final user = result.user;
    final following = result.relationship.following;
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
                size: 48,
                ring: first ? AvatarRing.unseen : AvatarRing.none,
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
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
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
                          color: tokens.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 92),
                child: AppButton(
                  label: label,
                  kind: following
                      ? AppButtonKind.secondary
                      : AppButtonKind.primary,
                  size: AppButtonSize.sm,
                  onPressed: onFollowToggle ?? () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
