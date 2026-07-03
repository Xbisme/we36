import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_icon_button.dart';
import 'package:we36/core/presentation/max_width_box.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/profile/domain/usecases/profile_usecases.dart';
import 'package:we36/features/profile/presentation/cubit/my_profile_cubit.dart';
import 'package:we36/features/profile/presentation/cubit/my_profile_state.dart';
import 'package:we36/features/profile/presentation/widgets/profile_grid.dart';
import 'package:we36/features/profile/presentation/widgets/profile_header.dart';
import 'package:we36/features/profile/presentation/widgets/profile_tab_bar.dart';

/// The Profile tab (#010 Screen 20): my own header (avatar + stats + bio + edit /
/// share), Posts + Tagged grids, entry points to Settings / Create.
class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Scaffold(
      backgroundColor: tokens.bgApp,
      body: SafeArea(
        child: BlocBuilder<MyProfileCubit, MyProfileState>(
          builder: (context, state) => switch (state) {
            MyProfileError() => _ErrorState(
              onRetry: context.read<MyProfileCubit>().retry,
            ),
            MyProfileLoaded() => _Loaded(state: state),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
      ),
    );
  }
}

class _Loaded extends StatefulWidget {
  const _Loaded({required this.state});
  final MyProfileLoaded state;

  @override
  State<_Loaded> createState() => _LoadedState();
}

class _LoadedState extends State<_Loaded> {
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
      unawaited(context.read<MyProfileCubit>().loadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = widget.state;
    final user = state.view.user;
    return MaxWidthBox(
      maxWidth: AppSpacing.profileMaxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TopBar(username: user.username),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: ProfileHeader(
              view: state.view,
              website: state.website,
              onTapFollowers: () => unawaited(
                context.push(AppRoutes.userConnectionsPath(user.username)),
              ),
              onTapFollowing: () => unawaited(
                context.push(
                  AppRoutes.userConnectionsPath(
                    user.username,
                    tab: 'following',
                  ),
                ),
              ),
              actions: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: l10n.profileEditProfile,
                      kind: AppButtonKind.secondary,
                      onPressed: () =>
                          unawaited(context.push(AppRoutes.editProfile)),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: l10n.profileShareProfile,
                      kind: AppButtonKind.secondary,
                      onPressed: () => getIt<ToastService>().show(
                        context,
                        message: l10n.profileShareAck,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ProfileTabBar(
            active: state.tab,
            onSelect: (t) =>
                unawaited(context.read<MyProfileCubit>().switchTab(t)),
          ),
          Expanded(
            child: state.grid.isEmpty
                ? Center(
                    child: Text(
                      state.tab == ProfileTab.posts
                          ? l10n.profileEmptyPosts
                          : l10n.profileEmptyTagged,
                      style: AppTypography.body16.copyWith(
                        color: context.tokens.textTertiary,
                      ),
                    ),
                  )
                : ProfileGrid(
                    items: state.grid,
                    controller: _scroll,
                    onTapItem: (item) => _openItem(context, item),
                  ),
          ),
        ],
      ),
    );
  }

  void _openItem(BuildContext context, ExploreItem item) {
    if (item.isReel) {
      context.go(AppRoutes.reels);
    } else {
      unawaited(context.push(AppRoutes.postDetailPath(item.id)));
    }
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.username});
  final String username;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '@$username',
              style: AppTypography.h3.copyWith(color: tokens.textPrimary),
            ),
          ),
          AppIconButton(
            icon: AppIcons.plus,
            semanticLabel: l10n.navCreate,
            onPressed: () => unawaited(context.push(AppRoutes.create)),
          ),
          AppIconButton(
            icon: AppIcons.settings,
            semanticLabel: l10n.profileSettings,
            onPressed: () => unawaited(context.push(AppRoutes.settings)),
          ),
        ],
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
            l10n.profileError,
            style: AppTypography.h3.copyWith(color: context.tokens.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onRetry, child: Text(l10n.discoveryRetry)),
        ],
      ),
    );
  }
}
