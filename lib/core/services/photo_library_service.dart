import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/result.dart';

/// Photo-library permission state (contextual request — Constitution I/VII).
enum PhotoPermission { granted, limited, denied }

/// A device photo reference for the pick grid (our type — no plugin leak).
@immutable
class AssetRef {
  const AssetRef({required this.id, required this.width, required this.height});

  final String id;
  final int width;
  final int height;

  @override
  bool operator ==(Object other) => other is AssetRef && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// One page of device assets.
@immutable
class AssetPage {
  const AssetPage({required this.assets, required this.hasMore});

  final List<AssetRef> assets;
  final bool hasMore;
}

/// Device photo-library access for the custom pick grid (#007). A **platform**
/// seam (not a backend seam): the real impl wraps `photo_manager` and is
/// registered env-agnostically (device access is orthogonal to the fake/real
/// backend axis, like `RealTokenStore`). Tests inject a fake instead.
///
/// v1.0 is gallery-only (Q3) — no capture method; the interface stays
/// capture-source-agnostic so camera can be added later.
abstract interface class PhotoLibraryService {
  /// Request/verify library permission.
  Future<Result<PhotoPermission>> ensurePermission();

  /// A page of "Recents" for the grid (lazy, paginated — Constitution II).
  Future<Result<AssetPage>> loadAssets({required int page, int pageSize});

  /// A bounded-resolution thumbnail provider for a grid cell.
  ImageProvider thumbnail(AssetRef ref, {int pixelSize});

  /// Full-resolution bytes of a selected asset (for edit/upload).
  Future<Result<Uint8List>> originBytes(AssetRef ref);
}

/// Real platform impl over `photo_manager`. Registered for ALL environments —
/// device access is not part of the fake/real backend axis (see contract).
@LazySingleton(as: PhotoLibraryService)
class RealPhotoLibraryService implements PhotoLibraryService {
  RealPhotoLibraryService();

  /// Cache of resolved entities by id so [thumbnail]/[originBytes] can map back
  /// from an [AssetRef] without another async lookup.
  final Map<String, AssetEntity> _entities = {};

  @override
  Future<Result<PhotoPermission>> ensurePermission() async {
    final state = await PhotoManager.requestPermissionExtend();
    if (state.isAuth) return const Result.ok(PhotoPermission.granted);
    if (state.hasAccess) return const Result.ok(PhotoPermission.limited);
    return const Result.ok(PhotoPermission.denied);
  }

  @override
  Future<Result<AssetPage>> loadAssets({
    required int page,
    int pageSize = 60,
  }) async {
    final paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );
    if (paths.isEmpty) {
      return const Result.ok(AssetPage(assets: [], hasMore: false));
    }
    final album = paths.first;
    final entities = await album.getAssetListPaged(page: page, size: pageSize);
    final assets = <AssetRef>[];
    for (final e in entities) {
      _entities[e.id] = e;
      assets.add(AssetRef(id: e.id, width: e.width, height: e.height));
    }
    final total = await album.assetCountAsync;
    return Result.ok(
      AssetPage(assets: assets, hasMore: (page + 1) * pageSize < total),
    );
  }

  @override
  ImageProvider thumbnail(AssetRef ref, {int pixelSize = 256}) {
    final entity = _entities[ref.id];
    if (entity == null) return const AssetImage('assets/brand/we36_mark.png');
    return AssetEntityImageProvider(
      entity,
      isOriginal: false,
      thumbnailSize: ThumbnailSize.square(pixelSize),
    );
  }

  @override
  Future<Result<Uint8List>> originBytes(AssetRef ref) async {
    final entity = _entities[ref.id];
    if (entity == null) return const Result.err(AppFailure.notFound());
    final bytes = await entity.originBytes;
    if (bytes == null) return const Result.err(AppFailure.unsupportedMedia());
    return Result.ok(bytes);
  }
}
