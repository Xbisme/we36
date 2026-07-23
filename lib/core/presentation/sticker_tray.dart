import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_icon_button.dart';
import 'package:we36/core/presentation/app_search_bar.dart';
import 'package:we36/core/presentation/app_tag.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_shadows.dart';

/// Rounded corner radius of an emoji tile (design: 14; no AppRadius token maps
/// to this exact value).
const double _tileRadius = 14;

/// Emoji/sticker tray: a search + close header, category pills, and a 5-column
/// grid of tinted emoji tiles. Constitution VI.
class StickerTray extends StatefulWidget {
  const StickerTray({
    required this.categories,
    required this.emojis,
    this.onPick,
    this.onClose,
    super.key,
  });

  final List<String> categories;
  final List<String> emojis;
  final ValueChanged<String>? onPick;
  final VoidCallback? onClose;

  @override
  State<StickerTray> createState() => _StickerTrayState();
}

class _StickerTrayState extends State<StickerTray> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(top: BorderSide(color: tokens.divider)),
        boxShadow: AppShadows.md,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search + close header.
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: Row(
              children: [
                const Expanded(
                  child: AppSearchBar(hint: 'Search stickers', readOnly: true),
                ),
                if (widget.onClose != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  AppIconButton(
                    icon: AppIcons.close,
                    semanticLabel: 'Close',
                    onPressed: widget.onClose,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
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
                mainAxisSpacing: AppSpacing.xs + 2,
                crossAxisSpacing: AppSpacing.xs + 2,
              ),
              itemCount: widget.emojis.length,
              itemBuilder: (context, i) => GestureDetector(
                onTap: () => widget.onPick?.call(widget.emojis[i]),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tokens.surface2,
                    borderRadius: BorderRadius.circular(_tileRadius),
                  ),
                  child: Text(
                    widget.emojis[i],
                    style: const TextStyle(fontSize: 30),
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
