import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_tag.dart';
import 'package:we36/core/theme/app_dimens.dart';

/// Static category shortcut chips on Explore (#009 US2, FR-015). Each deep-links
/// to its hashtag page — there is no personalized "For you" category (MVP,
/// non-personalized). The tag set is a fixed client-side list.
class CategoryChips extends StatelessWidget {
  const CategoryChips({required this.onSelect, super.key});

  /// Called with the tag (lowercase, no `#`) when a chip is tapped.
  final ValueChanged<String> onSelect;

  /// Fixed shortcut tags (topic identifiers, not localized UI copy).
  static const List<String> tags = ['travel', 'food', 'design', 'fitness'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: tags.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) => AppTag(
          label: tags[i],
          hashtag: true,
          onTap: () => onSelect(tags[i]),
        ),
      ),
    );
  }
}
