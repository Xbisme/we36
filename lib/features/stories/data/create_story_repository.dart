import 'dart:typed_data';

import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/media_upload_service.dart';

/// Backend seam for publishing a story (#005). Owns uploading the flattened
/// 9:16 image and persisting the resulting own segment. Bound by DI:
/// `env:['fake']` (runs, offline) and `env:['real']` (inert until a backend
/// stories contract exists). Never called repo→repo — the `PublishStory` use
/// case invokes it after the composer flattens the canvas.
// ignore: one_member_abstracts — an interface (not a typedef) so DI binds a real/fake impl.
abstract interface class CreateStoryRepository {
  /// Upload [imageBytes] (a flattened 9:16 JPEG) and create one story segment.
  /// [idempotencyKey] is reused across retries so a retry never duplicates
  /// (FR-009). [onProgress] emits 0..1 upload progress; [cancelToken] cancels
  /// an in-flight publish (FR-008/FR-010).
  Future<Result<StorySegment>> publish({
    required Uint8List imageBytes,
    required StoryAudience audience,
    required String idempotencyKey,
    UploadCancelToken? cancelToken,
    void Function(double progress)? onProgress,
  });
}
