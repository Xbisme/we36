import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// One discovery-grid cell (#009 US2): a post/reel thumbnail with a reels marker
/// overlay for reels. Images decode at a bounded resolution (Constitution II).
/// Tapping opens the item (handled by the page).
class DiscoveryGridTile extends StatelessWidget {
  const DiscoveryGridTile({required this.item, required this.onTap, super.key});

  final ExploreItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final url = item.thumbnailUrl;
    final l10n = context.l10n;
    return Semantics(
      button: true,
      label:
          '${item.isReel ? l10n.reelTileLabel : l10n.photoTileLabel}'
          '${item.author.username == null ? '' : ' by ${item.author.username}'}',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: ColoredBox(
          color: tokens.surface2,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (url != null)
                CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  memCacheWidth: 400,
                  placeholder: (_, _) => ColoredBox(color: tokens.surface2),
                  errorWidget: (_, _, _) => ColoredBox(color: tokens.surface2),
                ),
              if (item.isReel)
                const Positioned(
                  top: 6,
                  right: 6,
                  child: AppIcon(AppIcons.reels, size: 16, color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
