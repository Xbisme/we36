import 'package:flutter/material.dart';
import 'package:we36/core/constants/app_breakpoints.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/features/explore/presentation/widgets/discovery_grid_tile.dart';

/// A uniform 3-column profile grid (#010 FR-002/003) reusing the #009
/// [DiscoveryGridTile] (reels marked, bounded decode). Unlike the Explore grid it
/// has no quilted hero. On tablet width it reflows to more columns. Scrolls with
/// the provided [controller] so the page owns pull-to-load pagination.
class ProfileGrid extends StatelessWidget {
  const ProfileGrid({
    required this.items,
    required this.onTapItem,
    this.controller,
    super.key,
  });

  final List<ExploreItem> items;
  final ValueChanged<ExploreItem> onTapItem;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= AppBreakpoints.tablet;
    return GridView.builder(
      controller: controller,
      padding: EdgeInsets.zero,
      gridDelegate: wide
          ? const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            )
          : const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
      itemCount: items.length,
      itemBuilder: (context, i) =>
          DiscoveryGridTile(item: items[i], onTap: () => onTapItem(items[i])),
    );
  }
}
