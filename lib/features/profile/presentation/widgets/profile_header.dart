import 'package:flutter/material.dart';
import 'package:we36/core/constants/app_breakpoints.dart';
import 'package:we36/core/data/profile/profile_view.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/theme/app_colors.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/features/profile/presentation/widgets/profile_stats.dart';

/// The profile header (#010 Screens 20/21; FR-001/006/028): avatar ring + stats,
/// display name (+ verified), @handle, bio, website link, and an [actions] slot
/// (Edit/Share for my profile; Follow/Message for others). Adapts the avatar size
/// between phone and tablet width.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.view,
    required this.actions,
    this.website,
    this.onTapFollowers,
    this.onTapFollowing,
    super.key,
  });

  final ProfileView view;
  final Widget actions;
  final String? website;
  final VoidCallback? onTapFollowers;
  final VoidCallback? onTapFollowing;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final user = view.user;
    final wide = MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet;
    final avatarSize = wide ? 120.0 : 88.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Avatar(
              size: avatarSize,
              image: user.avatarUrl == null
                  ? null
                  : NetworkImage(user.avatarUrl!),
              semanticLabel: user.displayName,
            ),
            const SizedBox(width: AppSpacing.xl),
            Expanded(
              child: ProfileStats(
                postsCount: user.postsCount,
                followersCount: user.followersCount,
                followingCount: user.followingCount,
                onTapFollowers: onTapFollowers,
                onTapFollowing: onTapFollowing,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Flexible(
              child: Text(
                user.displayName,
                style: AppTypography.h3.copyWith(color: tokens.textPrimary),
              ),
            ),
            if (user.isVerified) ...[
              const SizedBox(width: 4),
              AppIcon(AppIcons.check, size: 16, color: tokens.accent),
            ],
          ],
        ),
        Text(
          '@${user.username}',
          style: AppTypography.caption.copyWith(color: tokens.textTertiary),
        ),
        if (user.bio != null && user.bio!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            user.bio!,
            style: AppTypography.body16.copyWith(color: tokens.textSecondary),
          ),
        ],
        if (website != null && website!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            website!,
            style: AppTypography.body16.copyWith(color: AppColors.violet500),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        actions,
      ],
    );
  }
}
