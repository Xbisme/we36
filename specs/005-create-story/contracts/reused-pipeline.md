# Contract — Reused pipeline seams (from #007)

These are consumed **as-is**; #005 adds no changes to them. Listed here so the create-story flow's
dependencies are explicit.

## PhotoLibraryService — `lib/core/services/photo_library_service.dart`
Platform seam (device access, env-agnostic). Used for the story pick step.
- `Future<Result<PhotoPermission>> ensurePermission()` — `{granted, limited, denied}`.
- `Future<Result<AssetPage>> loadAssets({required int page, int pageSize})` — paged Recents.
- `ImageProvider thumbnail(AssetRef ref, {int pixelSize})` — bounded-resolution grid cell.
- `Future<Result<Uint8List>> originBytes(AssetRef ref)` — full-res bytes to fit into the 9:16 canvas.
- `Future<void> openSettings()` — recovery after denial (FR-016).

## MediaUploadService — `lib/core/services/media_upload_service.dart`
Backend seam (real/fake). Used to upload the flattened story JPEG.
- `Stream<UploadEvent> upload({required Uint8List bytes, required String idempotencyKey, UploadCancelToken? cancelToken, …})`
  emitting `UploadProgressEvent` → `UploadDoneEvent | UploadFailedEvent`.
- Retries reuse `idempotencyKey` (FR-009). `UploadCancelToken` cancels in flight (FR-008/010).

## image package (#007)
Pure-Dart JPEG re-encode/resize on a background isolate — reused by `StoryImageComposer` for the
off-main encode step. No new dependency.

> The real seams for upload go through the #002 `ApiClient` (idempotency + auth + refresh + redacted
> logging interceptors) and map errors via `FailureMapper`. In `environment:'fake'` the fakes run and
> the whole story flow is zero-network.
