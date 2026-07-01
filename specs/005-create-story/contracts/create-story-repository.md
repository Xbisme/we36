# Contract — CreateStoryRepository (backend seam)

`lib/features/stories/data/create_story_repository.dart`

Owns uploading the flattened story image and persisting the resulting own segment. Bound by DI:
`env:['fake']` (runs, offline) and `env:['real']` (inert until backend). Never called repo→repo — the
`PublishStory` use case invokes it after `StoryImageComposer.flatten`.

## Interface

```dart
abstract interface class CreateStoryRepository {
  /// Upload [imageBytes] (a flattened 9:16 JPEG) and create one story segment.
  /// [idempotencyKey] is reused across retries so a retry never duplicates (FR-009).
  /// [onProgress] emits 0..1 upload progress; [cancelToken] cancels in flight (FR-008).
  Future<Result<StorySegment>> publish({
    required Uint8List imageBytes,
    required StoryAudience audience,
    required String idempotencyKey,
    UploadCancelToken? cancelToken,
    void Function(double progress)? onProgress,
  });
}
```

## Behavior

| Aspect | Fake (`env:['fake']`, runs) | Real (`env:['real']`, inert) |
|---|---|---|
| Upload | drives `FakeMediaUploadService` progress stream to completion (or fail/cancel hooks) | `MediaUploadService` real → `ApiClient` multipart; idempotency via #002 interceptor |
| Create | keep flattened JPEG bytes in `OwnStoryStore`, `imageUrl = memory://<id>`; synthesize `StorySegment`(author=fake `Me`, `durationMs:5000`, `createdAt:now()`, `audience`, that `imageUrl`) and `OwnStoryStore.add(segment, bytes:)` | POST story-create endpoint (constant added, inert); server returns the media URL |
| Return | `Result.ok(segment)` | returns `Result.err(unsupported)` / documented until backend lands |
| Cancel | stops the stream, writes nothing (FR-010) | `cancelToken` → dio cancel, no write |
| Retry | same `idempotencyKey` ⇒ exactly one `OwnStoryStore` entry (dedupe by key) | server idempotency |

## Guarantees
- No partial/orphan segment on cancel or failure (FR-010, SC-005).
- Idempotent: N retries of one compose session ⇒ ≤1 segment (FR-009, SC-004).
- No media bytes/paths logged; only status/size metadata (FR-019).

## Test coverage
- Fake progress → success writes to `OwnStoryStore`; cancel writes nothing; fail returns `uploadFailed`
  and writes nothing; double `publish` with same key ⇒ one segment.
