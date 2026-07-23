import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/messaging/message.dart' show PostRef;
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_icon_button.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/messaging/presentation/cubit/new_message_cubit.dart';
import 'package:we36/features/messaging/presentation/cubit/new_message_state.dart';

/// The new-message composer (#012 US4, Screen 27): a "To:" people search over
/// follows/recents; selecting a person opens the existing conversation or starts
/// a new one (no duplicate, SC-007).
class NewMessagePage extends StatelessWidget {
  const NewMessagePage({this.pendingShare, super.key});

  /// When set (share-to-DM), the post is filed into the conversation on select.
  final PostRef? pendingShare;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<NewMessageCubit>();
        unawaited(cubit.load());
        return cubit;
      },
      child: _NewMessageView(pendingShare: pendingShare),
    );
  }
}

class _NewMessageView extends StatelessWidget {
  const _NewMessageView({this.pendingShare});

  final PostRef? pendingShare;

  Future<void> _select(BuildContext context, UserSummary user) async {
    final cubit = context.read<NewMessageCubit>();
    final res = await cubit.openConversation(
      user.id,
      pendingShare: pendingShare,
    );
    final convo = res.valueOrNull;
    if (convo == null || !context.mounted) return;
    // Replace the compose route with the opened thread.
    context.pushReplacement(
      AppRoutes.messageThreadPath(convo.id),
      extra: convo,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header: close + title, closed by a bottom divider.
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: tokens.divider)),
              ),
              child: SizedBox(
                height: 52,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      AppIconButton(
                        icon: AppIcons.close,
                        semanticLabel: MaterialLocalizations.of(
                          context,
                        ).closeButtonTooltip,
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          l10n.dmNewMessage,
                          style: AppTypography.h3.copyWith(
                            color: tokens.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
            ),
            // Flat inline "To:" recipient field with a bottom divider.
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: tokens.divider)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  children: [
                    Text(
                      l10n.dmTo,
                      style: AppTypography.label.copyWith(
                        color: tokens.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        onChanged: (q) =>
                            context.read<NewMessageCubit>().search(q),
                        style: AppTypography.label.copyWith(
                          color: tokens.textPrimary,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: l10n.dmSearchConversations,
                          hintStyle: AppTypography.label.copyWith(
                            color: tokens.textTertiary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.xs,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.dmSuggested.toUpperCase(),
                  style: AppTypography.caption.copyWith(
                    color: tokens.textSecondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 13 * 0.03,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<NewMessageCubit, NewMessageState>(
                builder: (context, state) {
                  return switch (state) {
                    NewMessageInitial() || NewMessageLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    NewMessageError() => Center(
                      child: Text(
                        l10n.dmSearchEmpty,
                        style: AppTypography.body16.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                    ),
                    NewMessageLoaded(:final people) =>
                      people.isEmpty
                          ? Center(
                              child: Text(
                                l10n.dmSearchEmpty,
                                style: AppTypography.body16.copyWith(
                                  color: tokens.textSecondary,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: people.length,
                              itemBuilder: (context, i) {
                                final u = people[i];
                                return _PersonRow(
                                  user: u,
                                  onTap: () => _select(context, u),
                                );
                              },
                            ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonRow extends StatelessWidget {
  const _PersonRow({required this.user, required this.onTap});

  final UserSummary user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final name = user.displayName ?? user.username ?? '';
    final avatarUrl = user.avatarUrl;
    return Semantics(
      button: true,
      label: name,
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
                size: 48,
                image: avatarUrl == null ? null : NetworkImage(avatarUrl),
                semanticLabel: name,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.label.copyWith(
                        color: tokens.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (user.username != null)
                      Text(
                        user.username!,
                        style: AppTypography.caption.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Empty selector circle (unselected recipient).
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: tokens.borderStrong, width: 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
