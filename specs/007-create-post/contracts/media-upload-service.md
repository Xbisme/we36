# Contract: MediaUploadService (`lib/core/services/media_upload_service.dart`)

Reusable client-side media pipeline (bake → compress → upload) with progress + cancel. Consumed by
compose now; reusable by #005/#006. Real seam uses `ApiClient`; fake runs zero-network.

```dart
/// Uploads one processed image and reports progress.
abstract interface class MediaUploadService {
  /// Bakes edits + compresses [item] (via ImageProcessingService), then uploads.
  /// Emits progress; completes with the server media reference.
  /// [idempotencyKey] is reused across retries so no duplicate media is created.
  Stream<UploadEvent> upload({
    required SelectedMediaItem item,
    required String idempotencyKey,
    required CancelToken cancelToken,
  });
}

/// Progress tick | success | failure (a Result-friendly event).
sealed class UploadEvent {
  const UploadEvent();
}
class UploadProgressEvent extends UploadEvent { final UploadProgress progress; }
class UploadDoneEvent extends UploadEvent { final MediaRef media; }        // {id, url, width, height}
class UploadFailedEvent extends UploadEvent { final AppFailure failure; }  // uploadFailed/offline/…
```

## Behavior

- **Compress before upload** (Constitution II): bake color matrix + resize + `encodeJpg(quality)` on a
  background isolate (`ImageProcessingService`), then multipart-upload the bytes via `ApiClient`.
- **Progress**: forward `dio` `onSendProgress` as `UploadProgressEvent` (fraction 0..1) (FR-017).
- **Cancel**: honor `cancelToken`; a cancelled upload creates no media and no post (FR-017).
- **In-session resume/retry only** (FR-018a): retry re-invokes `upload(...)` with the **same**
  `idempotencyKey`; no persistent background queue survives app-kill.
- **Idempotency** (FR-018, Constitution IX): the `idempotencyKey` is attached (the #002 idempotency
  interceptor already forwards it) so retries don't duplicate.
- **No secrets/paths logged** (FR-024): log upload lifecycle by media index/size only — never paths or
  bytes.

## Real (`env:['real']`)

Uploads through `ApiClient` to `ApiEndpoints.media` (multipart). Maps HTTP → `AppFailure` via
`FailureMapper`. Chunked/multipart per the B#007 contract.

## Fake (`env:['fake']`, runs)

Emits deterministic `UploadProgressEvent`s (e.g. 0→1 in fixed steps), then `UploadDoneEvent` with a
synthesized `MediaRef`. Injectable hooks: `failAfterFraction`, `cancelable`, `latencyPerStep` — so
tests exercise progress, cancel, failure, and retry branches without a network.
