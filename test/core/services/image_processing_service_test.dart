import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/image_processing_service.dart';
import 'package:we36/features/compose/domain/models/media_edit_state.dart';

/// A solid-color JPEG of [w]x[h] to feed the baker.
Uint8List _solid(int w, int h, int r, int g, int b) {
  final image = img.Image(width: w, height: h);
  img.fill(image, color: img.ColorRgb8(r, g, b));
  return Uint8List.fromList(img.encodeJpg(image));
}

void main() {
  const service = ImageProcessingService();

  test('original filter: resizes down to the bounded width, keeps color', () async {
    final source = _solid(2000, 2500, 200, 100, 50); // wider than target
    final result = await service.bake(
      source: source,
      edit: MediaEditState.initial(),
      targetWidth: 800,
    );

    expect(result, isA<Ok<Uint8List>>());
    final baked = img.decodeImage(result.valueOrNull!)!;
    expect(baked.width, 800); // resized down
    final px = baked.getPixel(10, 10);
    // Roughly the source color (JPEG is lossy — allow tolerance).
    expect((px.r - 200).abs() < 25, isTrue);
    expect((px.g - 100).abs() < 25, isTrue);
  });

  test('mono filter bakes to grayscale (r≈g≈b)', () async {
    final source = _solid(200, 250, 200, 100, 50);
    final result = await service.bake(
      source: source,
      edit: MediaEditState.initial().copyWith(filter: FilterPreset.mono),
    );

    final baked = img.decodeImage(result.valueOrNull!)!;
    final px = baked.getPixel(20, 20);
    expect((px.r - px.g).abs() < 8, isTrue);
    expect((px.g - px.b).abs() < 8, isTrue);
  });

  test('undecodable bytes → unsupportedMedia failure', () async {
    final result = await service.bake(
      source: Uint8List.fromList([1, 2, 3, 4]),
      edit: MediaEditState.initial(),
    );
    expect(result.isErr, isTrue);
  });
}
