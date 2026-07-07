import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_icon_button.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/collections/domain/usecases/manage_collection_usecases.dart';
import 'package:we36/features/collections/presentation/cubit/collections_cubit.dart';
import 'package:we36/features/collections/presentation/cubit/collections_state.dart';
import 'package:we36/features/collections/presentation/widgets/collection_more_sheet.dart';
import 'package:we36/features/collections/presentation/widgets/collections_grid.dart';
import 'package:we36/features/collections/presentation/widgets/create_collection_dialog.dart';

/// The Saved-collections body (#011 Screen 24), hosted by the profile Saved tab.
/// A compact header with a create (`+`) action, then the 2-column collections
/// grid (default "All saved" first). Renders empty / offline-from-cache / error.
class SavedCollectionsView extends StatelessWidget {
  const SavedCollectionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionsCubit, CollectionsState>(
      builder: (context, state) => switch (state) {
        CollectionsError() => _ErrorState(
          onRetry: context.read<CollectionsCubit>().retry,
        ),
        CollectionsLoaded(:final collections, :final isOffline) => _Loaded(
          collections: collections,
          isOffline: isOffline,
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.collections, required this.isOffline});

  final List<SavedCollection> collections;
  final bool isOffline;

  bool get _fullyEmpty {
    // Only the "All saved" default, and it has nothing saved.
    if (collections.length > 1) return false;
    if (collections.isEmpty) return true;
    final only = collections.first;
    return only.isDefault && only.itemCount == 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(onCreate: () => unawaited(_create(context))),
        if (isOffline) const _OfflineBanner(),
        Expanded(
          child: _fullyEmpty
              ? _EmptyState(
                  title: l10n.savedEmptyTitle,
                  body: l10n.savedEmptyBody,
                )
              : CollectionsGrid(
                  collections: collections,
                  onTapCollection: (c) =>
                      unawaited(_openCollection(context, c)),
                  onManageCollection: (c) =>
                      unawaited(CollectionMoreSheet.show(context, c)),
                ),
        ),
      ],
    );
  }

  /// Open a collection, then re-reconcile the grid on return — a save/unsave made
  /// inside the collection (or a post opened from it) changes the counts.
  Future<void> _openCollection(BuildContext context, SavedCollection c) async {
    final cubit = context.read<CollectionsCubit>();
    await context.push(AppRoutes.collectionPath(c.id), extra: c);
    await cubit.refresh();
  }

  Future<void> _create(BuildContext context) async {
    final name = await CreateCollectionDialog.show(context);
    if (name == null) return;
    final res = await getIt<CreateCollection>()(name);
    if (res.isErr && context.mounted) {
      getIt<ToastService>().show(
        context,
        message: context.l10n.collectionCreateFailed,
      );
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onCreate});
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.sm,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.savedTitle,
              style: AppTypography.label.copyWith(
                color: context.tokens.textSecondary,
              ),
            ),
          ),
          AppIconButton(
            icon: AppIcons.plus,
            semanticLabel: l10n.collectionNew,
            onPressed: onCreate,
          ),
        ],
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: double.infinity,
      color: tokens.surface2,
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: AppSpacing.lg,
      ),
      child: Text(
        context.l10n.savedError,
        style: AppTypography.caption.copyWith(color: tokens.textTertiary),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(AppIcons.save, size: 40, color: tokens.textTertiary),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.h3.copyWith(color: tokens.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              textAlign: TextAlign.center,
              style: AppTypography.body16.copyWith(color: tokens.textTertiary),
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.savedError,
            style: AppTypography.h3.copyWith(color: context.tokens.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onRetry, child: Text(l10n.discoveryRetry)),
        ],
      ),
    );
  }
}
