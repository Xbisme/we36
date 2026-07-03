import 'package:injectable/injectable.dart';
import 'package:we36/core/data/feed/post.dart' show MediaKind;
import 'package:we36/core/data/reels/reel.dart';
import 'package:we36/core/data/reels/reels_repository.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/services/media_upload_service.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/features/reels/domain/reel_draft.dart';

/// One publish lifecycle event for the reel compose flow.
sealed class ReelPublishEvent {
  const ReelPublishEvent();
}

class ReelPublishProgress extends ReelPublishEvent {
  const ReelPublishProgress(this.fraction);
  final double fraction;
}

class ReelPublishSucceeded extends ReelPublishEvent {
  const ReelPublishSucceeded(this.reel);
  final Reel reel;
}

class ReelPublishFailed extends ReelPublishEvent {
  const ReelPublishFailed(this.failure);
  final AppFailure failure;
}

/// Orchestrates a reel publish (Constitution XI — the use case coordinates the
/// services): resolve the video bytes → validate the 150 MB cap → upload (reuse
/// the #007 [MediaUploadService], stable key ⇒ idempotent) → create the reel via
/// [ReelsRepository] (optimistic top-of-feed insert). Emits a [ReelPublishEvent]
/// stream; safe to re-run with the same draft (FR-019/020).
@injectable
class PublishReel {
  const PublishReel(this._library, this._uploader, this._reels);

  final PhotoLibraryService _library;
  final MediaUploadService _uploader;
  final ReelsRepository _reels;

  Stream<ReelPublishEvent> call(
    ReelDraft draft, {
    UploadCancelToken? cancelToken,
  }) async* {
    // 1. Resolve the raw video bytes for the picked asset.
    final bytesResult = await _library.videoBytes(
      AssetRef(id: draft.videoAssetId, width: 0, height: 0),
    );
    final bytes = bytesResult.valueOrNull;
    if (bytes == null) {
      yield ReelPublishFailed(bytesResult.failureOrNull!);
      return;
    }
    // 2. Enforce the file-size cap (duration is enforced at pick, FR-017).
    if (bytes.length > kReelMaxBytes) {
      yield const ReelPublishFailed(AppFailure.mediaTooLarge());
      return;
    }
    if (cancelToken?.isCancelled ?? false) return;

    // 3. Upload the video (stable idempotency key across retries).
    String? mediaId;
    var failed = false;
    await for (final event in _uploader.upload(
      bytes: bytes,
      idempotencyKey: '${draft.idempotencyKey}-video',
      kind: MediaKind.video,
      cancelToken: cancelToken,
    )) {
      switch (event) {
        case UploadProgressEvent(:final progress):
          yield ReelPublishProgress(progress.fraction);
        case UploadDoneEvent(:final media):
          mediaId = media.id;
        case UploadFailedEvent(:final failure):
          yield ReelPublishFailed(failure);
          failed = true;
      }
    }
    if (failed || (cancelToken?.isCancelled ?? false) || mediaId == null) {
      return;
    }

    // 4. Create the reel (writes optimistically to the canonical cache).
    final result = await _reels.createReel(
      videoMediaId: mediaId,
      clientKey: draft.idempotencyKey,
      caption: draft.caption,
      commentsDisabled: draft.commentsDisabled,
      locationName: draft.locationName,
      taggedUserIds: draft.taggedUserIds,
    );
    yield result.fold(ReelPublishSucceeded.new, ReelPublishFailed.new);
  }
}
