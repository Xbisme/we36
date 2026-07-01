import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_sticker_overlay.freezed.dart';

/// A sticker from the small fixed bundled set placed on the 9:16 story canvas
/// (#005). Position is normalized (0..1); baked into the exported image at
/// publish (R1/FR-005). [assetKey] indexes `assets/stickers/` (see T027).
@freezed
abstract class StoryStickerOverlay with _$StoryStickerOverlay {
  const factory StoryStickerOverlay({
    required String id,
    required String assetKey,
    @Default(0.5) double dx,
    @Default(0.5) double dy,
  }) = _StoryStickerOverlay;
}
