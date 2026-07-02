import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/feed/post.dart' show MediaKind;
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/services/media_upload_service.dart';
import 'package:we36/features/compose/domain/models/media_ref.dart';

/// In-memory upload (the one that runs in `fake` mode). Emits deterministic
/// progress ticks then a synthesized [MediaRef]. Test hooks let a test force a
/// failure or a slow upload to exercise progress / cancel / retry (US4).
@LazySingleton(as: MediaUploadService, env: ['fake'])
class FakeMediaUploadService implements MediaUploadService {
  FakeMediaUploadService();

  /// If set (0..1), the upload emits progress up to this fraction then fails.
  double? failAfterFraction;

  /// Delay per progress step — tests may set 0 for instant completion.
  Duration stepDelay = const Duration(milliseconds: 1);

  /// Number of progress ticks emitted before completion.
  int steps = 4;

  int _counter = 0;

  @override
  Stream<UploadEvent> upload({
    required Uint8List bytes,
    required String idempotencyKey,
    MediaKind kind = MediaKind.image,
    String? contentType,
    int itemIndex = 0,
    int itemCount = 1,
    UploadCancelToken? cancelToken,
  }) async* {
    final total = bytes.isEmpty ? 1 : bytes.length;
    for (var i = 1; i <= steps; i++) {
      if (cancelToken?.isCancelled ?? false) return;
      await Future<void>.delayed(stepDelay);
      final fraction = i / steps;
      yield UploadProgressEvent(
        UploadProgress(
          sentBytes: (total * fraction).round(),
          totalBytes: total,
          itemIndex: itemIndex,
          itemCount: itemCount,
        ),
      );
      if (failAfterFraction != null && fraction >= failAfterFraction!) {
        yield const UploadFailedEvent(AppFailure.uploadFailed());
        return;
      }
    }
    if (cancelToken?.isCancelled ?? false) return;
    // Deterministic media id derived from the idempotency key (dedupe on retry).
    yield UploadDoneEvent(
      MediaRef(
        id: 'fake-media-$idempotencyKey-$itemIndex',
        width: 1080,
        height: 1350,
      ),
    );
    _counter++;
  }

  /// How many uploads have completed (for idempotency assertions in tests).
  int get completedCount => _counter;
}
