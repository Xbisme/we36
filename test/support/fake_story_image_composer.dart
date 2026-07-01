import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/story_image_composer.dart';

/// Synchronous test double for [StoryImageComposer] — returns fixed bytes
/// without touching the render tree, so cubit/widget tests avoid real
/// rasterization + `pumpAndSettle` hangs (the #007 lesson). Set [failure] to
/// exercise the flatten-error path.
class FakeStoryImageComposer implements StoryImageComposer {
  FakeStoryImageComposer({this.bytes, this.failure});

  Uint8List? bytes;
  AppFailure? failure;

  int flattenCalls = 0;

  @override
  Future<Result<Uint8List>> flatten({
    required GlobalKey boundaryKey,
    int targetWidth = StoryImageComposer.defaultTargetWidth,
    int quality = StoryImageComposer.defaultQuality,
  }) async {
    flattenCalls++;
    if (failure != null) return Result.err(failure!);
    return Result.ok(bytes ?? Uint8List.fromList(const [1, 2, 3, 4]));
  }
}
