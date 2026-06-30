import 'package:flutter/material.dart';
import 'package:we36/core/mock/mock_data.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/presentation/pane_header.dart';
import 'package:we36/core/router/two_pane_scaffold.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// Messages placeholder — adopts the shared TwoPaneScaffold: on tablet the
/// conversation list + chat sit side-by-side (select swaps in place); on phone
/// selecting pushes the chat (FR-014).
class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TwoPaneScaffold<MockConversation>(
      items: MockData.conversations,
      detailTitle: (c) => c.peer.displayName,
      emptyDetail: _EmptyDetail(),
      listBuilder: (context, onSelect, selected) {
        final tokens = context.tokens;
        return Column(
          children: [
            const PaneHeader(title: 'Messages'),
            Expanded(
              child: ListView(
                children: [
                  for (final c in MockData.conversations)
                    Material(
                      color: c == selected ? tokens.accentSoft : null,
                      child: ListTile(
                        onTap: () => onSelect(c),
                        leading: Avatar(
                          size: 48,
                          online: c.peer.isOnline,
                          semanticLabel: c.peer.displayName,
                        ),
                        title: Text(
                          c.peer.displayName,
                          style: AppTypography.label.copyWith(
                            color: tokens.textPrimary,
                            fontWeight: c.unread
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          c.preview,
                          style: AppTypography.caption.copyWith(
                            color: c.typing
                                ? tokens.success
                                : tokens.textSecondary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
      detailBuilder: (context, c) => _ChatPane(conversation: c),
    );
  }
}

class _ChatPane extends StatelessWidget {
  const _ChatPane({required this.conversation});

  final MockConversation conversation;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Column(
      children: [
        PaneHeader(title: conversation.peer.displayName),
        Expanded(
          child: Center(
            child: Text(
              conversation.preview,
              style: AppTypography.body16.copyWith(color: tokens.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Text(
        context.l10n.selectAnItem,
        style: AppTypography.body16.copyWith(color: tokens.textTertiary),
      ),
    );
  }
}
