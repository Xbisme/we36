import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/stories/own_story_store.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/media_upload_service.dart';
import 'package:we36/features/stories/data/create_story_repository.dart';

/// Display duration of a published photo story segment (clarification Q2).
const int kStoryRealSegmentDurationMs = 5000;

/// Real story-publish seam (`env:['real']`, B#006 stories contract). Uploads the
/// flattened 9:16 image via the shared [MediaUploadService] (presigned direct
/// upload → finalize; images finalize `ready` inline), then `POST /stories`
/// (`{mediaId, audience}`, idempotent). The created segment is mirrored into
/// [OwnStoryStore] with its bytes so the author's own ring renders it instantly
/// and the rail reloads off its change stream (FR-011/FR-012). Retrying with the
/// same idempotency key yields exactly one story (FR-009); a cancel/failure
/// writes nothing (FR-010).
@LazySingleton(as: CreateStoryRepository, env: ['real'])
class RealCreateStoryRepository implements CreateStoryRepository {
  RealCreateStoryRepository(this._upload, this._api, this._ownStories);

  final MediaUploadService _upload;
  final ApiClient _api;
  final OwnStoryStore _ownStories;

  @override
  Future<Result<StorySegment>> publish({
    required Uint8List imageBytes,
    required StoryAudience audience,
    required String idempotencyKey,
    UploadCancelToken? cancelToken,
    void Function(double progress)? onProgress,
  }) async {
    // 1. Upload the flattened image (streamed progress; cancel/fail short-circuit).
    String? mediaId;
    await for (final event in _upload.upload(
      bytes: imageBytes,
      idempotencyKey: idempotencyKey,
      cancelToken: cancelToken,
    )) {
      switch (event) {
        case UploadProgressEvent(:final progress):
          onProgress?.call(progress.fraction);
        case UploadFailedEvent(:final failure):
          return Result.err(failure);
        case UploadDoneEvent(:final media):
          mediaId = media.id;
      }
    }
    // Stream ended without a done event → cancelled mid-flight; write nothing.
    if (mediaId == null) return const Result.err(AppFailure.uploadFailed());

    // 2. Create the story from the uploaded media (idempotent via the key).
    final result = await _api.post<StorySegment>(
      ApiEndpoints.stories,
      idempotencyKey: idempotencyKey,
      body: {'mediaId': mediaId, 'audience': _audienceWire(audience)},
      decode: (data) => _segmentFrom(data as Map<String, dynamic>, audience),
    );

    // 3. Mirror into the own-story ring so it renders instantly from local bytes.
    final segment = result.valueOrNull;
    if (segment != null) _ownStories.add(segment, bytes: imageBytes);
    return result;
  }

  /// Frontend audience → backend `StoryAudience` wire value.
  static String _audienceWire(StoryAudience a) =>
      a == StoryAudience.closeFriends ? 'closeFriends' : 'everyone';

  /// Project the backend `StoryDto` into the own [StorySegment]; the image is
  /// served from the in-memory upload bytes via a `memory://` ref (own ring).
  StorySegment _segmentFrom(Map<String, dynamic> dto, StoryAudience audience) {
    final id = dto['id'] as String;
    final author = dto['author'];
    return StorySegment(
      id: id,
      authorId: author is Map ? (author['id'] as String? ?? 'me') : 'me',
      imageUrl: ownStoryImageUrl(id),
      durationMs: kStoryRealSegmentDurationMs,
      position: 0,
      createdAt:
          DateTime.tryParse(dto['createdAt'] as String? ?? '')?.toUtc() ??
          DateTime.now().toUtc(),
      audience: audience,
    );
  }
}
