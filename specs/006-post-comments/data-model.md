# Data Model — Post Detail & Comments (#006)

Phase 1. Client-side entities for the comment surface. All are freezed immutables with `fromJson` (camelCase, UUIDv7 ids), matching the B#004 `Post`/`UserSummary` conventions. **No drift table** is added — comments are transient/paginated; only the existing canonical `Post` is cached and mutated.

## Entity: Comment (`core/data/comments/comment.dart`)

One entry in a post's conversation (top-level comment or a one-level reply).

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | Server id (UUIDv7). For a pending optimistic entry this is a temporary local id until reconciled. |
| `postId` | `String` | The post this belongs to. |
| `author` | `CommentAuthor` | Compact author projection (see below). |
| `text` | `String` | Comment body, ≤ **2,200** chars (FR-013). May contain `@mentions` / `#hashtags` (styled, non-tappable). |
| `createdAt` | `DateTime` | For relative-time display; drives oldest-first ordering. |
| `likeCount` | `int` | Number of likes on this comment. |
| `viewerHasLiked` | `bool` | Whether the current viewer liked it. |
| `parentId` | `String?` | `null` = top-level; otherwise the **top-level** comment id this reply belongs to (one level only — a reply-to-a-reply reuses the ancestor's id). |
| `replyCount` | `int` | Top-level only: number of replies (drives "View N replies"). `0` for replies. |
| `isOwn` | `bool` | Viewer owns this comment → Delete (else Report) in the action sheet. |
| `pending` | `bool` (default `false`) | Client-only: optimistic entry not yet confirmed (renders muted/no like control). Not serialized. |
| `clientKey` | `String?` | Client-only: UUIDv7 idempotency key; reconciles the confirmed entry to its optimistic placeholder. Not serialized. |

**Derived / rules**:
- `isReply => parentId != null`.
- Optimistic factory `Comment.optimistic({postId, author, text, parentId, clientKey})` → `pending: true`, `likeCount: 0`, `viewerHasLiked: false`, temp `id`.
- Ordering: within a group (top-level list, or a parent's replies) sorted by `createdAt` ascending; a new optimistic entry appends at the end.
- Nesting invariant: no comment may have `parentId` pointing at a comment that itself has a `parentId` (enforced when composing a reply — see R4).

## Entity: CommentAuthor (`core/data/comments/comment.dart`)

Reuses the shape of #004 `UserSummary` (kept as a distinct projection so the comments slice does not depend on feed internals): `id`, `username?`, `displayName?`, `avatarUrl?`, `isVerified`.

## Value object: CommentPage

`CursorPage<Comment>` from #002 (`items` + `nextCursor` + `hasMore`). No new type — the shared envelope carries a page of top-level comments (or of a parent's replies).

## Value object: ReplyContext (Cubit state only, not serialized)

Held in `CommentsState` while composing a reply: `{ parentId: String, replyingToHandle: String }`. `null` when composing a top-level comment. Cleared on cancel or after a successful reply.

## Entity: Post (existing — `core/data/feed/post.dart`)

Unchanged shape. This feature **reads** `commentsDisabled` (hide input, FR-012) and **reads/updates** `commentCount` (FR-015). The count is mutated only through the canonical cached row via `FeedRepository.applyCommentCountDelta`. No fields added.

## Repository interface (`core/data/comments/comments_repository.dart`)

```
abstract interface class CommentsRepository {
  Future<Result<CursorPage<Comment>>> loadComments(String postId, {String? cursor, int limit});
  Future<Result<CursorPage<Comment>>> loadReplies(String parentId, {String? cursor, int limit});
  Future<Result<Comment>> addComment(String postId, {required String text, String? parentId, required String clientKey});
  Future<Result<CommentEngagement>> toggleCommentLike(String commentId, {required bool like});
  Future<Result<void>> deleteComment(String commentId);   // cascade for a parent
  Future<Result<void>> reportComment(String commentId);   // surface-only ack
}
```

`CommentEngagement` = `{ likeCount: int, viewerHasLiked: bool }` (target-state reconcile, mirrors the feed `EngagementState`).

## State: CommentsState (`features/post/presentation/cubit/comments_state.dart`)

Freezed 4-state (extended variants prefix the base name), wrapping/augmenting the paginated list:

- `CommentsInitial`
- `CommentsLoading`
- `CommentsLoaded { List<Comment> comments; String? nextCursor; bool hasMore; ReplyContext? replyContext; bool commentsDisabled; }`
- `CommentsLoadedPaginating { …loaded fields… }` (load-more in flight; soft-failure keeps items)
- `CommentsError(AppFailure)` (first-load failure only; with retry)

Mutations (add/reply/like/delete) operate on the `comments` list inside a `Loaded*` state (optimistic insert/replace/remove); transient failures surface via a listener-driven Toast without dropping the loaded list.

## Lifecycle / transitions

1. Open detail → `CommentsInitial → CommentsLoading → CommentsLoaded | CommentsError`.
2. Scroll near end + `hasMore` → `CommentsLoaded → CommentsLoadedPaginating → CommentsLoaded` (append; soft-fail returns to `Loaded` keeping items + Toast).
3. Add/reply → insert `pending` Comment + optimistic `commentCount +1` → confirm (replace pending, real id) or fail (remove + `-1` + Toast).
4. Like a comment → flip `viewerHasLiked`/`likeCount` immediately → reconcile to returned target-state, or revert + Toast; rapid toggles settle to last intent.
5. Delete own → confirm dialog → remove comment (+ its replies if top-level) + `commentCount -(1+replyCount)` → revert on failure.
6. Report other → action sheet → ack Toast (no state change).
7. `commentsDisabled` post → `CommentsLoaded.commentsDisabled = true` → input hidden; existing comments still render.
</content>
