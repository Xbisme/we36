import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/services/media_upload_service.dart';
import 'package:we36/core/services/media_upload_service_fake.dart';

void main() {
  final bytes = Uint8List.fromList(List<int>.filled(1000, 1));

  test('emits progress then a done event with a media ref', () async {
    final service = FakeMediaUploadService()..stepDelay = Duration.zero;
    final events = await service
        .upload(bytes: bytes, idempotencyKey: 'k1')
        .toList();

    expect(events.whereType<UploadProgressEvent>(), isNotEmpty);
    final done = events.last;
    expect(done, isA<UploadDoneEvent>());
    expect((done as UploadDoneEvent).media.id, contains('k1'));
    // Progress reaches 1.0 for the item.
    final lastProgress = events.whereType<UploadProgressEvent>().last;
    expect(lastProgress.progress.fraction, 1.0);
  });

  test('failAfterFraction emits a failure and no done event', () async {
    final service = FakeMediaUploadService()
      ..stepDelay = Duration.zero
      ..failAfterFraction = 0.5;
    final events = await service
        .upload(bytes: bytes, idempotencyKey: 'k2')
        .toList();

    expect(events.last, isA<UploadFailedEvent>());
    expect(events.whereType<UploadDoneEvent>(), isEmpty);
    expect(service.completedCount, 0);
  });

  test('cancel stops the upload before completion', () async {
    final service = FakeMediaUploadService()
      ..stepDelay = const Duration(milliseconds: 5);
    final token = UploadCancelToken();
    final events = <UploadEvent>[];
    final sub = service
        .upload(bytes: bytes, idempotencyKey: 'k3', cancelToken: token)
        .listen(events.add);
    token.cancel();
    await sub.asFuture<void>();
    await sub.cancel();

    expect(events.whereType<UploadDoneEvent>(), isEmpty);
    expect(service.completedCount, 0);
  });

  test(
    'same idempotency key yields the same media id (dedupe on retry)',
    () async {
      final service = FakeMediaUploadService()..stepDelay = Duration.zero;
      final first = await service
          .upload(bytes: bytes, idempotencyKey: 'same')
          .toList();
      final second = await service
          .upload(bytes: bytes, idempotencyKey: 'same')
          .toList();

      final id1 = (first.last as UploadDoneEvent).media.id;
      final id2 = (second.last as UploadDoneEvent).media.id;
      expect(id1, id2);
    },
  );
}
