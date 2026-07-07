# Phase 1 Data Model: Saved Collections (#011)

Client-side domain models for `core/data/collections/` (+ the reused shipped models). All new models are freezed; DTOs deserialize from the B#011 envelope (`contracts/collections-api.md`). **One drift table is added** (`SavedCollections`, schema v7→v8) — the canonical collections list; the canonical **saved boolean** stays `Post.viewerHasSaved` (#004 `Posts` cache). Item grids ("All saved" + per-collection) are live cursor pages (not persisted).

## Reused (shipped — unchanged)

| Model | Source | Role in #011 |
|---|---|---|
| `Post` | `core/data/feed` (#004) | Canonical content + **`viewerHasSaved`/`saveCount`** — the one saved flag #011 toggles (via `FeedRepository.save`). Watched by every surface for cross-consistency (SC-007). |
| `ExploreItem` | `core/data/discovery` (#009) | Kind-tagged `Post`\|`Reel` — the item-grid cell for "All saved" and every collection (reels marked). |
| `DiscoveryGrid` / `DiscoveryGridTile` | `features/explore` (#009) | The uniform 3-col grid + static tile reused verbatim for collection item grids. |
| `CursorPage<T>` | `core/domain` (#002) | Envelope for "All saved" + per-collection item pages. |
| `PaginatedListCubit<T>` | `core/domain` (#002) | Base for the collection-detail item grid. |
| `ProfileTabBar` / `ProfileTab` | `features/profile` (#010) | Extended `posts|tagged` → **`+saved`** (owner-only). |

## New models (`core/data/collections/`)

### SavedCollection

One collection card (a named collection, or the synthetic "All saved" default).

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | Server id; the synthetic default uses the sentinel `all`. |
| `name` | `String` | Display name; non-empty, ≤50 chars. Not unique per owner. For the default it is the localized "All saved". |
| `itemCount` | `int` | "N saved"; non-negative. For the default = total saved count. |
| `coverRefs` | `List<String>` | Up to 4 thumbnail refs for the quilt cover (owner-set cover first, else recent items). May be empty (empty-cover placeholder). |
| `isDefault` | `bool` | True only for the "All saved" virtual view (not renamable/deletable — FR-003). |
| `updatedAt` | `DateTime` | For ordering + reconcile; UTC. |

- **Derivations**: `canManage => !isDefault`; `isEmpty => itemCount == 0`; `coverCount => coverRefs.length.clamp(0,4)`.
- **Validation**: `id` non-empty; `name` non-empty after trim and ≤50 chars; `itemCount >= 0`; at most 4 `coverRefs`; exactly one collection per owner has `isDefault == true`.

### PostCollectionsMembership (picker view model — not persisted)

The state the **Save-to-collection** sheet needs for one post: which collections it is in, so the person can toggle membership.

| Field | Type | Notes |
|---|---|---|
| `postId` | `String` | The post/reel being filed. |
| `isSaved` | `bool` | Canonical `Post.viewerHasSaved` (filing an unsaved post also saves it). |
| `collections` | `List<PickerRow>` | Each = `{ collection: SavedCollection, contains: bool }`. |

- `namedMembershipCount => collections.where((r) => r.contains && !r.collection.isDefault).length` — drives the **full-unsave confirm** gate (FR-008 / R4).

## Drift table (schema v7 → v8)

### SavedCollections (`core/data/cache/tables/saved_collections_table.dart`)

The one canonical collections list, cached for offline cold-start (FR-012). Reactive `watchCollections()` feeds `CollectionsCubit`.

| Column | Type | Notes |
|---|---|---|
| `id` | text (PK) | Server id (`all` for the default). |
| `name` | text | |
| `itemCount` | int | |
| `coverRefs` | text | JSON-encoded `List<String>` (≤4). |
| `isDefault` | bool | |
| `updatedAt` | datetime | ordering + reconcile. |
| `position` | int | render order (default first, then server order). |

- **DAO** (`saved_collections_dao.dart`): `watchCollections() → Stream<List<SavedCollection>>` (ordered by `position`), `upsertAll(List)`, `deleteById(id)`, `clearUserScoped()` (logout wipe — FR-015).
- **Migration v7→v8**: `createTable(savedCollections)` only (additive; no data backfill; existing tables untouched). Matches the #004/#007/#008/#009 additive-migration pattern.
- **Not cached**: item grids, "All saved" contents, and per-post memberships (live cursor / on-demand — R2).

## Cubit states (freezed 4-state)

| Cubit | States (base + extended) |
|---|---|
| `CollectionsCubit` (Saved tab) | `initial` / `loading` / `loaded(List<SavedCollection>, isOffline)` / `error` — watches the drift v8 cache; background reconcile from `GET /me/collections` + saved-count for the default. |
| `CollectionDetailCubit` | `initial` / `loading` / `loaded(SavedCollection, CursorPage<ExploreItem> items, hasMore)` / `error` — over `PaginatedListCubit`; `id=all` → `GET /me/saved`. Handles remove-from-collection. |
| `SaveToCollectionCubit` | `initial` / `loading` / `loaded(PostCollectionsMembership, creating)` / `error` — file/unfile + create-inline; drives the unsave-confirm gate. |
| `CollectionEditCubit` | `initial` / `editing(name, saving)` / `error` (thin) — create/rename; delete + set-cover are one-shot optimistic ops surfaced through `CollectionsCubit`. |

## State transitions

### Save / file / unsave (canonical flag + membership)

```
                default Save (silent)
   unsaved ───────────────────────────▶ saved (in "All saved")
      ▲                                      │
      │ full unsave                          │ "Save to collection" (explicit)
      │ (confirm IF in ≥1 named collection)  ▼
      │                                  saved + in named collection(s)
      └──────────────────────────────────────┘
        full unsave cascades: server drops ALL memberships,
        Post.viewerHasSaved=false everywhere, "All saved" drops it
```

- **Remove from a named collection** (no confirm): drops one membership; item stays in "All saved" + other collections; `Post.viewerHasSaved` unchanged.
- **Full unsave**: flips the canonical flag → removes from every collection + "All saved". Confirmed first only when `namedMembershipCount >= 1`.

### Collection lifecycle

```
   create(name) ──▶ Collection ──rename──▶ Collection'
                        │  │
              set-cover │  │ file/remove item (itemCount ±1)
                        ▼  ▼
                    (cover/coverRefs updated)
                        │
                     delete (confirm) ──▶ removed  (posts stay saved in "All saved" — SC-006)
```

- The default "All saved" collection supports none of rename/delete/set-cover (FR-003).

## Entity relationships

```
ProfileTab.saved (owner-only) ──▶ SavedCollectionsView
      │
      ▼
CollectionsCubit ──watch──▶ SavedCollections drift cache (v8, canonical list)
      │                         ▲ reconcile: GET /me/collections + saved count
      ├── card tap ──▶ CollectionDetailCubit ──▶ CursorPage<ExploreItem>
      │                    (id=all → GET /me/saved ; else GET /me/collections/{id}/items)
      │                         └── tile tap ──▶ AppRoutes.postDetail (#006)
      │
      └── "Save to collection" (from post/reel) ──▶ SaveToCollectionCubit
                                                      ├── GET /me/saved/{postId}/collections
                                                      ├── FeedRepository.save (canonical flag, #004)
                                                      └── POST/DELETE /me/collections/{id}/items

Post.viewerHasSaved (canonical, #004 Posts cache) ──watchPost──▶ feed / detail / reels / Saved  (SC-007)
```
