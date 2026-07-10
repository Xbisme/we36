import 'package:flutter/material.dart';
import 'package:we36/core/data/social/follow_request.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/core/utils/relative_time_formatter.dart';

/// One follow-request row (#014, US2): requester avatar + name/handle + relative
/// time, with Approve / Decline actions.
class RequestTile extends StatelessWidget {
  const RequestTile({
    required this.request,
    required this.onApprove,
    required this.onDecline,
    super.key,
  });

  final FollowRequest request;
  final VoidCallback onApprove;
  final VoidCallback onDecline;

  static const _time = RelativeTimeFormatter();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final u = request.requester;
    final name = u.displayName ?? u.username ?? '';
    final handle = u.username ?? u.id;

    return Semantics(
      label: '$name, @$handle',
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Avatar(
              size: 44,
              image: u.avatarUrl == null ? null : NetworkImage(u.avatarUrl!),
              semanticLabel: name,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.isEmpty ? '@$handle' : name,
                    style: AppTypography.label.copyWith(
                      color: tokens.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '@$handle · ${_time.format(request.requestedAt)}',
                    style: AppTypography.caption.copyWith(
                      color: tokens.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppButton(
              label: l10n.followRequestApprove,
              size: AppButtonSize.sm,
              onPressed: onApprove,
            ),
            const SizedBox(width: AppSpacing.xs),
            AppButton(
              label: l10n.followRequestDecline,
              kind: AppButtonKind.secondary,
              size: AppButtonSize.sm,
              onPressed: onDecline,
            ),
          ],
        ),
      ),
    );
  }
}
