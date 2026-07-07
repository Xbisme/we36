import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/action_sheet.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_icon_button.dart';
import 'package:we36/core/presentation/max_width_box.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:we36/features/profile/presentation/cubit/profile_state.dart';
import 'package:we36/features/profile/presentation/widgets/follow_button.dart';
import 'package:we36/features/profile/presentation/widgets/private_gate.dart';
import 'package:we36/features/profile/presentation/widgets/profile_grid.dart';
import 'package:we36/features/profile/presentation/widgets/profile_header.dart';

/// Another person's profile (#010 Screen 21): header + stats + bio, optimistic
/// Follow/Message, and their Posts grid (or a private gate).
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({required this.username, super.key});

  final String username;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 400) {
      unawaited(context.read<ProfileCubit>().loadMore());
    }
  }

  void _openItem(ExploreItem item) {
    if (item.isReel) {
      context.go(AppRoutes.reels);
    } else {
      unawaited(context.push(AppRoutes.postDetailPath(item.id)));
    }
  }

  Future<void> _follow() async {
    final ok = await context.read<ProfileCubit>().follow();
    if (!ok && mounted) {
      getIt<ToastService>().show(context, message: context.l10n.followFailed);
    }
  }

  Future<void> _unfollow() async {
    final ok = await context.read<ProfileCubit>().unfollow();
    if (!ok && mounted) {
      getIt<ToastService>().show(context, message: context.l10n.followFailed);
    }
  }

  void _showMore() {
    final l10n = context.l10n;
    unawaited(
      showAppActionSheet(
        context,
        cancelLabel: l10n.commonCancel,
        items: [
          ActionSheetItem(
            icon: AppIcons.more,
            label: l10n.profileReport,
            onTap: () => getIt<ToastService>().show(
              context,
              message: l10n.profileReportAck,
            ),
          ),
          ActionSheetItem(
            icon: AppIcons.close,
            label: l10n.profileBlock,
            onTap: () => getIt<ToastService>().show(
              context,
              message: l10n.profileBlockAck,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: tokens.bgApp,
      appBar: AppBar(
        backgroundColor: tokens.bgApp,
        leading: IconButton(
          icon: const AppIcon(AppIcons.back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '@${widget.username}',
          style: AppTypography.h3.copyWith(color: tokens.textPrimary),
        ),
        actions: [
          AppIconButton(
            icon: AppIcons.more,
            semanticLabel: l10n.profileReport,
            onPressed: _showMore,
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) => switch (state) {
            ProfileError() => _ErrorState(
              onRetry: () => context.read<ProfileCubit>().loadInitial(
                widget.username,
              ),
            ),
            ProfileLoaded() => _loaded(context, state),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
      ),
    );
  }

  Widget _loaded(BuildContext context, ProfileLoaded state) {
    final l10n = context.l10n;
    final view = state.view;
    return MaxWidthBox(
      maxWidth: AppSpacing.profileMaxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ProfileHeader(
              view: view,
              onTapFollowers: view.canOpenConnections
                  ? () => unawaited(
                      context.push(
                        AppRoutes.userConnectionsPath(widget.username),
                        extra: view.user.id,
                      ),
                    )
                  : null,
              onTapFollowing: view.canOpenConnections
                  ? () => unawaited(
                      context.push(
                        AppRoutes.userConnectionsPath(
                          widget.username,
                          tab: 'following',
                        ),
                        extra: view.user.id,
                      ),
                    )
                  : null,
              actions: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (view.relationship.followsYou) ...[
                    _FollowsYouChip(),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: FollowButton(
                          relationship: view.relationship,
                          username: widget.username,
                          busy: state.followBusy,
                          fullWidth: true,
                          onFollow: () => unawaited(_follow()),
                          onUnfollow: () => unawaited(_unfollow()),
                          onWithdraw: () => unawaited(_unfollow()),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppButton(
                          label: l10n.profileMessage,
                          kind: AppButtonKind.secondary,
                          onPressed: () => getIt<ToastService>().show(
                            context,
                            message: l10n.profileMessageAck,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: view.showPrivateGate
                ? const PrivateGate()
                : state.grid.isEmpty
                ? Center(
                    child: Text(
                      l10n.profileEmptyPosts,
                      style: AppTypography.body16.copyWith(
                        color: context.tokens.textTertiary,
                      ),
                    ),
                  )
                : ProfileGrid(
                    items: state.grid,
                    controller: _scroll,
                    onTapItem: _openItem,
                  ),
          ),
        ],
      ),
    );
  }
}

class _FollowsYouChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: tokens.surface2,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        context.l10n.profileFollowsYou,
        style: AppTypography.caption.copyWith(color: tokens.textSecondary),
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.profileNotFound,
            style: AppTypography.h3.copyWith(color: context.tokens.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onRetry, child: Text(l10n.discoveryRetry)),
        ],
      ),
    );
  }
}
