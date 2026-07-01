import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

/// Flattens the composed 9:16 story canvas (photo + text + sticker overlays)
/// into JPEG bytes that are **pixel-identical** to what the user arranged
/// (#005, FR-005/SC-002). Because overlays are free-form widgets, it captures
/// the actual render tree via [RepaintBoundary] (research R1) rather than
/// re-drawing — the WYSIWYG guarantee. The heavy JPEG re-encode runs on a
/// background isolate (Constitution II). Env-agnostic (rendering is orthogonal
/// to the fake/real backend axis), like `ImageProcessingService`.
@lazySingleton
class StoryImageComposer {
  const StoryImageComposer();

  /// Target export width — produces a deterministic [targetWidth] × 16/9 image
  /// regardless of device DPR, keeping goldens/tests stable and memory bounded.
  static const int defaultTargetWidth = 1080;

  /// Default JPEG quality for the export encode.
  static const int defaultQuality = 90;

  /// Capture the [RepaintBoundary] identified by [boundaryKey] and encode JPEG.
  Future<Result<Uint8List>> flatten({
    required GlobalKey boundaryKey,
    int targetWidth = defaultTargetWidth,
    int quality = defaultQuality,
  }) async {
    final renderObject = boundaryKey.currentContext?.findRenderObject();
    if (renderObject is! RenderRepaintBoundary) {
      return const Result.err(AppFailure.uploadFailed());
    }
    try {
      final logicalWidth = renderObject.size.width;
      final pixelRatio = logicalWidth <= 0 ? 1.0 : targetWidth / logicalWidth;
      final image = await renderObject.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      image.dispose();
      if (byteData == null) {
        return const Result.err(AppFailure.uploadFailed());
      }
      final pngBytes = byteData.buffer.asUint8List();
      final jpeg = await compute(
        _reencodeJpg,
        _EncodeRequest(pngBytes, quality),
      );
      if (jpeg == null) return const Result.err(AppFailure.uploadFailed());
      return Result.ok(jpeg);
    } on Object {
      return const Result.err(AppFailure.uploadFailed());
    }
  }
}

/// Isolate payload — PNG bytes + quality (must be sendable).
@immutable
class _EncodeRequest {
  const _EncodeRequest(this.pngBytes, this.quality);
  final Uint8List pngBytes;
  final int quality;
}

/// Runs on a background isolate: decode the captured PNG, re-encode as JPEG.
/// Returns null on decode failure.
Uint8List? _reencodeJpg(_EncodeRequest req) {
  final decoded = img.decodePng(req.pngBytes);
  if (decoded == null) return null;
  return img.encodeJpg(decoded, quality: req.quality);
}
