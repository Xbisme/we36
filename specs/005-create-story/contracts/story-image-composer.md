# Contract — StoryImageComposer (core service)

`lib/core/services/story_image_composer.dart`

Flattens the composed 9:16 canvas (photo + text + sticker overlays) into JPEG bytes that are
pixel-identical to what the user arranged (FR-005, SC-002). Symmetric to the #007
`ImageProcessingService`, but uses a render capture instead of a color matrix because overlays are
free-form widgets (research R1).

## Interface

```dart
class StoryImageComposer {
  /// Capture the RepaintBoundary identified by [boundaryKey] and encode to JPEG.
  /// Output is deterministic [targetWidth] x (targetWidth*16/9) regardless of device DPR.
  Future<Result<Uint8List>> flatten({
    required GlobalKey boundaryKey,
    int targetWidth = 1080,   // → 1080 x 1920
  });
}
```

## Behavior
1. `boundaryKey.currentContext.findRenderObject() as RenderRepaintBoundary`.
2. `boundary.toImage(pixelRatio: targetWidth / boundaryLogicalWidth)` → `ui.Image` → PNG `ByteData`
   (UI isolate; fast raster copy).
3. Re-encode/resize to JPEG on a background isolate via the `image` package (reuse #007 isolate pattern)
   → return `Uint8List`.
4. On capture/encode failure → `Result.err(uploadFailed)` (or a mapped media failure); never throws to
   the cubit.

## Constraints
- Runs the heavy encode off the main isolate (Constitution II — no jank).
- Deterministic output size for stable goldens/tests.
- No bytes/paths logged (FR-019).

## Test double
- A synchronous stub (`FakeStoryImageComposer`) returns fixed bytes without touching the render tree,
  so cubit/widget tests avoid real rasterization (mirrors the #007 synchronous processing stub).
