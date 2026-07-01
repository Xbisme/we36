import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/cache/app_database.dart';
import 'package:we36/core/data/stories/own_story_store.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/media_upload_service.dart';
import 'package:we36/features/stories/data/create_story_repository.dart';

/// Display duration of a published photo story segment (clarification Q2).
const int kStorySegmentDurationMs = 5000;

/// In-memory publish (the one that runs in `fake` mode). Drives the fake upload
/// for progress/cancel/fail, then synthesizes a [StorySegment] (author = the
/// cached current user), keeps its flattened bytes in [OwnStoryStore] (`memory://`
/// ref so the viewer can render it offline — U1), and dedupes on the idempotency
/// key so a retry never creates a duplicate (FR-009/SC-004). A cancel or failure
/// writes nothing (FR-010).
@LazySingleton(as: CreateStoryRepository, env: ['fake'])
class FakeCreateStoryRepository implements CreateStoryRepository {
  FakeCreateStoryRepository(this._upload, this._db, this._ownStories);

  final MediaUploadService _upload;
  final AppDatabase _db;
  final OwnStoryStore _ownStories;

  final Map<String, StorySegment> _created = {};

  @override
  Future<Result<StorySegment>> publish({
    required Uint8List imageBytes,
    required StoryAudience audience,
    required String idempotencyKey,
    UploadCancelToken? cancelToken,
    void Function(double progress)? onProgress,
  }) async {
    // Idempotency: a retry with the same key returns the same segment (no dupe).
    final existing = _created[idempotencyKey];
    if (existing != null) return Result.ok(existing);

    var uploaded = false;
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
        case UploadDoneEvent():
          uploaded = true;
      }
    }
    // Stream ended without a done event → cancelled mid-flight. Write nothing,
    // leave no partial story (FR-010); the cubit treats a cancelled token as a
    // silent cancel (no failure toast).
    if (!uploaded) return const Result.err(AppFailure.uploadFailed());

    final me = await _db.meProfileDao.get();
    final id = 'story-$idempotencyKey';
    final segment = StorySegment(
      id: id,
      authorId: me?.id ?? 'me',
      imageUrl: ownStoryImageUrl(id),
      durationMs: kStorySegmentDurationMs,
      position: 0,
      createdAt: DateTime.now().toUtc(),
      audience: audience,
    );
    _ownStories.add(segment, bytes: imageBytes);
    _created[idempotencyKey] = segment;
    return Result.ok(segment);
  }
}
