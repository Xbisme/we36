import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:we36/core/data/notifications/notification_entry.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/core/utils/relative_time_formatter.dart';

/// One Activity row (#013 US1, Screen 29): actor avatar(s) + a "<b>name</b>
/// action" summary + relative time, with a trailing target thumbnail or an
/// inline action ([trailing], e.g. the follow-back button in US5). Unread rows
/// carry a soft accent; a deleted-target row renders degraded + non-tappable
/// (FR-006). Avatars fall back to an initial when absent (FR-003).
class NotificationTile extends StatelessWidget {
  const NotificationTile({
    required this.entry,
    required this.onTap,
    this.trailing,
    super.key,
  });

  final NotificationEntry entry;

  /// Tapped → deep-link to the target (no-op / disabled when degraded).
  final VoidCallback onTap;

  /// Optional inline action (follow-back in US5); overrides the thumbnail.
  final Widget? trailing;

  static const _time = RelativeTimeFormatter();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final actor = entry.leadActor;
    final name = actor?.displayName ?? actor?.username ?? '';
    final degraded = entry.isDegraded;

    final row = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Avatar(
            size: 48,
            image: actor?.avatarUrl == null
                ? null
                : NetworkImage(actor!.avatarUrl!),
            initials: name.isEmpty ? null : name.characters.first.toUpperCase(),
            semanticLabel: name,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: RichText(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: AppTypography.body16.copyWith(color: tokens.textPrimary),
                children: [
                  if (name.isNotEmpty)
                    TextSpan(
                      text: name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  if (entry.andOthersCount > 0)
                    TextSpan(
                      text:
                          ' ${l10n.notifAndOthers('${entry.andOthersCount}')}',
                    ),
                  TextSpan(text: ' ${_summary(l10n)} '),
                  TextSpan(
                    text: _time.format(entry.updatedAt),
                    style: AppTypography.caption.copyWith(
                      color: tokens.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          trailing ?? _defaultTrailing(context),
        ],
      ),
    );

    return Semantics(
      button: !degraded,
      container: true,
      label: '$name ${_summary(l10n)}${entry.isRead ? '' : ', new'}',
      child: Material(
        color: entry.isRead ? Colors.transparent : tokens.accentSoft,
        child: InkWell(onTap: degraded ? null : onTap, child: row),
      ),
    );
  }

  Widget _defaultTrailing(BuildContext context) {
    final thumb = entry.target?.thumbnailUrl;
    if (thumb == null || thumb.isEmpty) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: CachedNetworkImage(
        imageUrl: thumb,
        width: 44,
        height: 44,
        fit: BoxFit.cover,
        memCacheWidth: 132,
        errorWidget: (_, _, _) => const SizedBox(width: 44, height: 44),
      ),
    );
  }

  String _summary(AppLocalizations l10n) => switch (entry.type) {
    NotificationType.like => l10n.notifActionLike,
    NotificationType.comment => l10n.notifActionComment,
    NotificationType.reply => l10n.notifActionReply,
    NotificationType.mention => l10n.notifActionMention,
    NotificationType.follow => l10n.notifActionFollow,
    NotificationType.followRequest => l10n.notifActionFollowRequest,
    NotificationType.followAccepted => l10n.notifActionFollowAccepted,
    NotificationType.unknown => l10n.notifActionGeneric,
  };
}
