import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/services/photo_library_service_fake.dart';

void main() {
  test('granted permission + paginates assets', () async {
    final service = FakePhotoLibraryService(assetCount: 130);

    expect(
      (await service.ensurePermission()).valueOrNull,
      PhotoPermission.granted,
    );

    final first = (await service.loadAssets(
      page: 0,
      pageSize: 50,
    )).valueOrNull!;
    expect(first.assets, hasLength(50));
    expect(first.hasMore, isTrue);

    final last = (await service.loadAssets(page: 2, pageSize: 50)).valueOrNull!;
    expect(last.assets, hasLength(30));
    expect(last.hasMore, isFalse);
  });

  test('denied permission surfaces permissionDenied on load', () async {
    final service = FakePhotoLibraryService(permission: PhotoPermission.denied);
    expect(
      (await service.ensurePermission()).valueOrNull,
      PhotoPermission.denied,
    );
    expect((await service.loadAssets(page: 0)).isErr, isTrue);
  });

  test('thumbnail is a resolvable in-memory provider', () {
    final service = FakePhotoLibraryService();
    final provider = service.thumbnail(
      const AssetRef(id: 'fake-asset-0', width: 1080, height: 1350),
    );
    expect(provider, isA<MemoryImage>());
  });

  test('originBytes returns bytes; undecodable when configured', () async {
    final ok = FakePhotoLibraryService();
    const ref = AssetRef(id: 'fake-asset-0', width: 1080, height: 1350);
    expect((await ok.originBytes(ref)).valueOrNull, isNotEmpty);

    final bad = FakePhotoLibraryService(originDecodable: false);
    expect((await bad.originBytes(ref)).valueOrNull, hasLength(4));
  });
}
