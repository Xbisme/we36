import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_search_bar.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/profile/domain/usecases/follow_list_usecases.dart';
import 'package:we36/features/profile/presentation/cubit/follow_list_cubit.dart';
import 'package:we36/features/profile/presentation/cubit/follow_list_state.dart';
import 'package:we36/features/profile/presentation/widgets/account_row_tile.dart';

/// A profile's followers/following (#010 Screen 22): two tabs + search + rows
/// with a read-write Follow control.
class FollowListPage extends StatefulWidget {
  const FollowListPage({required this.username, super.key});

  final String username;

  @override
  State<FollowListPage> createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage> {
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
      unawaited(context.read<FollowListCubit>().loadMore());
    }
  }

  Future<void> _toggle(String userId, {required bool following}) async {
    final cubit = context.read<FollowListCubit>();
    final ok = following
        ? await cubit.unfollowRow(userId)
        : await cubit.followRow(userId);
    if (!ok && mounted) {
      getIt<ToastService>().show(context, message: context.l10n.followFailed);
    }
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
          widget.username,
          style: AppTypography.h3.copyWith(color: tokens.textPrimary),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<FollowListCubit, FollowListState>(
          builder: (context, state) {
            final cubit = context.read<FollowListCubit>();
            final activeTab = switch (state) {
              FollowListLoaded(:final tab) => tab,
              _ => FollowConnTab.followers,
            };
            return Column(
              children: [
                Row(
                  children: [
                    _Tab(
                      label: l10n.followListFollowers,
                      selected: activeTab == FollowConnTab.followers,
                      onTap: () =>
                          unawaited(cubit.switchTab(FollowConnTab.followers)),
                    ),
                    _Tab(
                      label: l10n.followListFollowing,
                      selected: activeTab == FollowConnTab.following,
                      onTap: () =>
                          unawaited(cubit.switchTab(FollowConnTab.following)),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: AppSearchBar(
                    hint: l10n.followListSearchHint,
                    onChanged: (q) => unawaited(cubit.search(q)),
                  ),
                ),
                Expanded(child: _body(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _body(BuildContext context, FollowListState state) {
    final l10n = context.l10n;
    return switch (state) {
      FollowListError() => Center(
        child: Text(
          l10n.profileError,
          style: AppTypography.body16.copyWith(
            color: context.tokens.textTertiary,
          ),
        ),
      ),
      FollowListLoaded(:final rows) when rows.isEmpty => Center(
        child: Text(
          l10n.followListEmptySearch,
          style: AppTypography.body16.copyWith(
            color: context.tokens.textTertiary,
          ),
        ),
      ),
      FollowListLoaded(:final rows) => ListView.builder(
        controller: _scroll,
        itemCount: rows.length,
        itemBuilder: (context, i) {
          final row = rows[i];
          return AccountRowTile(
            row: row,
            onFollow: () => unawaited(_toggle(row.user.id, following: false)),
            onUnfollow: () => unawaited(_toggle(row.user.id, following: true)),
          );
        },
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selected ? tokens.accent : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              // Design D3: inactive tab in textSecondary (not textTertiary).
              style: AppTypography.label.copyWith(
                color: selected ? tokens.textPrimary : tokens.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
