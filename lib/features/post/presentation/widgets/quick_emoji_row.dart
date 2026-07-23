import 'package:flutter/material.dart';

/// A fixed row of quick emoji (Screen 15). Tapping one inserts it into the
/// comment input — it does NOT post immediately (clarify 2026-07-02, Q4).
class QuickEmojiRow extends StatelessWidget {
  const QuickEmojiRow({required this.onSelect, super.key});

  /// The fixed quick-emoji set (design B7): 7 reactions, left-packed.
  static const List<String> emojis = ['❤️', '🙌', '🔥', '👏', '😍', '😮', '😂'];

  /// Design B7 inter-emoji gap (not on the 4px token scale).
  static const double _gap = 14;

  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          for (final e in emojis)
            Semantics(
              button: true,
              excludeSemantics: true,
              label: 'Insert $e',
              child: InkResponse(
                onTap: () => onSelect(e),
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: _gap,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Text(e, style: const TextStyle(fontSize: 24)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
