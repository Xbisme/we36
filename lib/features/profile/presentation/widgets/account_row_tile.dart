import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/data/profile/account_row.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/features/profile/presentation/widgets/follow_button.dart';

/// One followers/following list row (#010 US3): avatar + name/handle + a
/// read-write Follow control. Tapping the row opens that account's profile.
class AccountRowTile extends StatelessWidget {
  const AccountRowTile({
    required this.row,
    required this.onFollow,
    required this.onUnfollow,
    this.busy = false,
    super.key,
  });

  final AccountRow row;
  final VoidCallback onFollow;
  final VoidCallback onUnfollow;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final u = row.user;
    final username = u.username ?? '';
    return InkWell(
      onTap: () => unawaited(context.push(AppRoutes.userProfilePath(username))),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Avatar(
              size: 44,
              image: u.avatarUrl == null ? null : NetworkImage(u.avatarUrl!),
              semanticLabel: u.displayName,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '@$username',
                    style: AppTypography.label.copyWith(
                      color: tokens.textPrimary,
                    ),
                  ),
                  if (u.displayName != null)
                    Text(
                      u.displayName!,
                      style: AppTypography.caption.copyWith(
                        color: tokens.textTertiary,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            FollowButton(
              relationship: row.relationship,
              username: username,
              busy: busy,
              onFollow: onFollow,
              onUnfollow: onUnfollow,
              onWithdraw: onUnfollow,
            ),
          ],
        ),
      ),
    );
  }
}
