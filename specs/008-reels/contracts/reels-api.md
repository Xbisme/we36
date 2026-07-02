# Contract: Reels API (client view of B#007)

The backend contract already exists (`backend/src/modules/reels/`). This is the **client-consumed** subset the `ReelsRepository` real seam targets. All paths under `/v1` (the `ApiClient` base). Envelope = shared `{items,nextCursor,hasMore}` / error `{error:{code,message,details?}}` → `AppFailure` (Constitution VIII). Endpoint strings live in `ApiEndpoints` — never inline (Constitution VIII).

## Endpoints

| Method | Path | Body / Query | Returns | Client use |
|---|---|---|---|---|
| GET | `/reels` | `cursor?`, `limit` (def 20, max 30) | `CursorPage<ReelDto>` | feed page fetch (reverse-chron, ready-only) |
| GET | `/reels/:id` | — | `ReelDto` | single reel (author-visible while processing); readiness reconcile |
| POST | `/reels` | `CreateReelDto` + `Idempotency-Key` header | `ReelDto` (201) | publish; optimistic top-insert |
| DELETE | `/reels/:id` | — | 204 | delete own reel (soft) |
| POST | `/reels/:id/like` | — | `EngagementStateDto` (200) | optimistic like |
| DELETE | `/reels/:id/like` | — | `EngagementStateDto` (200) | optimistic unlike |
| POST | `/reels/:id/save` | — | `EngagementStateDto` (200) | optimistic save |
| DELETE | `/reels/:id/save` | — | `EngagementStateDto` (200) | optimistic unsave |
| GET | `/reels/:id/comments` | `cursor?`, `limit` | `CommentPageDto` | reel comments (delegates to B#005) |
| POST | `/reels/:id/comments` | `CreateCommentDto` | `CommentDto` (201) | comment/reply on reel |

## DTO shapes (client mapping)

### ReelDto → `Reel`
`id, author(UserSummaryDto→UserSummary), caption?, video(MediaDto→Media), location?(PlaceDto→Place), hashtags[], taggedUsers[], commentsDisabled, likeCount, saveCount, commentCount, viewerHasLiked, viewerHasSaved, isVideoReady, createdAt`

### MediaDto (video) → `Media`
`id, kind(=video), status(ready|processing|failed), width?, height?, durationMs?, variants{ renditions[](single video rendition), poster?, thumbnail? }?, failureReason?, createdAt`. Variants present only when `status=ready`.

### CreateReelDto ← `ReelDraft`
`{ videoMediaId (uuid, required), caption?, location?(PlaceInput), taggedUserIds?(uuid[]), commentsDisabled?(default false) }` + header `Idempotency-Key: <draft.idempotencyKey>`.
Server validates: media owned by caller, `kind=video`, `status ∈ {ready,processing}` → else `VALIDATION`/`NOT_FOUND`.

### EngagementStateDto → `EngagementState`
`{ postId, likeCount, saveCount, viewerHasLiked, viewerHasSaved }` (reels are Posts kind=reel on the server → `postId` == reel id).

### CommentDto / CommentPageDto → reuse #006 `Comment` / `CursorPage<Comment>`
Identical to B#005 comments. Reel comment ordering is newest-first on the backend alias; the client comment surface reuses the #006 cubit.

## Error codes → `AppFailure` (via `FailureMapper`, existing)
`NOT_FOUND` → `notFound` · `VALIDATION` → `validation`/`mediaTooLarge`/`unsupportedMedia` (create) · `FORBIDDEN` → `forbidden` · `RATE_LIMITED` → `rateLimited` · auth/refresh handled by the existing auth interceptor. No new mapping code expected (codes are contract-stable).

## Fake seam (what ships in #008, `env:['fake']`)
`FakeReelsRepository` synthesizes deterministic reels (using bundled/sample video URLs or poster-only for CI), supports optimistic like/save + `failNextMutation` test seam (mirrors `FakeFeedRepository`), and on `createReel` inserts a `isVideoReady:false` reel then flips to `true` after a simulated delay (R8). Reel comments in fake mode reuse `FakeCommentsRepository` keyed by reel id (target-agnostic). App runs zero-network on fakes (FR-029).

## New `ApiEndpoints` entries
```
reels                      => '/reels'                  // GET feed / POST create
reel(String id)            => '/reels/$id'              // GET one / DELETE
reelLike(String id)        => '/reels/$id/like'         // POST / DELETE
reelSave(String id)        => '/reels/$id/save'         // POST / DELETE
reelComments(String id)    => '/reels/$id/comments'     // GET / POST
```
