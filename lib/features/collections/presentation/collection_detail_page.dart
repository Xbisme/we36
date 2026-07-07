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
import 'package:we36/features/collections/domain/usecases/save_to_collection_usecases.dart';
import 'package:we36/features/collections/presentation/cubit/collection_detail_cubit.dart';
import 'package:we36/features/collections/presentation/cubit/collection_detail_state.dart';
import 'package:we36/features/collections/presentation/widgets/save_to_collection_sheet.dart';
import 'package:we36/features/explore/presentation/widgets/discovery_grid.dart';

/// One collection's item grid (#011 US3, Screen 24 detail) — nav-less push. Tiles
/// open post detail; long-press offers Remove from collection / Remove from Saved
/// (full unsave, confirmed when the item is in ≥1 named collection) / Save to
/// collection. `id == kAllSavedCollectionId` is the virtual "All saved" view.
class CollectionDetailPage extends StatelessWidget {
  const CollectionDetailPage({
    required this.collectionId,
    this.collection,
    super.key,
  });

  final String collectionId;
  final SavedCollection? collection;

  @override
  Widget build(BuildContext context) => BlocProvider<CollectionDetailCubit>(
    create: (_) {
      final cubit = getIt<CollectionDetailCubit>();
      unawaited(cubit.load(collectionId));
      return cubit;
    },
    child: CollectionDetailView(
      collectionId: collectionId,
      collection: collection,
    ),
  );
}

/// The collection-detail body (reads its `CollectionDetailCubit` from context, so
/// widget tests can inject a stub). The [CollectionDetailPage] wraps it in the
/// `BlocProvider`.
class CollectionDetailView extends StatefulWidget {
  const CollectionDetailView({
    required this.collectionId,
    this.collection,
    super.key,
  });
  final String collectionId;
  final SavedCollection? collection;

  @override
  State<CollectionDetailView> createState() => _CollectionDetailViewState();
}

class _CollectionDetailViewState extends State<CollectionDetailView> {
  final _scroll = ScrollController();

  bool get _isDefault =>
      widget.collection?.isDefault ??
      (widget.collectionId == kAllSavedCollectionId);

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
      unawaited(context.read<CollectionDetailCubit>().loadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final title = _isDefault
        ? l10n.savedAllSaved
        : (widget.collection?.name ?? '');
    return Scaffold(
      backgroundColor: tokens.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  AppIconButton(
                    icon: AppIcons.close,
                    semanticLabel: l10n.commonCancel,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.h3.copyWith(
                        color: tokens.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<CollectionDetailCubit, CollectionDetailState>(
                builder: (context, state) => switch (state) {
                  CollectionDetailError() => _Error(
                    onRetry: context.read<CollectionDetailCubit>().retry,
                  ),
                  CollectionDetailLoaded(:final items) =>
                    items.isEmpty
                        ? _Empty(text: l10n.collectionEmpty)
                        : DiscoveryGrid(
                            items: items,
                            onTapItem: (item) =>
                                unawaited(_openPost(context, item.id)),
                            onLongPressItem: (item) =>
                                unawaited(_itemActions(context, item.id)),
                          ),
                  _ => const Center(child: CircularProgressIndicator()),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Open a post, then reload the grid on return — the post may have been
  /// unsaved in its detail (which removes it from "All saved" + this collection).
  Future<void> _openPost(BuildContext context, String postId) async {
    final cubit = context.read<CollectionDetailCubit>();
    await context.push(AppRoutes.postDetailPath(postId));
    await cubit.load(widget.collectionId);
  }

  Future<void> _itemActions(BuildContext context, String postId) async {
    final l10n = context.l10n;
    final cubit = context.read<CollectionDetailCubit>();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.tokens.surface,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_isDefault)
              ListTile(
                leading: const AppIcon(AppIcons.close),
                title: Text(l10n.collectionRemoveItem),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  unawaited(_remove(context, cubit, postId));
                },
              ),
            ListTile(
              leading: const AppIcon(AppIcons.save),
              title: Text(l10n.unsaveConfirmAction),
              onTap: () {
                Navigator.of(sheetContext).pop();
                unawaited(_confirmUnsave(context, cubit, postId));
              },
            ),
            ListTile(
              leading: const AppIcon(AppIcons.plus),
              title: Text(l10n.saveToCollection),
              onTap: () {
                Navigator.of(sheetContext).pop();
                unawaited(SaveToCollectionSheet.show(context, postId));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _remove(
    BuildContext context,
    CollectionDetailCubit cubit,
    String postId,
  ) async {
    final ok = await cubit.removeFromCollection(postId);
    if (!ok && context.mounted) {
      getIt<ToastService>().show(context, message: context.l10n.saveFailed);
    }
  }

  Future<void> _confirmUnsave(
    BuildContext context,
    CollectionDetailCubit cubit,
    String postId,
  ) async {
    // Confirm only when the item is in ≥1 named collection (R4 / FR-008).
    final membership = (await getIt<LoadPicker>()(postId)).valueOrNull;
    final namedCount = membership?.namedMembershipCount ?? 0;
    if (namedCount >= 1) {
      if (!context.mounted) return;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: context.tokens.surface,
          title: Text(context.l10n.unsaveConfirmTitle),
          content: Text(context.l10n.unsaveConfirmBody(namedCount)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(context.l10n.commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(context.l10n.unsaveConfirmAction),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    final ok = await cubit.fullUnsave(postId);
    if (!ok && context.mounted) {
      getIt<ToastService>().show(context, message: context.l10n.saveFailed);
    }
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      text,
      style: AppTypography.body16.copyWith(color: context.tokens.textTertiary),
    ),
  );
}

class _Error extends StatelessWidget {
  const _Error({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.collectionError,
            style: AppTypography.h3.copyWith(color: context.tokens.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onRetry, child: Text(l10n.discoveryRetry)),
        ],
      ),
    );
  }
}
