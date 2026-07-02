# Contract — Comments API (#006)

Client-side view of the B#comments contract the real `CommentsRepository` targets, plus the fake's guaranteed behavior. Envelope + error conventions follow #002: success `data`, error `{error:{code,message,details}}` mapped by `FailureMapper` → `AppFailure`; cursor pagination via `CursorPage<T>` (`{items, nextCursor, hasMore}`); mutations carry a client `Idempotency-Key`. All ids are UUIDv7. Endpoint strings live in `core/constants/api_endpoints.dart` (no inline literals).

## Endpoints

| Method | Path | Purpose | Idempotent |
|---|---|---|---|
| GET | `/posts/{postId}/comments?cursor=&limit=` | Top-level comments, **oldest-first** | (read) |
| GET | `/comments/{commentId}/replies?cursor=&limit=` | Replies of one top-level comment (one level) | (read) |
| POST | `/posts/{postId}/comments` | Add a comment or reply | via `Idempotency-Key` |
| POST | `/comments/{commentId}/like` | Like the comment | yes (target-state) |
| DELETE | `/comments/{commentId}/like` | Unlike the comment | yes (target-state) |
| DELETE | `/comments/{commentId}` | Delete own comment (cascade for a parent) | yes (no-op if gone) |
| POST | `/comments/{commentId}/report` | Report a comment (surface-only) | yes |

### GET comments / replies

Query: `cursor?` (opaque), `limit` (default ~20, aligned with feed). Response `data`:
```json
{ "items": [Comment, …], "nextCursor": "…|null", "hasMore": true }
```
`Comment` JSON: `{ id, postId, author: UserSummary, text, createdAt, likeCount, viewerHasLiked, parentId|null, replyCount, isOwn }`. Comments returned **ascending by `createdAt`**. `replies` returns entries whose `parentId == {commentId}`.

### POST comment / reply

Headers: `Idempotency-Key: <uuidv7>`. Body:
```json
{ "text": "string ≤ 2200", "parentId": "topLevelCommentId | null" }
```
Response `data`: the created `Comment`. **Idempotency**: a retry with the same key returns the same comment (never a duplicate — FR-007/SC-003). Server sets `parentId` to the top-level ancestor even if the client passed a reply's id (one-level guarantee); the client also normalizes this before sending (R4).

Errors: `VALIDATION` (empty/too long → should be prevented client-side, FR-013), `NOT_FOUND` (post/parent gone), `FORBIDDEN` (`commentsDisabled`).

### POST/DELETE like

Target-state toggle (like post like/save). Response `data`: `{ "likeCount": int, "viewerHasLiked": bool }` (`CommentEngagement`). Repeated same-direction calls are no-ops returning the current state.

### DELETE comment

Only the owner may delete (server-enforced; client shows Delete only when `isOwn`). Deleting a **top-level** comment cascade-removes its replies. Response `data`: `{ "deletedCount": int }` = `1 + replyCount` (drives the canonical `commentCount` decrement — clarify Q3). No-op (`deletedCount: 0`) if already gone.

### POST report

Body `{ "reason": "string?" }` (optional; MVP sends none). Response `data`: `{ "accepted": true }`. **No enforcement / content change** — acknowledged only (FR-011). Real moderation is #014.

## Fake repository behavior (`env:['fake']`, the one that runs)

The `FakeCommentsRepository` MUST, with **zero network**:
- Seed a deterministic in-memory conversation per seeded post: a mix of top-level comments (some with 1–3 replies), varied `createdAt` (ascending), some `isOwn:true`, some `viewerHasLiked:true`, and at least one post with **many** comments to prove pagination and one with **zero** (empty state).
- `loadComments`/`loadReplies`: page ascending by `createdAt` with a working `nextCursor`/`hasMore`.
- `addComment`: record `clientKey`; a repeat key returns the same stored comment (exactly-once). Assign a server-style id + `createdAt`. Return the created `Comment`; normalize `parentId` to the top-level ancestor.
- `toggleCommentLike`: flip and return `CommentEngagement`; same-direction repeat is a no-op.
- `deleteComment`: remove the comment (and, for a top-level, its replies); return `deletedCount`. Own-only.
- `reportComment`: return accepted; no state change.
- Expose a hook to **simulate a failure** (for rollback/idempotent-retry tests): the first attempt fails, a retry with the same key succeeds and yields exactly one comment.
- **NOT responsible for the canonical `Post.commentCount`.** The `CommentsRepository` (real + fake) only owns comments; it MUST NOT touch the post cache. The **`AddComment` / `DeleteComment` use cases** are the single owner of the count delta — they call `FeedRepository.applyCommentCountDelta` on a confirmed add (`+1`) / delete (`-(1+replyCount)`) so feed + detail stay consistent (SC-005) with no double-count (plan R3). This keeps `core/data/comments` free of a repo→repo dependency.

## Consistency guarantees (map to Success Criteria)

- Retry-with-same-key ⇒ exactly one comment (SC-003).
- Failed add/like/delete ⇒ list + `commentCount` restored (SC-004).
- `commentCount` shown in feed and detail always match (SC-005).
- Replies never exceed one level (SC-007).
- Every call works offline against the fake (SC-006).
</content>
