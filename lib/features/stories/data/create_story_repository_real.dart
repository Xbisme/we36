import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/media_upload_service.dart';
import 'package:we36/features/stories/data/create_story_repository.dart';

/// **Provisional** real story-publish seam (`env:['real']`). No backend stories
/// contract exists yet (backend has auth/posts/media/comments only), so publish
/// returns a safe failure. Registered for DI-graph completeness; never exercised
/// while the app runs `fake`. When a backend stories spec lands, this uploads via
/// the shared `MediaUploadService` + `ApiClient` and POSTs the create-story
/// endpoint (`ApiEndpoints.stories`), returning the server segment.
@LazySingleton(as: CreateStoryRepository, env: ['real'])
class RealCreateStoryRepository implements CreateStoryRepository {
  const RealCreateStoryRepository();

  @override
  Future<Result<StorySegment>> publish({
    required Uint8List imageBytes,
    required StoryAudience audience,
    required String idempotencyKey,
    UploadCancelToken? cancelToken,
    void Function(double progress)? onProgress,
  }) async => const Result.err(
    AppFailure.unknown(message: 'stories backend contract not available yet'),
  );
}
