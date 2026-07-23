import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_tag.dart';
import 'package:we36/core/theme/app_dimens.dart';

/// Static category shortcut chips on Explore (#009 US2, FR-015). A leading,
/// always-active "For you" chip (the default discovery lane) precedes the
/// hashtag chips, each of which deep-links to its hashtag page (explore.jsx C1).
/// The tag set is a fixed client-side list.
class CategoryChips extends StatelessWidget {
  const CategoryChips({required this.onSelect, super.key});

  /// Called with the tag (lowercase, no `#`) when a hashtag chip is tapped.
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
        // +1 for the leading "For you" lane chip.
        itemCount: tags.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          if (i == 0) {
            return const AppTag(label: 'For you', active: true);
          }
          final tag = tags[i - 1];
          return AppTag(
            label: tag,
            hashtag: true,
            onTap: () => onSelect(tag),
          );
        },
      ),
    );
  }
}
