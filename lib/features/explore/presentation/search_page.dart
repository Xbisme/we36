import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/data/discovery/search_recent.dart';
import 'package:we36/core/data/discovery/search_results.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_search_bar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/explore/presentation/cubit/recents_cubit.dart';
import 'package:we36/features/explore/presentation/cubit/search_cubit.dart';
import 'package:we36/features/explore/presentation/cubit/search_state.dart';
import 'package:we36/features/explore/presentation/widgets/account_result_row.dart';
import 'package:we36/features/explore/presentation/widgets/recents_section.dart';
import 'package:we36/features/explore/presentation/widgets/result_rows.dart';
import 'package:we36/features/explore/presentation/widgets/results_tabs.dart';

/// The Search screen (#009 Screens 17+18). A short/empty query shows recents
/// (US3); at ≥2 chars it shows the live results tabs (US1). Reused by the Explore
/// SearchBar entry point.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  SearchCubit get _cubit => context.read<SearchCubit>();
  RecentsCubit get _recents => context.read<RecentsCubit>();

  void _submit(String q) {
    unawaited(_cubit.submit(q));
    if (q.trim().length >= SearchCubit.minChars) {
      unawaited(_recents.record(RecordSearchRecent.term(q.trim())));
    }
  }

  void _openAccount(AccountResult a) {
    unawaited(_recents.record(RecordSearchRecent.account(a.user.id)));
    final username = a.user.username;
    if (username != null) {
      unawaited(context.push(AppRoutes.userProfilePath(username)));
    }
  }

  void _openHashtag(String tag) {
    unawaited(_recents.record(RecordSearchRecent.hashtag(tag)));
    unawaited(context.push(AppRoutes.hashtagPath(tag)));
  }

  void _openPlace(PlaceResult p) {
    unawaited(_recents.record(RecordSearchRecent.place(p.id)));
    unawaited(context.push(AppRoutes.placePath(p.id)));
  }

  void _openHashtagById(String tag) =>
      unawaited(context.push(AppRoutes.hashtagPath(tag)));
  void _openPlaceById(String id) =>
      unawaited(context.push(AppRoutes.placePath(id)));

  void _pickRecentTerm(String term) {
    _controller.text = term;
    unawaited(_cubit.submit(term));
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: tokens.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  IconButton(
                    icon: const AppIcon(AppIcons.back),
                    onPressed: () => context.pop(),
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).backButtonTooltip,
                  ),
                  Expanded(
                    child: AppSearchBar(
                      hint: l10n.searchHint,
                      controller: _controller,
                      autofocus: true,
                      onChanged: _cubit.onQueryChanged,
                      onSubmitted: _submit,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) => switch (state) {
                  SearchInitial() => RecentsSection(
                    onPickTerm: _pickRecentTerm,
                    onOpenHashtag: _openHashtagById,
                    onOpenPlace: _openPlaceById,
                  ),
                  SearchLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  SearchError() => _ErrorState(onRetry: _cubit.retry),
                  SearchLoaded(:final tab) => Column(
                    children: [
                      ResultsTabs(
                        active: tab,
                        labels: {
                          SearchTab.top: l10n.searchTabTop,
                          SearchTab.accounts: l10n.searchTabAccounts,
                          SearchTab.tags: l10n.searchTabTags,
                          SearchTab.places: l10n.searchTabPlaces,
                        },
                        onSelect: _cubit.changeTab,
                      ),
                      Divider(height: 1, color: tokens.divider),
                      Expanded(
                        child: _ResultsBody(state: state, page: this),
                      ),
                    ],
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Renders the active tab's content: the blended Top snapshot or a single-type
/// paginated list.
class _ResultsBody extends StatelessWidget {
  const _ResultsBody({required this.state, required this.page});

  final SearchLoaded state;
  final _SearchPageState page;

  @override
  Widget build(BuildContext context) {
    return switch (state.tab) {
      SearchTab.top => _TopView(state: state, page: page),
      SearchTab.accounts => _TypedList<AccountResult>(
        items: state.accounts,
        hasMore: state.hasMore,
        loadingMore: state.loadingMore,
        onLoadMore: page._cubit.loadMore,
        itemBuilder: (a) =>
            AccountResultRow(result: a, onTap: () => page._openAccount(a)),
      ),
      SearchTab.tags => _TypedList<HashtagResult>(
        items: state.tags,
        hasMore: state.hasMore,
        loadingMore: state.loadingMore,
        onLoadMore: page._cubit.loadMore,
        itemBuilder: (h) =>
            HashtagResultRow(result: h, onTap: () => page._openHashtag(h.tag)),
      ),
      SearchTab.places => _TypedList<PlaceResult>(
        items: state.places,
        hasMore: state.hasMore,
        loadingMore: state.loadingMore,
        onLoadMore: page._cubit.loadMore,
        itemBuilder: (p) =>
            PlaceResultRow(result: p, onTap: () => page._openPlace(p)),
      ),
    };
  }
}

class _TopView extends StatelessWidget {
  const _TopView({required this.state, required this.page});

  final SearchLoaded state;
  final _SearchPageState page;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final top = state.top;
    if (top == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (top.isEmpty) {
      return _EmptyState(message: l10n.searchNoResults);
    }
    return ListView(
      children: [
        if (top.accounts.isNotEmpty) ...[
          _SectionHeader(
            title: l10n.searchTabAccounts,
            onSeeMore: () => page._cubit.changeTab(SearchTab.accounts),
          ),
          for (final a in top.accounts)
            AccountResultRow(result: a, onTap: () => page._openAccount(a)),
        ],
        if (top.hashtags.isNotEmpty) ...[
          _SectionHeader(
            title: l10n.searchTabTags,
            onSeeMore: () => page._cubit.changeTab(SearchTab.tags),
          ),
          for (final h in top.hashtags)
            HashtagResultRow(result: h, onTap: () => page._openHashtag(h.tag)),
        ],
        if (top.places.isNotEmpty) ...[
          _SectionHeader(
            title: l10n.searchTabPlaces,
            onSeeMore: () => page._cubit.changeTab(SearchTab.places),
          ),
          for (final p in top.places)
            PlaceResultRow(result: p, onTap: () => page._openPlace(p)),
        ],
      ],
    );
  }
}

class _TypedList<T> extends StatelessWidget {
  const _TypedList({
    required this.items,
    required this.hasMore,
    required this.loadingMore,
    required this.onLoadMore,
    required this.itemBuilder,
  });

  final List<T> items;
  final bool hasMore;
  final bool loadingMore;
  final VoidCallback onLoadMore;
  final Widget Function(T) itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _EmptyState(message: context.l10n.searchNoResults);
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (hasMore &&
            !loadingMore &&
            n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: items.length + (loadingMore ? 1 : 0),
        itemBuilder: (context, i) {
          if (i >= items.length) {
            return const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return itemBuilder(items[i]);
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onSeeMore});
  final String title;
  final VoidCallback onSeeMore;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTypography.label.copyWith(
              color: tokens.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextButton(
            onPressed: onSeeMore,
            child: Text(context.l10n.searchSeeMore),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      message,
      style: AppTypography.body16.copyWith(color: context.tokens.textTertiary),
    ),
  );
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
