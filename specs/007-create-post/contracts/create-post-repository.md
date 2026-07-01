# Contract: CreatePostRepository (`lib/features/compose/`)

Orchestrates a full publish: upload every media item (via `MediaUploadService`), create the post, and
write it into the canonical #004 `Posts` cache. Returns `Result<Post>`.

```dart
/// domain/create_post_repository.dart
abstract interface class CreatePostRepository {
  /// Publishes [draft]: uploads all items, creates the post, caches it at feed top.
  /// Emits progress across the whole draft; completes with the created Post or a failure.
  /// Idempotent via draft.idempotencyKey — safe to retry after failure (FR-018).
  Stream<PublishEvent> publish(ComposeDraft draft, {required CancelToken cancelToken});
}

sealed class PublishEvent { const PublishEvent(); }
class PublishProgress extends PublishEvent { final UploadProgress progress; } // aggregate across items
class PublishSucceeded extends PublishEvent { final Post post; }
class PublishFailed extends PublishEvent { final AppFailure failure; }
```

## Behavior

- Uploads items sequentially (bounded peak memory for carousels, Constitution II), aggregating
  progress across the draft.
- On all-uploaded, calls create-post (`POST /posts`) with media ids + caption + `PostMetadata` +
  `idempotencyKey`.
- **On success**: inserts the created `Post` into the `Posts` drift table at feed-top so
  `watchHomeFeed()` repaints (FR-020, one canonical representation — Constitution IX). Emits
  `PublishSucceeded`.
- **On failure**: emits `PublishFailed` with a mapped `AppFailure`; **no** partial post is cached.
  Retry re-runs `publish` with the same `idempotencyKey` → exactly one post (FR-018/019, SC-003).
- Orchestration lives in a **use case** (`PublishPost`), not a repo→repo call (Constitution XI).

## Real (`env:['real']`)

Wraps `MediaUploadService(real)` + `ApiClient` create-post; maps errors via `FailureMapper`; writes to
`PostsDao`. Follows the B#007 `POST /posts` contract; request/response isolated in `data/dtos/`.

## Fake (`env:['fake']`, runs)

Wraps `MediaUploadService(fake)`; synthesizes a `Post` from the draft (author = current fake `Me`),
writes it to `PostsDao` so the running app shows the new post at feed top end-to-end. Honors the same
idempotency + failure/cancel hooks for tests.
