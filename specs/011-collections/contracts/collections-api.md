# Collections API Contract (client-consumed subset of B#011)

> **✅ RECONCILED with the shipped backend (2026-07-07).** The client (`api_endpoints.dart`, `collections_remote_data_source.dart`, `collections_repository_impl.dart`) was aligned to the actual B#011 controller after end-to-end testing. Success responses are **not** wrapped (`{ items, nextCursor, hasMore }` at top level; single objects returned bare). **Actual endpoints** (all under `/v1`):
> | Capability | Actual route | Notes |
> |---|---|---|
> | Saved pile ("All saved") | `GET /me/saved` | `CursorPage<SavedItemDto>`; `SavedItemDto == ExploreItem` shape |
> | List collections | `GET /me/collections` | `CursorPage<CollectionDto>` |
> | Create | `POST /me/collections` `{name}` | 201 → `CollectionDto` |
> | Get / rename / delete | `GET`/`PATCH`/`DELETE /collections/:id` | **not** under `/me`; delete → 204 |
> | Collection items | `GET /collections/:id/items` | `CursorPage<SavedItemDto>` |
> | Add item | `POST /collections/:id/items` `{postId}` | **204** (auto-saves the post) |
> | Remove item | `DELETE /collections/:id/items/:postId` | 204 (does not unsave) |
> | Full unsave | `DELETE /posts/:id/save` (#004) | cascades to all collections |
>
> **`CollectionDto`** = `{ id, name, itemCount, cover: MediaDto|null, createdAt, updatedAt }` — cover is a single server-**derived** `MediaDto` (mapped to one client cover ref); no `isDefault` on the wire (named collections only; "All saved" is a client-side virtual view).
>
> **Three deviations from this spec** (backend wins — update the spec at leisure): (1) collection **names ARE unique per owner** (case-insensitive) — create/rename on a dup → `409`/validation, not silently allowed; (2) **no set-cover endpoint** — cover is auto-derived from the newest visible item, so the "Set as cover" UI was dropped; (3) **no per-post membership endpoint** — the Save-to-collection sheet files **additively** (checkmarks don't reflect existing membership). Per-collection cap + name length come from server config.
>
> The rest of this file is the original **derived** draft, kept for history. **The table above is authoritative.**

Shared DTO fragments (already shipped): `ExploreItemDto` → `ExploreItem` (`{ kind:"post"|"reel", post?/reel? }`), `MediaDto` → `Media`. The canonical **save toggle** (`POST`/`DELETE /posts/{id}/save`) is the shipped #004 endpoint reused as-is.

---

## 1. List my collections — `GET /me/collections`

The person's named collections (the client prepends the synthetic **"All saved"** default; the server need not return it).

**Response `data`** (`List<SavedCollection>`; collections are few — non-paginated, or a `CursorPage` if the backend prefers):
```json
[
  { "id": "col_food", "name": "Food", "itemCount": 23,
    "coverRefs": ["https://…/1.webp","https://…/2.webp","https://…/3.webp","https://…/4.webp"],
    "isDefault": false, "updatedAt": "2026-07-06T10:00:00.000Z" }
]
```
- `coverRefs` = up to 4 thumbnail URLs (owner-set cover first, else recent items); may be `[]`.
- The default "All saved" is **not** a stored collection (R1) — its `itemCount` comes from the saved-count (below) and its items from `GET /me/saved`.

## 2. "All saved" items — `GET /me/saved`

Every post/reel the person has saved (the canonical `viewerHasSaved` set), newest-first. Cursor-paginated.

**Response** `CursorPage<ExploreItem>`:
```json
{ "data": [ { "kind":"post", "post": { … } }, { "kind":"reel", "reel": { … } } ],
  "meta": { "nextCursor": "…", "totalCount": 57 } }
```
- `totalCount` (if provided) seeds the default card's "N saved"; otherwise the client uses the first page's `meta`.

## 3. Collection items — `GET /me/collections/{id}/items`

One named collection's saved items. Cursor-paginated `CursorPage<ExploreItem>` (same shape as §2; reels marked). `404 NOT_FOUND` if the collection was deleted.

## 4. Create a collection — `POST /me/collections`

Idempotent (client `Idempotency-Key`). Names **need not be unique** — a duplicate name is accepted (never `409` on name).

**Request**: `{ "name": "Travel" }`

**Response `data`** (the created `SavedCollection`, empty). A retry with the same key returns the same collection (exactly one — SC-004).

## 5. Rename / set cover — `PATCH /me/collections/{id}`

Partial update. `name` (≤50, non-empty, non-unique) and/or `coverItemId` (a saved post id to use as the cover).

**Request**: `{ "name": "Trips" }` or `{ "coverItemId": "post_123" }`

**Response `data`**: the updated `SavedCollection` (new `name`/`coverRefs`). `400`/`4xx` (e.g. empty/too-long name) → `AppFailure` → inline error + rollback.

## 6. Delete a collection — `DELETE /me/collections/{id}`

Removes the collection **without unsaving its posts** (they remain in "All saved" — SC-006). `204`. The canonical `viewerHasSaved` of member posts is unaffected. Idempotent (deleting an absent collection → no-op/`204`).

## 7. File / unfile a post — `POST` / `DELETE /me/collections/{id}/items/{postId}`

Membership toggle. Idempotent (client `Idempotency-Key`).

- `POST` → add `postId` to collection `{id}`; **if the post was not saved, this also sets the canonical saved flag** (server-side, or the client composes `POST /posts/{id}/save` first — reconcile). No-op if already a member.
- `DELETE` → remove `postId` from collection `{id}` (membership only; the post stays saved in "All saved" and other collections). No-op if not a member.

**Response `data`**: the affected `SavedCollection` (updated `itemCount`/`coverRefs`), so the card reconciles.

## 8. A post's memberships — `GET /me/saved/{postId}/collections`

Powers the **Save-to-collection** sheet (which collections contain this post) and the **full-unsave confirm** gate (whether it is in ≥1 named collection — R4).

**Response `data`**:
```json
{ "isSaved": true, "collectionIds": ["col_food", "col_trips"] }
```
- `collectionIds` excludes the default (the default is derivable from `isSaved`).

## 9. Full unsave — `DELETE /posts/{id}/save`  *(existing #004)*

The shipped canonical unsave. Cascades server-side: removes the post from **all** collections and from "All saved"; `viewerHasSaved=false` propagates via the `Posts` cache to every surface (SC-007). The client gates this behind a confirm dialog when §8 shows the post is in ≥1 named collection (FR-008 / R4).

---

## Error codes consumed (mapped by `FailureMapper`)

| HTTP / `code` | `AppFailure` | Client behavior |
|---|---|---|
| `404 NOT_FOUND` | `notFound` | Collection deleted/missing → drop it from the grid; empty/error state on its detail. |
| `400 INVALID_NAME` | `validation` | Inline name error (empty/too long); block create/rename save. |
| `401 SESSION_EXPIRED` | (single-flight refresh) | Handled by the shared interceptor. |
| `409` (any) | `conflict` | Surface as Toast + rollback (names never 409 — non-unique). |
| network/timeout | `offline`/`timeout` | Optimistic rollback + Toast; the Saved grid falls back to the drift v8 cache (FR-012). |

## Notes

- **"All saved" is virtual** (R1): no create/rename/delete/set-cover; its items = `GET /me/saved`; its count = the saved-count.
- The **canonical saved flag** is `Post.viewerHasSaved` (#004) — #011 adds no second flag; §7 `POST` and §9 keep it in sync.
- Whether §7 `POST` auto-saves an unsaved post or the client must call `POST /posts/{id}/save` first is the **one behavior to confirm** with the shipped backend; the fake implements the auto-save composition.
