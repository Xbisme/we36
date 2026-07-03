import 'package:flutter/material.dart';
import 'package:we36/core/constants/app_breakpoints.dart';
import 'package:we36/core/data/discovery/explore_item.dart';
import 'package:we36/features/explore/presentation/widgets/discovery_grid_tile.dart';

/// The discovery grid (#009 US2/US4, FR-014/FR-031). On phones (<700) it's a
/// quilted 3-column layout with an emphasized 2×2 hero block; on tablets/iPad
/// (≥700) it reflows to a denser responsive grid instead of stretching. Scrolls
/// as a sliver so the hosting page owns pull-to-refresh + infinite scroll.
class DiscoveryGrid extends StatelessWidget {
  const DiscoveryGrid({
    required this.items,
    required this.onTapItem,
    this.footer,
    super.key,
  });

  final List<ExploreItem> items;
  final ValueChanged<ExploreItem> onTapItem;

  /// Optional trailing sliver (e.g. a paginating spinner).
  final Widget? footer;

  static const double _gap = 2;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= AppBreakpoints.tablet;
    return CustomScrollView(
      slivers: [
        if (isTablet || items.length < 3)
          _responsiveGrid(isTablet)
        else
          ..._quiltedPhone(width),
        ?footer,
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
      ],
    );
  }

  Widget _tile(int i) =>
      DiscoveryGridTile(item: items[i], onTap: () => onTapItem(items[i]));

  /// Uniform responsive grid (tablet, or a phone with too few items for a block).
  Widget _responsiveGrid(bool isTablet) => SliverGrid(
    gridDelegate: isTablet
        ? const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: _gap,
            crossAxisSpacing: _gap,
          )
        : const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: _gap,
            crossAxisSpacing: _gap,
          ),
    delegate: SliverChildBuilderDelegate(
      (context, i) => _tile(i),
      childCount: items.length,
    ),
  );

  /// Phone quilted layout: a 2×2 hero (item 0) beside two stacked tiles (1, 2),
  /// then the remaining items in a 3-column grid.
  List<Widget> _quiltedPhone(double width) {
    final cell = (width - _gap * 2) / 3;
    final heroSide = cell * 2 + _gap;
    return [
      SliverToBoxAdapter(
        child: SizedBox(
          height: heroSide,
          child: Row(
            children: [
              SizedBox(width: heroSide, height: heroSide, child: _tile(0)),
              const SizedBox(width: _gap),
              SizedBox(
                width: cell,
                child: Column(
                  children: [
                    SizedBox(height: cell, child: _tile(1)),
                    const SizedBox(height: _gap),
                    SizedBox(height: cell, child: _tile(2)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: _gap)),
      SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: _gap,
          crossAxisSpacing: _gap,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => _tile(i + 3),
          childCount: items.length - 3,
        ),
      ),
    ];
  }
}
