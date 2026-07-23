import 'package:flutter/material.dart';
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// The horizontal "active now" rail atop the Messages list (#012 US1) — leads
/// with the current user's create-story tile, then online contacts as tappable
/// avatars with a presence dot, closed by a bottom divider (Screen E1).
class ActiveNowRail extends StatelessWidget {
  const ActiveNowRail({
    required this.conversations,
    required this.onTap,
    super.key,
  });

  final List<Conversation> conversations;
  final void Function(Conversation) onTap;

  static const double _avatarSize = 52;

  @override
  Widget build(BuildContext context) {
    if (conversations.isEmpty) return const SizedBox.shrink();
    final tokens = context.tokens;
    final l10n = context.l10n;
    // Scale-aware height so the compact strip does not overflow at large text
    // sizes (avatar + gap + one label line + vertical padding).
    final height = 72 + MediaQuery.textScalerOf(context).scale(24);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: tokens.divider)),
      ),
      child: SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          // +1 for the leading "you" / create-story tile.
          itemCount: conversations.length + 1,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.lg),
          itemBuilder: (context, i) {
            if (i == 0) {
              return _RailTile(
                label: l10n.yourStory,
                semanticLabel: l10n.yourStory,
                child: Avatar(
                  size: _avatarSize,
                  showCreateBadge: true,
                  semanticLabel: l10n.yourStory,
                ),
              );
            }
            final c = conversations[i - 1];
            final name =
                c.participant.displayName ?? c.participant.username ?? '';
            final avatarUrl = c.participant.avatarUrl;
            return _RailTile(
              label: name,
              semanticLabel: '$name, active now',
              onTap: () => onTap(c),
              child: Avatar(
                size: _avatarSize,
                online: true,
                image: avatarUrl == null ? null : NetworkImage(avatarUrl),
                semanticLabel: name,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RailTile extends StatelessWidget {
  const _RailTile({
    required this.label,
    required this.semanticLabel,
    required this.child,
    this.onTap,
  });

  final String label;
  final String semanticLabel;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            const SizedBox(height: 4),
            SizedBox(
              width: 60,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(
                  color: tokens.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
