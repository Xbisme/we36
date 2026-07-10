import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/presentation/block_report_actions.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/messaging/presentation/cubit/chat_cubit.dart';
import 'package:we36/features/messaging/presentation/cubit/chat_state.dart';
import 'package:we36/features/messaging/presentation/widgets/chat_composer.dart';
import 'package:we36/features/messaging/presentation/widgets/chat_photo_picker.dart';
import 'package:we36/features/messaging/presentation/widgets/connection_banner.dart';
import 'package:we36/features/messaging/presentation/widgets/message_bubble.dart';
import 'package:we36/features/messaging/presentation/widgets/typing_indicator.dart';

/// One conversation's chat (#012 US2, Screen 26). Provides the [ChatCubit] and
/// renders the grouped thread + typing indicator + composer. On phone this is a
/// nav-less pushed route; the tablet two-pane (US5) renders the same body inline.
class ChatPage extends StatelessWidget {
  const ChatPage({
    required this.conversationId,
    this.conversation,
    this.embedded = false,
    super.key,
  });

  final String conversationId;
  final Conversation? conversation;

  /// When true (tablet two-pane), the page renders without its own Scaffold/AppBar
  /// scaffolding differences — the pane provides the frame.
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final peerId = conversation?.participant.id ?? '';
    return BlocProvider(
      create: (_) {
        final cubit = getIt<ChatCubit>();
        unawaited(cubit.loadInitial(conversationId, peerId: peerId));
        return cubit;
      },
      child: _ChatView(conversation: conversation, embedded: embedded),
    );
  }
}

class _ChatView extends StatelessWidget {
  const _ChatView({required this.conversation, required this.embedded});

  final Conversation? conversation;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final body = Column(
          children: [
            _ChatHeader(conversation: conversation, state: state),
            const ConnectionBanner(),
            Expanded(child: _ThreadOrState(state: state)),
            ChatComposer(
              onSendText: (t) => context.read<ChatCubit>().sendText(t),
              onTyping: (a) => context.read<ChatCubit>().onTyping(active: a),
              onSendSticker: (glyph) =>
                  context.read<ChatCubit>().sendSticker(glyph),
              onPickPhoto: () {
                final cubit = context.read<ChatCubit>();
                unawaited(
                  pickAndSendChatPhoto(
                    context,
                    onUploaded: cubit.sendPhoto,
                  ),
                );
              },
            ),
          ],
        );
        return embedded ? body : Scaffold(body: SafeArea(child: body));
      },
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.conversation, required this.state});

  final Conversation? conversation;
  final ChatState state;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final peer = conversation?.participant;
    final name = peer?.displayName ?? peer?.username ?? '';
    final online = state is ChatLoaded && (state as ChatLoaded).peerOnline;
    final avatarUrl = peer?.avatarUrl;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: tokens.divider)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: AppIcon(AppIcons.back, color: tokens.textPrimary),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          ),
          Avatar(
            size: 36,
            online: online,
            image: avatarUrl == null ? null : NetworkImage(avatarUrl),
            semanticLabel: name,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.label.copyWith(
                    color: tokens.textPrimary,
                  ),
                ),
                if (online)
                  Text(
                    l10n.dmActiveNow,
                    style: AppTypography.caption.copyWith(
                      color: tokens.success,
                    ),
                  ),
              ],
            ),
          ),
          if (peer != null)
            IconButton(
              onPressed: () => unawaited(
                showBlockReportActions(
                  context,
                  userId: peer.id,
                  username: peer.username ?? peer.id,
                ),
              ),
              icon: AppIcon(AppIcons.more, color: tokens.textPrimary),
              tooltip: l10n.reportTitle,
            ),
        ],
      ),
    );
  }
}

class _ThreadOrState extends StatelessWidget {
  const _ThreadOrState({required this.state});

  final ChatState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    return switch (state) {
      ChatInitial() || ChatLoading() => const Center(
        child: CircularProgressIndicator(),
      ),
      ChatError() => Center(
        child: Text(
          l10n.dmThreadError,
          style: AppTypography.body16.copyWith(color: tokens.textSecondary),
        ),
      ),
      ChatLoaded(:final messages, :final peerTyping) => _Thread(
        messages: messages,
        peerTyping: peerTyping,
      ),
    };
  }
}

class _Thread extends StatelessWidget {
  const _Thread({required this.messages, required this.peerTyping});

  final List<Message> messages;
  final bool peerTyping;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty && !peerTyping) {
      return Center(
        child: Text(
          context.l10n.dmThreadEmpty,
          style: AppTypography.body16.copyWith(
            color: context.tokens.textTertiary,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: messages.length + (peerTyping ? 1 : 0),
      itemBuilder: (context, i) {
        if (i == messages.length) return const TypingIndicator();
        final m = messages[i];
        return MessageBubble(
          message: m,
          onRetry: () => context.read<ChatCubit>().retry(m.clientKey),
          onOpenShared: (ref) => unawaited(
            context.push(AppRoutes.postDetailPath(ref.id)),
          ),
        );
      },
    );
  }
}
