import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/services/photo_library_service_fake.dart';

void main() {
  test('loadVideos returns video assets carrying durationMs', () async {
    final lib = FakePhotoLibraryService()
      ..videoCount = 5
      ..videoDurationMs = 20000;
    final result = await lib.loadVideos(page: 0);
    expect(result.isOk, isTrue);
    final page = result.valueOrNull!;
    expect(page.assets, hasLength(5));
    expect(page.assets.first.durationMs, 20000);
  });

  test('videoBytes returns the configured byte size', () async {
    final lib = FakePhotoLibraryService()..videoByteCount = 1024;
    final result = await lib.videoBytes(
      const AssetRef(id: 'fake-video-0', width: 720, height: 1280),
    );
    expect(result.valueOrNull, hasLength(1024));
  });

  test('loadVideos surfaces permissionDenied', () async {
    final lib = FakePhotoLibraryService()..permission = PhotoPermission.denied;
    final result = await lib.loadVideos(page: 0);
    expect(result.isErr, isTrue);
  });
}
