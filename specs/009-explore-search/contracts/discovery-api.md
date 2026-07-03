# Discovery API Contract (client-consumed subset of B#009)

The backend contract already exists and is shipped (`backend/src/modules/search/`). This is the **client-consumed** subset the `DiscoveryRepository` real seam targets. All paths under `/v1` (the `ApiClient` base). Cursor envelope = shared `{ items, nextCursor, hasMore }`; error `{ error: { code, message, details? } }` → `AppFailure` (Constitution V/VIII). Endpoint strings live in `ApiEndpoints` — never inline.

## Endpoints

| Method | Path | Query / Body | Returns | Client use |
|--------|------|--------------|---------|-----------|
| GET | `/explore` | `cursor?`, `limit?` (def 20, max 30) | `ExplorePageDto` = `CursorPage<ExploreItem>` | Explore grid page fetch (non-personalized, ready content) |
| GET | `/search` | `q`, `type?=top\|accounts\|tags\|places`, `cursor?` (single-type only), `limit?` | `SearchTopDto` (top) **or** `AccountSearchPageDto` / `HashtagSearchPageDto` / `PlaceSearchPageDto` (single-type, cursor) | Live search (≥2 chars); Top snapshot + per-type paginated tabs |
| GET | `/hashtags/:tag` | `cursor?`, `limit?` | `HashtagPageDto` = `{ tag, postCount, items[], nextCursor, hasMore }` | Hashtag page (header + grid) |
| GET | `/places/:id` | `cursor?`, `limit?` | `PlacePageDto` = `{ id, name, lat, lng, postCount, items[], nextCursor, hasMore }` | Place page (header + grid) |
| GET | `/me/search-recents` | — | `SearchRecentListDto` = `{ items[] }` (newest-first, capped, **not** paginated) | Recents list |
| POST | `/me/search-recents` | `RecordSearchRecentDto` `{ type, term?, targetUserId?, tag?, placeId? }` | `SearchRecentDto` | Record on tap-result / submit-term (dedupe-and-promote) |
| DELETE | `/me/search-recents/:id` | — | 204 | Remove one recent |
| DELETE | `/me/search-recents` | — | 204 | Clear all recents |

## DTO → client model mapping

| Backend DTO | Client model | Notes |
|-------------|--------------|-------|
| `ExploreItemDto { kind, post?, reel? }` | `ExploreItem` | Reuses `Post` (#004) / `Reel` (#008) |
| `ExplorePageDto` / `HashtagPageDto.items` / `PlacePageDto.items` | `CursorPage<ExploreItem>` | Shared envelope |
| `SearchTopDto { accounts[], hashtags[], places[] }` | `SearchTop` | Fixed snapshot, no cursor |
| `AccountResultDto` (= `UserListItemDto { user, relationship }`) | `AccountResult { UserSummary user, ViewerRelationship relationship }` | Relationship read-only in #009 |
| `RelationshipStateDto { following, requested, followsYou, blocking }` | `ViewerRelationship` | Drives Follow/Requested/Following label |
| `HashtagResultDto { tag, postCount }` | `HashtagResult` | |
| `PlaceResultDto { id, name, lat, lng }` | `PlaceResult` | Page carries `postCount` |
| `AccountSearchPageDto` / `HashtagSearchPageDto` / `PlaceSearchPageDto` | `CursorPage<AccountResult\|HashtagResult\|PlaceResult>` | Single-type tabs |
| `HashtagPageDto` / `PlacePageDto` | `HashtagPage` / `PlacePage` (header + `CursorPage<ExploreItem>`) | |
| `SearchRecentDto` / `SearchRecentListDto` | `SearchRecent` / `List<SearchRecent>` | Exactly one target per `type` |
| `RecordSearchRecentDto` | `RecordSearchRecent` (request) | One target matching `type` |

## Behavior contract (client-relevant)

- **Ready/visible only**: `/explore`, `/hashtags/:tag`, `/places/:id` return only content visible to the viewer; the server applies block/private/visibility rules. The client renders as-is (FR-026) — never re-derives.
- **Search min length**: `q` shorter than the server minimum yields an empty result; the client additionally gates requests at ≥2 chars (R3) so a sub-2-char query never hits the network.
- **Top vs single-type**: `type=top` (or omitted) returns the fixed blended snapshot with `hasMore=false` and no cursor; single-type returns a cursor page. "see more" switches the client to the single-type tab.
- **Account matching**: prefix + substring on username & displayName, case/accent-insensitive (server-side); the client just displays.
- **Recents**: server enforces dedupe-and-promote + cap; the client mirrors optimistically. Recording is idempotent per `(viewer, entry)`.
- **Idempotency**: recents `POST` is a safe dedupe upsert (no `Idempotency-Key` needed); GETs are cacheable/repeatable.

## Fake parity (`env:['fake']`, FR-029 / SC-008)

`FakeDiscoveryRepository` must reproduce: a deterministic mixed post/reel explore grid; searchable accounts/hashtags/places (prefix+substring, case/accent-insensitive) with block/private filtering; hashtag/place pages; recents with dedupe-and-promote; `failNextQuery`/`failNextMutation` seams. Zero network.
