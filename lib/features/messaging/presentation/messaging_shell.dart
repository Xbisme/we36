import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/constants/app_breakpoints.dart';
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/messaging/presentation/chat_page.dart';
import 'package:we36/features/messaging/presentation/conversations_page.dart';
import 'package:we36/features/messaging/presentation/cubit/conversations_cubit.dart';
import 'package:we36/features/messaging/presentation/cubit/messaging_shell_cubit.dart';

/// The adaptive Messages surface (#012 US5). Phone (`<700`) → the conversation
/// list, tapping a row pushes the chat route (default `ConversationsPage`
/// behaviour). Tablet/iPad (`≥700`) → a **master/detail two-pane**: the list on
/// the left, the chat on the right; selecting a row swaps the detail pane in
/// place (no push) via [MessagingShellCubit]. Both bind the same
/// `ConversationsCubit`/`ChatCubit` (FR-022).
class MessagingShell extends StatelessWidget {
  const MessagingShell({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocProvider(
        create: (_) {
          final cubit = getIt<ConversationsCubit>();
          unawaited(cubit.loadInitial());
          return cubit;
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= AppBreakpoints.tablet;
            if (!isTablet) return const ConversationsPage();
            return BlocProvider(
              create: (_) => getIt<MessagingShellCubit>(),
              child: const _TwoPane(),
            );
          },
        ),
      ),
    );
  }
}

class _TwoPane extends StatelessWidget {
  const _TwoPane();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return BlocBuilder<MessagingShellCubit, Conversation?>(
      builder: (context, selected) {
        return Row(
          children: [
            SizedBox(
              width: 360,
              child: ConversationsPage(
                selectedId: selected?.id,
                onOpenConversation: (_, c) =>
                    context.read<MessagingShellCubit>().select(c),
              ),
            ),
            VerticalDivider(width: 1, color: tokens.divider),
            Expanded(
              child: selected == null
                  ? const _EmptyDetail()
                  : ChatPage(
                      key: ValueKey(selected.id),
                      conversationId: selected.id,
                      conversation: selected,
                      embedded: true,
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyDetail extends StatelessWidget {
  const _EmptyDetail();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Text(
        context.l10n.dmEmptyTitle,
        style: AppTypography.body16.copyWith(color: tokens.textTertiary),
      ),
    );
  }
}
