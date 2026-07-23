import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_icon_button.dart';
import 'package:we36/core/presentation/app_search_bar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/messaging/presentation/cubit/conversations_cubit.dart';
import 'package:we36/features/messaging/presentation/cubit/conversations_state.dart';
import 'package:we36/features/messaging/presentation/widgets/active_now_rail.dart';
import 'package:we36/features/messaging/presentation/widgets/conversation_tile.dart';

/// The Messages tab body (#012 US1, Screen 25) — the conversation list with an
/// active-now rail, in-list search, a `+` new-message entry, and the empty /
/// offline / error states. [onOpenConversation] lets the tablet two-pane (US5)
/// swap the detail pane in place; the phone default pushes the chat route.
class ConversationsPage extends StatelessWidget {
  const ConversationsPage({
    this.onOpenConversation,
    this.selectedId,
    super.key,
  });

  /// How to open a conversation. Defaults to a phone push of the chat route.
  final void Function(BuildContext, Conversation)? onOpenConversation;

  /// The conversation currently shown in the tablet detail pane (highlight).
  final String? selectedId;

  void _open(BuildContext context, Conversation c) {
    if (onOpenConversation != null) {
      onOpenConversation!(context, c);
    } else {
      unawaited(
        context.push(AppRoutes.messageThreadPath(c.id), extra: c),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;

    return Column(
      children: [
        // Header: back-to-home chevron + username title + new-message action.
        SizedBox(
          height: 52,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                AppIconButton(
                  icon: AppIcons.back,
                  semanticLabel: MaterialLocalizations.of(
                    context,
                  ).backButtonTooltip,
                  onPressed: () => context.go(AppRoutes.home),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    l10n.dmTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.h3.copyWith(
                      color: tokens.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                AppIconButton(
                  icon: AppIcons.plus,
                  semanticLabel: l10n.dmNewMessage,
                  onPressed: () =>
                      unawaited(context.push(AppRoutes.newMessage)),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<ConversationsCubit, ConversationsState>(
            builder: (context, state) {
              return switch (state) {
                ConversationsInitial() ||
                ConversationsLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                ConversationsError() => _ErrorState(
                  onRetry: () =>
                      unawaited(context.read<ConversationsCubit>().retry()),
                ),
                ConversationsLoaded(:final conversations, :final isOffline) =>
                  _LoadedList(
                    conversations: conversations,
                    isOffline: isOffline,
                    selectedId: selectedId,
                    onSearch: (q) =>
                        context.read<ConversationsCubit>().search(q),
                    onOpen: (c) => _open(context, c),
                  ),
              };
            },
          ),
        ),
      ],
    );
  }
}

class _LoadedList extends StatelessWidget {
  const _LoadedList({
    required this.conversations,
    required this.isOffline,
    required this.selectedId,
    required this.onSearch,
    required this.onOpen,
  });

  final List<Conversation> conversations;
  final bool isOffline;
  final String? selectedId;
  final ValueChanged<String> onSearch;
  final void Function(Conversation) onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    final online = conversations.where((c) => c.participantOnline).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              0,
            ),
            child: AppSearchBar(
              hint: l10n.dmSearchConversations,
              onChanged: onSearch,
            ),
          ),
        ),
        if (isOffline)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xs,
              ),
              child: Text(
                l10n.dmOffline,
                style: AppTypography.caption.copyWith(
                  color: tokens.textTertiary,
                ),
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: ActiveNowRail(conversations: online, onTap: onOpen),
        ),
        if (conversations.isEmpty)
          const SliverFillRemaining(hasScrollBody: false, child: _EmptyState())
        else
          SliverList.builder(
            itemCount: conversations.length,
            itemBuilder: (context, i) {
              final c = conversations[i];
              return ConversationTile(
                conversation: c,
                selected: c.id == selectedId,
                onTap: () => onOpen(c),
              );
            },
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.dmEmptyTitle,
              style: AppTypography.h3.copyWith(color: tokens.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.dmEmptyBody,
              style: AppTypography.body16.copyWith(color: tokens.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.dmError,
            style: AppTypography.body16.copyWith(color: tokens.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onRetry, child: Text(l10n.dmRetry)),
        ],
      ),
    );
  }
}
