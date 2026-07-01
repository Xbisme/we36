import 'package:flutter/widgets.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/theme/app_colors_x.dart';

/// 4-column device photo grid for the story pick step (#005). Single-select — a
/// check ring marks the one chosen photo. Notifies [onSelect] on tap and
/// [onEndReached] near the bottom for pagination. Kept local to the stories
/// feature (Constitution XI — no cross-feature widget imports).
class StoryGalleryGrid extends StatelessWidget {
  const StoryGalleryGrid({
    required this.assets,
    required this.selectedId,
    required this.library,
    required this.onSelect,
    this.onEndReached,
    super.key,
  });

  final List<AssetRef> assets;
  final String? selectedId;
  final PhotoLibraryService library;
  final ValueChanged<String> onSelect;
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
        final isSelected = asset.id == selectedId;
        return Pressable(
          onTap: () => onSelect(asset.id),
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
                if (isSelected) ...[
                  Container(color: tokens.accent.withValues(alpha: 0.18)),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: AppIcon(
                      AppIcons.check,
                      size: 18,
                      color: tokens.accent,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
