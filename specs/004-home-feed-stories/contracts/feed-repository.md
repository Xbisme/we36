# Contract: FeedRepository

Mirrors backend **B#004** (`GET /feed`, `POST|DELETE /posts/{id}/like`, `POST|DELETE
/posts/{id}/save`). Envelope + cursor reuse the #002 `CursorPage<T>`/`PageRequest`.

## Interface (`core/data/feed/feed_repository.dart`)

```dart
abstract interface class FeedRepository {
  Stream<List<Post>> watchHomeFeed();                                  // canonical reactive read (drift)
  Future<Result<CursorPage<Post>>> loadFirstPage();                    // GET /feed
  Future<Result<CursorPage<Post>>> loadNextPage(String cursor);        // GET /feed?cursor=…
  Future<Result<EngagementState>> toggleLike(String postId, {required bool like});
  Future<Result<EngagementState>> toggleSave(String postId, {required bool save});
}
```

## Endpoints (add to `core/constants/api_endpoints.dart`)

| Constant | Method | Path | Notes |
|---|---|---|---|
| `feed` (exists) | GET | `/feed` | query: `cursor?`, `limit` (≤30, default 20) via `PageRequest.toQuery()` |
| `postLike(id)` | POST | `/posts/{id}/like` | idempotent; returns `EngagementState` |
| `postUnlike(id)` | DELETE | `/posts/{id}/like` | idempotent |
| `postSave(id)` | POST | `/posts/{id}/save` | idempotent; returns `EngagementState` |
| `postUnsave(id)` | DELETE | `/posts/{id}/save` | idempotent |

## Response shapes (from B#004 OpenAPI)

- `GET /feed` → `FeedPage { items: Post[], nextCursor: string|null, hasMore: boolean }`
  → decoded to `CursorPage<Post>`.
- like/save → `EngagementState { postId, likeCount, saveCount, viewerHasLiked, viewerHasSaved }`.
- `Post`, `UserSummary`, `PostMedia`, `Media`, `Place` — see [data-model.md](../data-model.md).

## DTO → domain → cache

1. Decode `FeedPage.items[]` → `Post` (freezed `fromJson`). A malformed item is **skipped** (soft),
   the page still resolves (FR-006).
2. `loadFirstPage`: `PostsDao.clearFeed()` then `upsertAll(items)`. `loadNextPage`: `upsertAll`
   (append; dedupe by `id`).
3. `watchHomeFeed()` reads `PostsDao.watchHomeFeed()` (`ORDER BY createdAt DESC`) — the single render
   source (FR-004/FR-013). `media[0]` image → `mediaImageUrl`; render via `cached_network_image`
   with bounded `cacheWidth` (FR-032).

## Errors

`FailureMapper` (from #002) maps HTTP/transport → `AppFailure` (`offline`/`networkError`/
`serverError`/`timeout`/`notFound`/`forbidden`). `loadMore` soft-fails (keeps items); first-load
error with **no cache** → `error(retry)`; with cache → serve cache + quiet refresh failure.

## Fake (`env:['fake']`, runs in #004)

Deterministic ~30 single-image posts (contract-shaped, `kind:image/status:ready`), paged in two
cursors; writes to drift for the reactive read; `toggleLike/Save` update in-memory + drift and echo
an `EngagementState`; injectable `failNextMutation` for rollback tests.
