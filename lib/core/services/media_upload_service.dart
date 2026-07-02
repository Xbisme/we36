import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/constants/api_endpoints.dart';
import 'package:we36/core/data/api/api_client.dart';
import 'package:we36/core/data/feed/post.dart' show MediaKind;
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

/// Uploads already-processed media bytes and reports progress (#007/#008).
///
/// The caller (`PublishPost` / `PublishReel` use case) resolves the bytes first
/// (image: baked+compressed; video: the picked file), then hands them here. The
/// real impl speaks the backend's **presigned direct-upload** contract; the
/// interface exposes only bytes + `kind` so callers stay transport-agnostic.
// ignore: one_member_abstracts — an interface (not a typedef) so DI can bind a real/fake impl.
abstract interface class MediaUploadService {
  Stream<UploadEvent> upload({
    required Uint8List bytes,
    required String idempotencyKey,
    MediaKind kind = MediaKind.image,
    String? contentType,
    int itemIndex = 0,
    int itemCount = 1,
    UploadCancelToken? cancelToken,
  });
}

/// Real seam (B#003 presigned direct upload):
/// 1. `POST /media/uploads` → an upload ticket (`mediaId` + presigned `uploadUrl`
///    + `method` + `headers`);
/// 2. `PUT` the bytes **straight to object storage** at `uploadUrl` (never
///    through the API — scalable large-video uploads, Constitution II);
/// 3. `POST /media/:id/finalize` → enqueues processing.
/// Returns a [MediaRef] carrying the `mediaId` for post/reel create. The
/// `mediaId` is stable per ticket; retrying create with the same idempotency key
/// still yields exactly one post/reel.
@LazySingleton(as: MediaUploadService, env: ['real'])
class RealMediaUploadService implements MediaUploadService {
  RealMediaUploadService(this._api);

  final ApiClient _api;

  /// A bare dio for the presigned PUT — no app interceptors (no auth token /
  /// idempotency header on the object-storage request).
  final Dio _storage = Dio();

  @override
  Stream<UploadEvent> upload({
    required Uint8List bytes,
    required String idempotencyKey,
    MediaKind kind = MediaKind.image,
    String? contentType,
    int itemIndex = 0,
    int itemCount = 1,
    UploadCancelToken? cancelToken,
  }) {
    final controller = StreamController<UploadEvent>();
    unawaited(
      _run(
        controller,
        bytes: bytes,
        kind: kind,
        contentType: contentType ?? _defaultContentType(kind),
        itemIndex: itemIndex,
        itemCount: itemCount,
        cancelToken: cancelToken,
      ),
    );
    return controller.stream;
  }

  Future<void> _run(
    StreamController<UploadEvent> out, {
    required Uint8List bytes,
    required MediaKind kind,
    required String contentType,
    required int itemIndex,
    required int itemCount,
    UploadCancelToken? cancelToken,
  }) async {
    try {
      final total = bytes.isEmpty ? 1 : bytes.length;

      // 1. Request a presigned upload ticket.
      if (cancelToken?.isCancelled ?? false) return;
      final ticketResult = await _api.post<_UploadTicket>(
        ApiEndpoints.mediaUploads,
        body: {
          'kind': kind.name,
          'contentType': contentType,
          'byteSize': bytes.length,
        },
        decode: (data) => _UploadTicket.fromJson(data as Map<String, dynamic>),
      );
      final ticket = ticketResult.valueOrNull;
      if (ticket == null) {
        out.add(UploadFailedEvent(ticketResult.failureOrNull!));
        return;
      }

      out.add(
        UploadProgressEvent(
          UploadProgress(
            sentBytes: 0,
            totalBytes: total,
            itemIndex: itemIndex,
            itemCount: itemCount,
          ),
        ),
      );

      // 2. PUT the bytes straight to object storage (with progress).
      if (cancelToken?.isCancelled ?? false) return;
      await _storage.putUri<void>(
        Uri.parse(ticket.uploadUrl),
        data: Stream<List<int>>.value(bytes),
        options: Options(
          method: ticket.method,
          headers: {
            ...ticket.headers,
            Headers.contentLengthHeader: bytes.length,
          },
        ),
        onSendProgress: (sent, _) => out.add(
          UploadProgressEvent(
            UploadProgress(
              sentBytes: sent,
              totalBytes: total,
              itemIndex: itemIndex,
              itemCount: itemCount,
            ),
          ),
        ),
      );

      // 3. Finalize → enqueues processing.
      if (cancelToken?.isCancelled ?? false) return;
      final finalizeResult = await _api.post<void>(
        ApiEndpoints.mediaFinalize(ticket.mediaId),
        decode: (_) {},
      );
      if (finalizeResult.isErr) {
        out.add(UploadFailedEvent(finalizeResult.failureOrNull!));
        return;
      }

      out.add(UploadDoneEvent(MediaRef(id: ticket.mediaId)));
    } on DioException catch (_) {
      out.add(const UploadFailedEvent(AppFailure.uploadFailed()));
    } on Object catch (e) {
      out.add(UploadFailedEvent(AppFailure.unknown(error: e)));
    } finally {
      await out.close();
    }
  }

  static String _defaultContentType(MediaKind kind) =>
      kind == MediaKind.video ? 'video/mp4' : 'image/jpeg';
}

/// The presigned upload ticket (`POST /media/uploads` result).
class _UploadTicket {
  const _UploadTicket({
    required this.mediaId,
    required this.uploadUrl,
    required this.method,
    required this.headers,
  });

  factory _UploadTicket.fromJson(Map<String, dynamic> json) => _UploadTicket(
    mediaId: json['mediaId'] as String,
    uploadUrl: json['uploadUrl'] as String,
    method: (json['method'] as String?) ?? 'PUT',
    headers: ((json['headers'] as Map?) ?? const {}).map(
      (k, v) => MapEntry(k.toString(), v.toString()),
    ),
  );

  final String mediaId;
  final String uploadUrl;
  final String method;
  final Map<String, String> headers;
}
