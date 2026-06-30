import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_tag.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';

/// Emoji/sticker tray: category pills + a 5-column emoji grid. Constitution VI.
class StickerTray extends StatefulWidget {
  const StickerTray({
    required this.categories,
    required this.emojis,
    this.onPick,
    super.key,
  });

  final List<String> categories;
  final List<String> emojis;
  final ValueChanged<String>? onPick;

  @override
  State<StickerTray> createState() => _StickerTrayState();
}

class _StickerTrayState extends State<StickerTray> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      height: 280,
      color: tokens.surface,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, i) => AppTag(
                label: widget.categories[i],
                active: i == _selected,
                onTap: () => setState(() => _selected = i),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              itemCount: widget.emojis.length,
              itemBuilder: (context, i) => GestureDetector(
                onTap: () => widget.onPick?.call(widget.emojis[i]),
                child: Center(
                  child: Text(
                    widget.emojis[i],
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
