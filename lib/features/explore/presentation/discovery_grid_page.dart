import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/count_formatter.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/explore/presentation/cubit/discovery_grid_cubit.dart';
import 'package:we36/features/explore/presentation/cubit/discovery_grid_state.dart';
import 'package:we36/features/explore/presentation/widgets/discovery_grid.dart';

/// A hashtag or place page (#009 Screen 19): header (title + post count, and — on
/// a hashtag — a **surface-only** Follow that only toasts) + a single cursor grid
/// of the permitted posts+reels. One page for both (the cubit serves both).
class DiscoveryGridPage extends StatelessWidget {
  const DiscoveryGridPage({super.key});

  void _openItem(BuildContext context, ExploreItem item) {
    if (item.isReel) {
      context.go(AppRoutes.reels);
    } else {
      unawaited(context.push(AppRoutes.postDetailPath(item.id)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final cubit = context.read<DiscoveryGridCubit>();
    return Scaffold(
      backgroundColor: tokens.bgApp,
      appBar: AppBar(
        backgroundColor: tokens.bgApp,
        leading: IconButton(
          icon: const AppIcon(AppIcons.back),
          onPressed: () => context.pop(),
        ),
        title: BlocBuilder<DiscoveryGridCubit, DiscoveryGridState>(
          builder: (context, state) => Text(
            state is DiscoveryGridLoaded ? state.title : '',
            style: AppTypography.h3.copyWith(color: tokens.textPrimary),
          ),
        ),
      ),
      body: BlocBuilder<DiscoveryGridCubit, DiscoveryGridState>(
        builder: (context, state) => switch (state) {
          DiscoveryGridError() => _ErrorState(onRetry: cubit.retry),
          DiscoveryGridLoaded() => Column(
            children: [
              _Header(state: state),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (state.hasMore &&
                        n.metrics.pixels >= n.metrics.maxScrollExtent - 400) {
                      unawaited(cubit.loadMore());
                    }
                    return false;
                  },
                  child: state.items.isEmpty
                      ? Center(
                          child: Text(
                            l10n.searchNoResults,
                            style: AppTypography.body16.copyWith(
                              color: tokens.textTertiary,
                            ),
                          ),
                        )
                      : DiscoveryGrid(
                          items: state.items,
                          onTapItem: (item) => _openItem(context, item),
                        ),
                ),
              ),
            ],
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.state});
  final DiscoveryGridLoaded state;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final counts = CountFormatter(Localizations.localeOf(context).toString());
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.title,
                  style: AppTypography.h2.copyWith(color: tokens.textPrimary),
                ),
                Text(
                  '${counts.format(state.postCount)} ${l10n.postsLabel}',
                  style: AppTypography.caption.copyWith(
                    color: tokens.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          if (state.kind == DiscoveryPageKind.hashtag)
            OutlinedButton(
              onPressed: () => getIt<ToastService>().show(
                context,
                message: l10n.hashtagFollowAck,
              ),
              child: Text(l10n.hashtagFollow),
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
            l10n.searchError,
            style: AppTypography.h3.copyWith(color: context.tokens.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onRetry, child: Text(l10n.discoveryRetry)),
        ],
      ),
    );
  }
}
