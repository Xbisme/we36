import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/data/discovery/search_recent.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/explore/presentation/cubit/recents_cubit.dart';
import 'package:we36/features/explore/presentation/cubit/recents_state.dart';

/// The recent-searches list shown when the query is empty/short (#009 US3,
/// Screen 17): "Recent" + "Clear all" header, then typed rows with a per-row
/// remove. Tapping a row re-runs the search (term) or opens the entity.
class RecentsSection extends StatelessWidget {
  const RecentsSection({
    required this.onPickTerm,
    required this.onOpenHashtag,
    required this.onOpenPlace,
    super.key,
  });

  final ValueChanged<String> onPickTerm;
  final ValueChanged<String> onOpenHashtag;
  final ValueChanged<String> onOpenPlace;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    return BlocBuilder<RecentsCubit, RecentsState>(
      builder: (context, state) {
        final items = state.items;
        if (state is RecentsLoading || state is RecentsInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (items.isEmpty) {
          return Center(
            child: Text(
              l10n.recentsEmpty,
              style: AppTypography.body16.copyWith(color: tokens.textTertiary),
            ),
          );
        }
        final cubit = context.read<RecentsCubit>();
        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.xs,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.recentTitle,
                    style: AppTypography.label.copyWith(
                      color: tokens.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: cubit.clearAll,
                    child: Text(l10n.recentClearAll),
                  ),
                ],
              ),
            ),
            for (final r in items)
              _RecentRow(
                recent: r,
                onTap: () => _onTap(r),
                onRemove: () => cubit.deleteRecent(r.id),
              ),
          ],
        );
      },
    );
  }

  void _onTap(SearchRecent r) {
    switch (r.type) {
      case SearchRecentType.term:
        if (r.term != null) onPickTerm(r.term!);
      case SearchRecentType.hashtag:
        if (r.hashtag != null) onOpenHashtag(r.hashtag!.tag);
      case SearchRecentType.place:
        if (r.place != null) onOpenPlace(r.place!.id);
      case SearchRecentType.account:
        // Profile-by-handle nav lands in #010.
        break;
    }
  }
}

class _RecentRow extends StatelessWidget {
  const _RecentRow({
    required this.recent,
    required this.onTap,
    required this.onRemove,
  });

  final SearchRecent recent;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Semantics(
      button: true,
      label: _label(context),
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              _leading(context),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  _title,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.label.copyWith(
                    color: tokens.textPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: AppIcon(
                  AppIcons.close,
                  size: 18,
                  color: tokens.textTertiary,
                ),
                onPressed: onRemove,
                tooltip: context.l10n.recentRemove,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _title => switch (recent.type) {
    SearchRecentType.term => recent.term ?? '',
    SearchRecentType.account => '@${recent.account?.username ?? ''}',
    SearchRecentType.hashtag => '#${recent.hashtag?.tag ?? ''}',
    SearchRecentType.place => recent.place?.name ?? '',
  };

  String _label(BuildContext context) => _title;

  Widget _leading(BuildContext context) {
    final tokens = context.tokens;
    switch (recent.type) {
      case SearchRecentType.account:
        return const Avatar(size: 36);
      case SearchRecentType.term:
        return _circle(
          tokens.surface2,
          const AppIcon(AppIcons.search, size: 18),
        );
      case SearchRecentType.hashtag:
        return _circle(
          tokens.surface2,
          Text('#', style: AppTypography.label.copyWith(color: tokens.accent)),
        );
      case SearchRecentType.place:
        return _circle(
          tokens.surface2,
          const AppIcon(AppIcons.location, size: 18),
        );
    }
  }

  Widget _circle(Color bg, Widget child) => Container(
    width: 36,
    height: 36,
    alignment: Alignment.center,
    decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
    child: child,
  );
}
