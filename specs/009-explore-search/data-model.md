# Phase 1 Data Model: Explore & Search (#009)

Client-side models for the discovery slice (`lib/core/data/discovery/`). All are `freezed` + `json_serializable`, deserialized from the B#009 contract (see [contracts/discovery-api.md](contracts/discovery-api.md)). Reuses `Post`, `Reel`, `UserSummary`, `Place` from the feed/reels slices — those are **not** redefined here.

## ExploreItem

One discovery-grid cell — a kind-tagged post **or** reel. Backend: `ExploreItemDto`.

| Field | Type | Notes |
|-------|------|-------|
| `kind` | `ExploreItemKind` (`post` \| `reel`) | Which payload is set |
| `post` | `Post?` | Set iff `kind == post` (reuses #004 `Post`) |
| `reel` | `Reel?` | Set iff `kind == reel` (reuses #008 `Reel`) |

- Helpers: `String get id` (delegates to post/reel id); `bool get isReel`; `UserSummary get author`; `String? get thumbnailUrl` (primary media thumbnail).
- Validation: exactly one of `post`/`reel` non-null, matching `kind` (assert in the `fromJson`/factory).

## SearchTop

The fixed, non-paginated blended snapshot for `type=top`. Backend: `SearchTopDto`.

| Field | Type | Notes |
|-------|------|-------|
| `accounts` | `List<AccountResult>` | A few (N-per-type), ranked by the server |
| `hashtags` | `List<HashtagResult>` | A few |
| `places` | `List<PlaceResult>` | A few |

- Helper: `bool get isEmpty` (all three empty → empty state).

## AccountResult

An account search result / recent account. Backend: `AccountResultDto` = `UserListItemDto { user, relationship }`.

| Field | Type | Notes |
|-------|------|-------|
| `user` | `UserSummary` | Reused (#004) — id, username, displayName, avatarUrl, isVerified |
| `relationship` | `ViewerRelationship` | Read-only in #009; drives the Follow/Following/Requested label |

## ViewerRelationship

The viewer's relationship toward an account (read-only here). Backend: `RelationshipStateDto`.

| Field | Type | Notes |
|-------|------|-------|
| `following` | `bool` | Viewer follows this account |
| `requested` | `bool` | Pending follow request (private account) |
| `followsYou` | `bool` | This account follows the viewer |
| `blocking` | `bool` | Viewer is blocking (blocked pairs are already filtered out by the server; defensive) |

- Helper: `FollowLabel get label` → `following`, `requested`, or `follow`. **No mutation in #009** (#010 promotes this to the canonical follow model; noted for reuse).

## HashtagResult

A hashtag search result / hashtag-page identity. Backend: `HashtagResultDto`.

| Field | Type | Notes |
|-------|------|-------|
| `tag` | `String` | Lowercase, no `#` |
| `postCount` | `int` | Total posts under the tag |

## PlaceResult

A place search result (identity only; page carries the grid). Backend: `PlaceResultDto`.

| Field | Type | Notes |
|-------|------|-------|
| `id` | `String` | Place id (UUID) |
| `name` | `String` | Display name |
| `lat` / `lng` | `double?` | Optional coordinates |

## HashtagPage

A hashtag page: header + a cursor grid. Backend: `HashtagPageDto`.

| Field | Type | Notes |
|-------|------|-------|
| `tag` | `String` | The tag |
| `postCount` | `int` | Total posts |
| `page` | `CursorPage<ExploreItem>` | `{ items, nextCursor, hasMore }` (reused envelope) |

## PlacePage

A place page: header + a cursor grid. Backend: `PlacePageDto`.

| Field | Type | Notes |
|-------|------|-------|
| `id` | `String` | Place id |
| `name` | `String` | Display name |
| `lat` / `lng` | `double?` | Optional coordinates |
| `postCount` | `int` | Visible post count |
| `page` | `CursorPage<ExploreItem>` | The content grid |

## SearchRecent

A recent-search entry (resolved). Backend: `SearchRecentDto`. Exactly one of `term`/`account`/`hashtag`/`place` set per `type`.

| Field | Type | Notes |
|-------|------|-------|
| `id` | `String` | Server id (used for delete) |
| `type` | `SearchRecentType` (`term`\|`account`\|`hashtag`\|`place`) | Row kind |
| `term` | `String?` | Free-text term (type=term) |
| `account` | `AccountResult?`→`UserSummary?` | Resolved account (type=account) |
| `hashtag` | `HashtagResult?` | Resolved hashtag (type=hashtag) |
| `place` | `Place?` | Resolved place (type=place) |
| `recordedAt` | `DateTime` | For newest-first ordering |

- Record payload (`POST` body, `RecordSearchRecent`): `{ type, term? , targetUserId?, tag?, placeId? }` — exactly one target matching `type`.
- Client rule: dedupe-and-promote on record (optimistic local promote/insert, then POST). List is capped + newest-first, **not paginated**.

## Cache entity — `ExploreItems` (drift, schema v6→v7)

The only persisted discovery surface (Explore grid snapshot). Ordered; replaced on refresh; reactive read.

| Column | Type | Notes |
|--------|------|-------|
| `orderIndex` | `int` (PK) | Grid position (0-based); preserves server order |
| `itemId` | `text` | Underlying post/reel id (for dedupe within the snapshot) |
| `kind` | `text` (`post`\|`reel`) | Cell kind |
| `payloadJson` | `text` | Serialized `ExploreItem` (post/reel JSON) |

- DAO `ExploreDao`: `Stream<List<ExploreItem>> watchExplore()` (ordered by `orderIndex`), `Future<void> replaceAll(List<ExploreItem>)` (clear + insert, for first page/refresh), `Future<void> appendAll(List<ExploreItem>, {int fromIndex})` (next page), `Future<void> clearUserScoped()` (logout wipe — join the existing user-scoped clear).
- Migration: `v6→v7` creates `ExploreItems`; existing rows in other tables untouched (migration test asserts this).

## State (cubit) shapes (freezed 4-state)

- **ExploreCubit** → `initial/loading/loaded(items, hasMore, isOffline)/error(failure)`; reactive over `watchExplore()`, drives load-first/next/refresh; `isOffline` flags cache-only.
- **SearchCubit** → `query`, `activeType (top|accounts|tags|places)`, `top` snapshot, active-type `CursorPage` results + `loadingMore`; `initial/loading/loaded/error` per active view; debounce + latest-term guard.
- **RecentsCubit** → `initial/loading/loaded(items)/error`; record/delete/clearAll (optimistic).
- **DiscoveryGridCubit** (hashtag & place pages) → reuses the `PaginatedListCubit<ExploreItem>` pattern with a header (`HashtagPage`/`PlacePage` meta) — `loading/loaded(meta, items, hasMore)/error`.
