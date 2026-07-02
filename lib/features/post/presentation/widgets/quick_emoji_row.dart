import 'package:flutter/material.dart';
import 'package:we36/core/theme/app_dimens.dart';

/// A fixed row of quick emoji (Screen 15). Tapping one inserts it into the
/// comment input — it does NOT post immediately (clarify 2026-07-02, Q4).
class QuickEmojiRow extends StatelessWidget {
  const QuickEmojiRow({required this.onSelect, super.key});

  /// The fixed quick-emoji set.
  static const List<String> emojis = [
    '❤️',
    '🙌',
    '🔥',
    '👏',
    '😢',
    '😍',
    '😮',
    '😂',
  ];

  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final e in emojis)
            Semantics(
              button: true,
              excludeSemantics: true,
              label: 'Insert $e',
              child: InkResponse(
                onTap: () => onSelect(e),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.sm,
                  ),
                  child: Text(e, style: const TextStyle(fontSize: 22)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
