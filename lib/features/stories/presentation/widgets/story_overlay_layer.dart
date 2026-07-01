import 'package:flutter/material.dart';
import 'package:we36/features/stories/domain/models/story_compose_draft.dart';
import 'package:we36/features/stories/presentation/widgets/story_stickers.dart';

/// Renders the draft's text + sticker overlays on top of the 9:16 canvas as
/// draggable, normalized-position children (#005 US2). Overlays are baked into
/// the export by the surrounding `RepaintBoundary` (research R1) — this layer is
/// what the flatten captures, so preview == export (FR-005). Long-press removes.
class StoryOverlayLayer extends StatelessWidget {
  const StoryOverlayLayer({
    required this.draft,
    required this.onMoveText,
    required this.onMoveSticker,
    required this.onRemoveText,
    required this.onRemoveSticker,
    this.onEditText,
    super.key,
  });

  final StoryComposeDraft draft;
  final void Function(String id, double dx, double dy) onMoveText;
  final void Function(String id, double dx, double dy) onMoveSticker;
  final void Function(String id) onRemoveText;
  final void Function(String id) onRemoveSticker;
  final void Function(String id)? onEditText;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        return Stack(
          children: [
            for (final t in draft.textOverlays)
              _DraggableOverlay(
                dx: t.dx,
                dy: t.dy,
                width: w,
                height: h,
                onMove: (dx, dy) => onMoveText(t.id, dx, dy),
                onRemove: () => onRemoveText(t.id),
                onTap: onEditText == null ? null : () => onEditText!(t.id),
                child: _TextChip(text: t.text),
              ),
            for (final s in draft.stickerOverlays)
              _DraggableOverlay(
                dx: s.dx,
                dy: s.dy,
                width: w,
                height: h,
                onMove: (dx, dy) => onMoveSticker(s.id, dx, dy),
                onRemove: () => onRemoveSticker(s.id),
                child: Text(
                  s.assetKey,
                  style: const TextStyle(fontSize: kStoryStickerSize),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _DraggableOverlay extends StatelessWidget {
  const _DraggableOverlay({
    required this.dx,
    required this.dy,
    required this.width,
    required this.height,
    required this.onMove,
    required this.onRemove,
    required this.child,
    this.onTap,
  });

  final double dx;
  final double dy;
  final double width;
  final double height;
  final void Function(double dx, double dy) onMove;
  final VoidCallback onRemove;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      // Center the child at the normalized (dx, dy) fraction of the canvas.
      alignment: Alignment(dx * 2 - 1, dy * 2 - 1),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onRemove,
        onPanUpdate: (details) {
          if (width <= 0 || height <= 0) return;
          onMove(dx + details.delta.dx / width, dy + details.delta.dy / height);
        },
        child: child,
      ),
    );
  }
}

class _TextChip extends StatelessWidget {
  const _TextChip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
