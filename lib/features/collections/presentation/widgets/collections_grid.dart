import 'package:flutter/material.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/features/collections/presentation/widgets/collection_card.dart';

/// The 2-column Saved-collections grid (#011 Screen 24) — the "All saved" default
/// card is first (the list is already ordered). Scrolls; the hosting view owns
/// pull-to-refresh.
class CollectionsGrid extends StatelessWidget {
  const CollectionsGrid({
    required this.collections,
    required this.onTapCollection,
    this.onManageCollection,
    this.controller,
    super.key,
  });

  final List<SavedCollection> collections;
  final ValueChanged<SavedCollection> onTapCollection;

  /// Long-press a manageable card → manage sheet (#011 US4).
  final ValueChanged<SavedCollection>? onManageCollection;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) => GridView.builder(
    controller: controller,
    padding: const EdgeInsets.all(AppSpacing.lg),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.lg,
      childAspectRatio: 0.78,
    ),
    itemCount: collections.length,
    itemBuilder: (context, i) => CollectionCard(
      collection: collections[i],
      onTap: () => onTapCollection(collections[i]),
      onLongPress: (onManageCollection == null || !collections[i].canManage)
          ? null
          : () => onManageCollection!(collections[i]),
    ),
  );
}
