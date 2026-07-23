import 'package:flutter/material.dart';
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/core/utils/relative_time_formatter.dart';

/// One conversation row on the Messages list (#012 US1, Screen 25): avatar +
/// online dot, name (bold when unread), last-message preview — replaced by a
/// live "typing…" cue in mint — a relative timestamp, and an unread dot.
class ConversationTile extends StatelessWidget {
  const ConversationTile({
    required this.conversation,
    required this.onTap,
    this.selected = false,
    super.key,
  });

  final Conversation conversation;
  final VoidCallback onTap;
  final bool selected;

  static const _time = RelativeTimeFormatter();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final c = conversation;
    final name = c.participant.displayName ?? c.participant.username ?? '';
    final unread = c.hasUnread;
    final avatarUrl = c.participant.avatarUrl;
    final previewBody = c.isTyping
        ? l10n.dmTyping
        : (c.lastMessagePreview ?? '');
    // Time is inline in the preview line: "{msg} · {time}".
    final preview = '$previewBody · ${_time.format(c.lastActivityAt)}';

    return Semantics(
      button: true,
      container: true,
      excludeSemantics: true,
      label: unread ? '$name, ${c.unreadCount} unread' : name,
      child: Material(
        color: selected ? tokens.accentSoft : Colors.transparent,
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
                  size: 52,
                  online: c.participantOnline,
                  image: avatarUrl == null ? null : NetworkImage(avatarUrl),
                  initials: name.isEmpty
                      ? null
                      : name.characters.first.toUpperCase(),
                  semanticLabel: name,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.label.copyWith(
                          color: tokens.textPrimary,
                          fontWeight: unread
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          color: c.isTyping
                              ? tokens.statusActive
                              : unread
                              ? tokens.textPrimary
                              : tokens.textSecondary,
                          fontWeight: unread
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Trailing: a small rose unread dot, else a camera affordance.
                if (unread)
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: tokens.accent,
                      shape: BoxShape.circle,
                    ),
                  )
                else
                  AppIcon(AppIcons.camera, size: 22, color: tokens.icon),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
