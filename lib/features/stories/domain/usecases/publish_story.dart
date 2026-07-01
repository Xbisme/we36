import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/media_upload_service.dart';
import 'package:we36/features/stories/data/create_story_repository.dart';

/// Publishes a flattened story image (#005). The compose cubit flattens the
/// 9:16 canvas via `StoryImageComposer`, then hands the bytes here; this seam
/// uploads + persists via [CreateStoryRepository] (idempotent, cancelable). No
/// repo→repo — orchestration stays in the presentation/use-case layer
/// (Constitution XI).
@injectable
class PublishStory {
  const PublishStory(this._repo);

  final CreateStoryRepository _repo;

  Future<Result<StorySegment>> call({
    required Uint8List imageBytes,
    required StoryAudience audience,
    required String idempotencyKey,
    UploadCancelToken? cancelToken,
    void Function(double progress)? onProgress,
  }) => _repo.publish(
    imageBytes: imageBytes,
    audience: audience,
    idempotencyKey: idempotencyKey,
    cancelToken: cancelToken,
    onProgress: onProgress,
  );
}
