import 'package:flutter/material.dart';
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';

/// The horizontal "active now" rail atop the Messages list (#012 US1) — online
/// contacts as tappable avatars with an online dot. Hidden when nobody is online.
class ActiveNowRail extends StatelessWidget {
  const ActiveNowRail({
    required this.conversations,
    required this.onTap,
    super.key,
  });

  final List<Conversation> conversations;
  final void Function(Conversation) onTap;

  @override
  Widget build(BuildContext context) {
    if (conversations.isEmpty) return const SizedBox.shrink();
    final tokens = context.tokens;
    // Scale-aware height so the compact strip does not overflow at large text
    // sizes (avatar + gap + one label line + vertical padding).
    final height = 76 + MediaQuery.textScalerOf(context).scale(24);
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        itemCount: conversations.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, i) {
          final c = conversations[i];
          final name =
              c.participant.displayName ?? c.participant.username ?? '';
          final avatarUrl = c.participant.avatarUrl;
          return Semantics(
            button: true,
            label: '$name, active now',
            child: GestureDetector(
              onTap: () => onTap(c),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Avatar(
                    size: 56,
                    online: true,
                    image: avatarUrl == null ? null : NetworkImage(avatarUrl),
                    semanticLabel: name,
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 60,
                    child: Text(
                      name,
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
        },
      ),
    );
  }
}
