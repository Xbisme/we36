import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:injectable/injectable.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/features/compose/domain/models/filter_matrices.dart';
import 'package:we36/features/compose/domain/models/media_edit_state.dart';

/// Bakes a photo's per-item edit (crop + filter + adjustments) into upload-ready
/// JPEG bytes and compresses/resizes it — all on a background isolate so the UI
/// never janks (Constitution II). Pure-Dart (`image` package), env-agnostic (R3/R4).
///
/// The color transform uses the SAME 4x5 matrix as the live preview
/// (`FilterMatrices.resolve`) so the baked result matches what the user saw.
@lazySingleton
class ImageProcessingService {
  const ImageProcessingService();

  /// Default upload width — bounded so large originals don't bloat the upload.
  static const int defaultTargetWidth = 1080;

  /// Default JPEG quality for the upload encode.
  static const int defaultQuality = 85;

  /// Bake [source] under [edit] into resized, matrix-applied JPEG bytes.
  ///
  /// Returns [AppFailure.unsupportedMedia] if the bytes cannot be decoded.
  Future<Result<Uint8List>> bake({
    required Uint8List source,
    required MediaEditState edit,
    int targetWidth = defaultTargetWidth,
    int quality = defaultQuality,
  }) async {
    final request = _BakeRequest(
      source: source,
      matrix: FilterMatrices.resolve(edit),
      cropLeft: edit.cropRect?.left,
      cropTop: edit.cropRect?.top,
      cropWidth: edit.cropRect?.width,
      cropHeight: edit.cropRect?.height,
      targetWidth: targetWidth,
      quality: quality,
    );
    final result = await compute(_bakeInIsolate, request);
    if (result == null) return const Result.err(AppFailure.unsupportedMedia());
    return Result.ok(result);
  }
}

/// Isolate payload — primitives + bytes only (must be sendable).
@immutable
class _BakeRequest {
  const _BakeRequest({
    required this.source,
    required this.matrix,
    required this.cropLeft,
    required this.cropTop,
    required this.cropWidth,
    required this.cropHeight,
    required this.targetWidth,
    required this.quality,
  });

  final Uint8List source;
  final List<double> matrix;
  final double? cropLeft;
  final double? cropTop;
  final double? cropWidth;
  final double? cropHeight;
  final int targetWidth;
  final int quality;
}

/// Runs on a background isolate via [compute]. Returns null on decode failure.
Uint8List? _bakeInIsolate(_BakeRequest req) {
  img.Image? image;
  try {
    image = img.decodeImage(req.source);
  } on Object {
    return null; // Malformed / unsupported bytes → caller maps to unsupportedMedia.
  }
  if (image == null) return null;

  // 1. Crop (normalized rect → pixels), if a crop was set.
  if (req.cropWidth != null && req.cropHeight != null) {
    final x = ((req.cropLeft ?? 0) * image.width).round().clamp(
      0,
      image.width - 1,
    );
    final y = ((req.cropTop ?? 0) * image.height).round().clamp(
      0,
      image.height - 1,
    );
    final w = (req.cropWidth! * image.width).round().clamp(1, image.width - x);
    final h = (req.cropHeight! * image.height).round().clamp(
      1,
      image.height - y,
    );
    image = img.copyCrop(image, x: x, y: y, width: w, height: h);
  }

  // 2. Resize down to the bounded upload width (never upscale).
  if (image.width > req.targetWidth) {
    image = img.copyResize(image, width: req.targetWidth);
  }

  // 3. Apply the 4x5 color matrix per pixel (matches the preview).
  _applyMatrix(image, req.matrix);

  // 4. Encode JPEG at the target quality.
  return img.encodeJpg(image, quality: req.quality);
}

/// Applies a 4x5 color matrix [m] in place. Layout matches Flutter's
/// `ColorFilter.matrix` (RGBA rows, last column is the constant offset).
void _applyMatrix(img.Image image, List<double> m) {
  for (final p in image) {
    final r = p.r.toDouble();
    final g = p.g.toDouble();
    final b = p.b.toDouble();
    final a = p.a.toDouble();
    p
      ..r = (m[0] * r + m[1] * g + m[2] * b + m[3] * a + m[4]).clamp(0, 255)
      ..g = (m[5] * r + m[6] * g + m[7] * b + m[8] * a + m[9]).clamp(0, 255)
      ..b = (m[10] * r + m[11] * g + m[12] * b + m[13] * a + m[14]).clamp(
        0,
        255,
      )
      ..a = (m[15] * r + m[16] * g + m[17] * b + m[18] * a + m[19]).clamp(
        0,
        255,
      );
  }
}
