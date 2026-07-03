import 'package:flutter/material.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_dialog.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// The Follow / Following / Requested control (#010 FR-007). Follow is instant;
/// **Unfollow** and **withdraw-request** confirm first (guards accidental taps).
/// Presentational — the owning cubit performs the optimistic mutation.
class FollowButton extends StatelessWidget {
  const FollowButton({
    required this.relationship,
    required this.username,
    required this.onFollow,
    required this.onUnfollow,
    required this.onWithdraw,
    this.busy = false,
    this.fullWidth = false,
    super.key,
  });

  final ViewerRelationship relationship;
  final String username;
  final VoidCallback onFollow;
  final VoidCallback onUnfollow;
  final VoidCallback onWithdraw;
  final bool busy;
  final bool fullWidth;

  Future<void> _confirmUnfollow(BuildContext context) async {
    final l10n = context.l10n;
    final ok = await showAppDialog(
      context,
      title: l10n.unfollowConfirmTitle,
      body: l10n.unfollowConfirmBody(username),
      primaryLabel: l10n.unfollowConfirmAction,
      secondaryLabel: l10n.commonCancel,
      destructive: true,
    );
    if (ok) onUnfollow();
  }

  Future<void> _confirmWithdraw(BuildContext context) async {
    final l10n = context.l10n;
    final ok = await showAppDialog(
      context,
      title: l10n.withdrawConfirmTitle,
      body: l10n.withdrawConfirmBody(username),
      primaryLabel: l10n.withdrawConfirmAction,
      secondaryLabel: l10n.commonCancel,
    );
    if (ok) onWithdraw();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return switch (relationship.label) {
      FollowLabel.follow => AppButton(
        label: l10n.profileFollow,
        fullWidth: fullWidth,
        onPressed: busy ? null : onFollow,
      ),
      FollowLabel.following => AppButton(
        label: l10n.profileFollowing,
        kind: AppButtonKind.secondary,
        fullWidth: fullWidth,
        onPressed: busy ? null : () => _confirmUnfollow(context),
      ),
      FollowLabel.requested => AppButton(
        label: l10n.profileRequested,
        kind: AppButtonKind.secondary,
        fullWidth: fullWidth,
        onPressed: busy ? null : () => _confirmWithdraw(context),
      ),
    };
  }
}
