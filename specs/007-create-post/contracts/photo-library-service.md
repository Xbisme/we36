# Contract: PhotoLibraryService (`lib/core/services/photo_library_service.dart`)

Device photo-library access for the custom pick grid. A **platform** seam (not a backend seam):
the real impl wraps `photo_manager` and is env-agnostic (like `RealTokenStore` in #003); tests inject
a fake so widget tests run without a device.

```dart
abstract interface class PhotoLibraryService {
  /// Request/verify library permission (contextual — Constitution I/VII).
  Future<Result<PhotoPermission>> ensurePermission();

  /// Recents (or a named album) paged for the grid.
  Future<Result<AssetPage>> loadAssets({required int page, int pageSize = 60});

  /// A bounded-resolution thumbnail provider for grid cells (Constitution II).
  ImageProvider thumbnail(AssetRef ref, {int pixelSize});

  /// Resolve full-resolution bytes for the editor/upload of a selected asset.
  Future<Result<Uint8List>> originBytes(AssetRef ref);
}

class AssetRef { final String id; final int width; final int height; }
class AssetPage { final List<AssetRef> assets; final bool hasMore; }
enum PhotoPermission { granted, limited, denied }
```

## Behavior

- `ensurePermission()` calls `PhotoManager.requestPermissionExtend()`; `denied`/`limited` surface an
  explanatory grid state with a settings CTA (FR-007) — never a crash.
- `loadAssets` pages "Recents" via `getAssetListPaged` (Constitution II — lazy, paginated).
- `thumbnail` returns an `AssetEntityImage` provider sized to the grid cell (bounded decode).
- **v1.0 is gallery-only** (Q3): no capture method on this interface; it stays capture-source-agnostic
  so camera can be added later without changing consumers.
- **No paths logged** (FR-024).

## Real (platform, env-agnostic)

Wraps `photo_manager` + `photo_manager_image_provider`. Registered for all DI environments (device
access is orthogonal to the fake/real backend axis). iOS `NSPhotoLibraryUsageDescription`; Android 13+
`READ_MEDIA_IMAGES`.

## Fake (test injection)

Yields a deterministic set of `AssetRef`s backed by bundled test asset images and a synthetic
`ImageProvider`, so `GalleryCubit` + pick-page widget/golden tests run headless (Constitution XII).
