import 'package:flutter/material.dart';
import 'package:we36/core/mock/mock_data.dart';
import 'package:we36/core/presentation/app_search_bar.dart';
import 'package:we36/core/presentation/app_tag.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// Explore placeholder: search entry + tag chips + a responsive quilt grid.
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final tags = MockData.exploreTags;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AppSearchBar(hint: context.l10n.searchHint, readOnly: true),
          ),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: tags.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, i) =>
                  AppTag(label: tags[i], active: i == 0),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(2),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemCount: 18,
              itemBuilder: (context, i) => ColoredBox(
                color: i.isEven ? tokens.surface2 : tokens.surfaceSunken,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
