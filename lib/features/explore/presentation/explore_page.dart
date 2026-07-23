import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/presentation/app_search_bar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:we36/features/explore/presentation/cubit/explore_state.dart';
import 'package:we36/features/explore/presentation/widgets/category_chips.dart';
import 'package:we36/features/explore/presentation/widgets/discovery_grid.dart';

/// The Explore tab (#009 Screen 16): a SearchBar entry, category shortcut chips,
/// and the non-personalized discovery grid (mixed posts/reels). Opens to cached
/// content instantly (offline cold start), reconciled by a background refresh.
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  void _openItem(BuildContext context, ExploreItem item) {
    if (item.isReel) {
      // A per-reel deep route lands later; switch to the Reels surface for now.
      context.go(AppRoutes.reels);
    } else {
      unawaited(context.push(AppRoutes.postDetailPath(item.id)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar + category chips share one surface panel with a hairline
          // bottom divider, lifting them off the page background (explore.jsx C1).
          DecoratedBox(
            decoration: BoxDecoration(
              color: tokens.surface,
              border: Border(bottom: BorderSide(color: tokens.divider)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    10,
                    AppSpacing.lg,
                    0,
                  ),
                  child: AppSearchBar(
                    hint: l10n.searchHint,
                    readOnly: true,
                    onTap: () => unawaited(context.push(AppRoutes.search)),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                CategoryChips(
                  onSelect: (tag) =>
                      unawaited(context.push(AppRoutes.hashtagPath(tag))),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ExploreCubit, ExploreState>(
              builder: (context, state) {
                final cubit = context.read<ExploreCubit>();
                if (state.items.isNotEmpty) {
                  return Column(
                    children: [
                      if (state is ExploreLoaded && state.isOffline)
                        _OfflineBanner(text: l10n.discoveryOffline),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: cubit.refresh,
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (n) {
                              if (state.hasMore &&
                                  n.metrics.pixels >=
                                      n.metrics.maxScrollExtent - 400) {
                                unawaited(cubit.loadMore());
                              }
                              return false;
                            },
                            child: DiscoveryGrid(
                              items: state.items,
                              onTapItem: (item) => _openItem(context, item),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return switch (state) {
                  ExploreError() => _ErrorState(onRetry: cubit.retry),
                  ExploreLoading() || ExploreInitial() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  _ => _EmptyState(
                    title: l10n.exploreEmpty,
                    hint: l10n.exploreEmptyHint,
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: double.infinity,
      color: tokens.surface2,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTypography.caption.copyWith(color: tokens.textSecondary),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.hint});
  final String title;
  final String hint;
  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppTypography.h3.copyWith(color: tokens.textPrimary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            hint,
            style: AppTypography.caption.copyWith(color: tokens.textTertiary),
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
            l10n.exploreError,
            style: AppTypography.h3.copyWith(color: context.tokens.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onRetry, child: Text(l10n.discoveryRetry)),
        ],
      ),
    );
  }
}
