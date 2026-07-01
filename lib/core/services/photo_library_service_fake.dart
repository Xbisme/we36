import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';
import 'package:we36/core/services/photo_library_service.dart';

/// Deterministic in-memory photo library for tests (Constitution XII) — no
/// device, no plugin. NOT registered in DI: the real impl is env-agnostic, so
/// tests inject this manually. Configurable permission / asset count / decode
/// failure to exercise the pick grid, permission, and edge-case paths.
class FakePhotoLibraryService implements PhotoLibraryService {
  FakePhotoLibraryService({
    this.assetCount = 24,
    this.permission = PhotoPermission.granted,
    this.originDecodable = true,
  });

  int assetCount;
  PhotoPermission permission;

  /// When false, [originBytes] returns undecodable bytes (unsupportedMedia path).
  bool originDecodable;

  Uint8List? _solid;

  Uint8List get _bytes => _solid ??= Uint8List.fromList(
    img.encodeJpg(img.fill(img.Image(width: 64, height: 80), color: img.ColorRgb8(200, 100, 60))),
  );

  @override
  Future<Result<PhotoPermission>> ensurePermission() async =>
      Result.ok(permission);

  @override
  Future<Result<AssetPage>> loadAssets({
    required int page,
    int pageSize = 60,
  }) async {
    if (permission == PhotoPermission.denied) {
      return const Result.err(AppFailure.permissionDenied());
    }
    final start = page * pageSize;
    if (start >= assetCount) {
      return const Result.ok(AssetPage(assets: [], hasMore: false));
    }
    final end = (start + pageSize).clamp(0, assetCount);
    final assets = [
      for (var i = start; i < end; i++)
        AssetRef(id: 'fake-asset-$i', width: 1080, height: 1350),
    ];
    return Result.ok(AssetPage(assets: assets, hasMore: end < assetCount));
  }

  @override
  ImageProvider thumbnail(AssetRef ref, {int pixelSize = 256}) =>
      MemoryImage(_bytes);

  @override
  Future<Result<Uint8List>> originBytes(AssetRef ref) async {
    if (!originDecodable) {
      return Result.ok(Uint8List.fromList([1, 2, 3, 4])); // undecodable
    }
    return Result.ok(_bytes);
  }
}
