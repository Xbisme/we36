import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/features/compose/domain/models/media_ref.dart';

/// Cooperative cancel signal for an in-flight upload (kept dio-free so the
/// interface stays transport-agnostic; the real impl bridges to a dio token).
class UploadCancelToken {
  bool _cancelled = false;
  bool get isCancelled => _cancelled;
  void cancel() => _cancelled = true;
}

/// One upload lifecycle event (progress → done | failed) — Result-friendly.
sealed class UploadEvent {
  const UploadEvent();
}

class UploadProgressEvent extends UploadEvent {
  const UploadProgressEvent(this.progress);
  final UploadProgress progress;
}

class UploadDoneEvent extends UploadEvent {
  const UploadDoneEvent(this.media);
  final MediaRef media;
}

class UploadFailedEvent extends UploadEvent {
  const UploadFailedEvent(this.failure);
  final AppFailure failure;
}

/// Uploads already-processed image bytes and reports progress (FR-016/017).
///
/// The caller (PublishPost use case) bakes+compresses via `ImageProcessingService`
/// first, then hands the bytes here — keeping this service single-responsibility
/// and reusable by #005/#006. Retries reuse `idempotencyKey` so no duplicate
/// media is created (FR-018).
// ignore: one_member_abstracts — an interface (not a typedef) so DI can bind a real/fake impl.
abstract interface class MediaUploadService {
  Stream<UploadEvent> upload({
    required Uint8List bytes,
    required String idempotencyKey,
    int itemIndex = 0,
    int itemCount = 1,
    UploadCancelToken? cancelToken,
  });
}

/// Real seam (B#007) — never exercised while the app runs `fake`. Uploads a
/// multipart body via the shared `ApiClient`; the idempotency key is attached by
/// the #002 idempotency interceptor. True chunked/streamed progress is finalized
/// at the B#007 cutover; until then it emits start→done around the request.
@LazySingleton(as: MediaUploadService, env: ['real'])
class RealMediaUploadService implements MediaUploadService {
  RealMediaUploadService(this._api);

  final ApiClient _api;

  @override
  Stream<UploadEvent> upload({
    required Uint8List bytes,
    required String idempotencyKey,
    int itemIndex = 0,
    int itemCount = 1,
    UploadCancelToken? cancelToken,
  }) async* {
    yield UploadProgressEvent(
      UploadProgress(
        sentBytes: 0,
        totalBytes: bytes.length,
        itemIndex: itemIndex,
        itemCount: itemCount,
      ),
    );
    if (cancelToken?.isCancelled ?? false) return;

    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: 'upload.jpg'),
    });
    final result = await _api.post<MediaRef>(
      ApiEndpoints.media,
      body: form,
      decode: (json) => MediaRef.fromJson(json as Map<String, dynamic>),
      idempotent: true,
    );
    yield result.fold(
      UploadDoneEvent.new,
      UploadFailedEvent.new,
    );
  }
}
