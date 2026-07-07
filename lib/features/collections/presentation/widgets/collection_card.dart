import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// One collection card on the Saved grid (#011 Screen 24): a rounded 4-image
/// quilt cover + the name + an "N saved" count. The synthetic "All saved" default
/// shows a localized name. Covers decode at a bounded resolution (Constitution
/// II) and fall back to a placeholder when empty (FR-010).
class CollectionCard extends StatelessWidget {
  const CollectionCard({
    required this.collection,
    required this.onTap,
    this.onLongPress,
    super.key,
  });

  final SavedCollection collection;
  final VoidCallback onTap;

  /// Optional long-press → manage sheet (#011 US4; null for the default card).
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final name = collection.isDefault ? l10n.savedAllSaved : collection.name;
    return Semantics(
      button: true,
      label: '$name, ${l10n.collectionSavedCount(collection.itemCount)}',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Expands to fill the cell above the labels, so the card stays within
            // its grid cell even at large text scales (US5 — no overflow).
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _Quilt(covers: collection.coverThumbnails),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.label.copyWith(color: tokens.textPrimary),
            ),
            Text(
              l10n.collectionSavedCount(collection.itemCount),
              style: AppTypography.caption.copyWith(color: tokens.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}

/// The rounded quilt: one full image, or a 2×2 grid of up to 4 thumbnails, with
/// empty cells / an empty state filled by the neutral surface.
class _Quilt extends StatelessWidget {
  const _Quilt({required this.covers});
  final List<String> covers;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    if (covers.isEmpty) {
      return ColoredBox(
        color: tokens.surface2,
        child: Center(
          child: AppIcon(AppIcons.save, size: 28, color: tokens.textTertiary),
        ),
      );
    }
    if (covers.length == 1) {
      return _cell(context, covers.first);
    }
    const gap = 2.0;
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _cell(context, covers[0])),
              const SizedBox(width: gap),
              Expanded(child: _cellOrFiller(context, covers, 1)),
            ],
          ),
        ),
        const SizedBox(height: gap),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _cellOrFiller(context, covers, 2)),
              const SizedBox(width: gap),
              Expanded(child: _cellOrFiller(context, covers, 3)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cellOrFiller(BuildContext context, List<String> covers, int i) =>
      i < covers.length
      ? _cell(context, covers[i])
      : ColoredBox(color: context.tokens.surface2);

  Widget _cell(BuildContext context, String url) => CachedNetworkImage(
    imageUrl: url,
    fit: BoxFit.cover,
    memCacheWidth: 300,
    placeholder: (_, _) => ColoredBox(color: context.tokens.surface2),
    errorWidget: (_, _, _) => ColoredBox(color: context.tokens.surface2),
  );
}
