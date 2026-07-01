import 'package:injectable/injectable.dart';
import 'package:we36/core/services/image_processing_service.dart';
import 'package:we36/core/services/media_upload_service.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/features/compose/domain/create_post_repository.dart';
import 'package:we36/features/compose/domain/models/compose_draft.dart';
import 'package:we36/features/compose/domain/models/media_ref.dart';

/// Orchestrates a full publish (Constitution XI — the use case, not a repo,
/// coordinates the services): for each item resolve bytes → bake+compress →
/// upload; then create the post and cache it. Emits an aggregate [PublishEvent]
/// stream. Idempotent + safe to re-run with the same draft (FR-018/019).
@injectable
class PublishPost {
  const PublishPost(this._library, this._processor, this._uploader, this._repo);

  final PhotoLibraryService _library;
  final ImageProcessingService _processor;
  final MediaUploadService _uploader;
  final CreatePostRepository _repo;

  Stream<PublishEvent> call(
    ComposeDraft draft, {
    UploadCancelToken? cancelToken,
  }) async* {
    final uploaded = <MediaRef>[];
    final count = draft.items.length;

    for (var i = 0; i < count; i++) {
      if (cancelToken?.isCancelled ?? false) return;
      final item = draft.items[i];

      // 1. Resolve full-resolution bytes for the selected asset.
      final bytesResult = await _library.originBytes(
        AssetRef(id: item.assetId, width: item.order, height: item.order),
      );
      final source = bytesResult.valueOrNull;
      if (source == null) {
        yield PublishFailed(bytesResult.failureOrNull!);
        return;
      }

      // 2. Bake edits + compress on a background isolate.
      final bakedResult = await _processor.bake(source: source, edit: item.edit);
      final baked = bakedResult.valueOrNull;
      if (baked == null) {
        yield PublishFailed(bakedResult.failureOrNull!);
        return;
      }

      // 3. Upload (progress reused across retries via a stable key per item).
      var failed = false;
      await for (final event in _uploader.upload(
        bytes: baked,
        idempotencyKey: '${draft.idempotencyKey}-$i',
        itemIndex: i,
        itemCount: count,
        cancelToken: cancelToken,
      )) {
        switch (event) {
          case UploadProgressEvent(:final progress):
            yield PublishProgress(progress.overallFraction);
          case UploadDoneEvent(:final media):
            uploaded.add(media);
          case UploadFailedEvent(:final failure):
            yield PublishFailed(failure);
            failed = true;
        }
      }
      if (failed || (cancelToken?.isCancelled ?? false)) return;
    }

    // 4. Create the post from the uploaded media (writes to the canonical cache).
    final result = await _repo.createPost(
      media: uploaded,
      caption: draft.caption,
      metadata: draft.metadata,
      idempotencyKey: draft.idempotencyKey,
    );
    yield result.fold(PublishSucceeded.new, PublishFailed.new);
  }
}
