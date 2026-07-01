import 'package:flutter/widgets.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/features/compose/presentation/widgets/selection_badge.dart';

/// 4-column device photo grid with selection-order badges (Screen 11). Notifies
/// [onToggle] on tap and [onEndReached] near the bottom for pagination.
class GalleryGrid extends StatelessWidget {
  const GalleryGrid({
    required this.assets,
    required this.selectedIds,
    required this.library,
    required this.onToggle,
    this.onEndReached,
    super.key,
  });

  final List<AssetRef> assets;
  final List<String> selectedIds;
  final PhotoLibraryService library;
  final ValueChanged<String> onToggle;
  final VoidCallback? onEndReached;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        if (onEndReached != null && index == assets.length - 4) {
          WidgetsBinding.instance.addPostFrameCallback((_) => onEndReached!());
        }
        final asset = assets[index];
        final order = selectedIds.indexOf(asset.id);
        final isSelected = order >= 0;
        return Pressable(
          onTap: () => onToggle(asset.id),
          child: Semantics(
            selected: isSelected,
            button: true,
            label: 'Photo ${index + 1}',
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image(
                  image: library.thumbnail(asset, pixelSize: 240),
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
                if (isSelected)
                  Container(color: tokens.accent.withValues(alpha: 0.18)),
                Positioned(
                  top: 6,
                  right: 6,
                  child: SelectionBadge(order: isSelected ? order + 1 : null),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
