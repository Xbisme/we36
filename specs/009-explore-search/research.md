# Phase 0 Research: Explore & Search (#009)

All Technical Context items resolved — no `NEEDS CLARIFICATION` remained after `/speckit.clarify` (2 questions locked live-search + explore-cache; the 4 product forks were locked pre-spec). This records the decisions that shape the design.

## R1. Content model for grid tiles — reuse Post/Reel via a kind-tagged item

- **Decision**: Client `ExploreItem` = a freezed union `{ ExploreItemKind kind, Post? post, Reel? reel }` (exactly one set, matching `kind`), mirroring the backend `ExploreItemDto`. Reuse the existing `Post` (`core/data/feed/post.dart`) and `Reel` (`core/data/reels/reel.dart`) unchanged.
- **Rationale**: The backend returns full `PostDto`/`ReelDto` in each cell; reusing the shipped models means one deserialization path and lets a tile navigate straight into post-detail (#006) / the reel player (#008). Constitution XI (core→core reuse).
- **Alternatives**: A new lightweight `DiscoveryTile` model (thumbnail-only) — rejected: loses the ability to open the full item and duplicates fields; premature optimization.

## R2. Explore offline cache — dedicated ordered drift snapshot (v6→v7)

- **Decision**: A new `ExploreItems` drift table storing the ordered Explore grid as serialized `ExploreItem` rows (`orderIndex`, `kind`, `payloadJson`). `loadFirstPage` clears+inserts; `loadNextPage` appends; reads are reactive (`watchExplore()`). Only Explore persists; Search/hashtag/place are live-query.
- **Rationale**: Q2 locked cold-start-offline for Explore (FR-027). Discovery ordering is server-defined and cannot be reconstructed from the feed/reels caches, so it needs its own ordered snapshot. Matches the #004 feed cache pattern (clear-on-refresh, reactive watch) and Constitution IX (one canonical *display* copy for the grid).
- **Tradeoff**: A post/reel shown in Explore may also be cached elsewhere. Accepted because Explore tiles are display-only navigation targets — engagement/canonical state lives in the opened surface (see plan Complexity Tracking).
- **Alternatives**: Session/memory-only (fails cold-start-offline); no cache (fails FR-027); reusing `Posts`/`Reels` tables (can't hold ordering or non-followed content).

## R3. Search invocation — live as-you-type, debounced, ≥2 chars

- **Decision**: `SearchCubit` debounces input ~300 ms and issues a query only at **≥2 characters**; below that it shows recents. The latest term wins — an in-flight request for a superseded term is ignored (guard by a monotonically increasing request token / compare against the current query on completion). Enter submits + records a recent.
- **Rationale**: Q1 locked live-as-you-type; matches Instagram-style search and FR-011. Debounce bounds request volume; the request-token guard prevents stale results (edge case: rapidly changing query).
- **Alternatives**: On-submit only (rejected — Q1); no debounce (request spam); no min length (noisy 1-char queries — backend returns empty below its min anyway).

## R4. Search results shape — Top snapshot + per-type paginated tabs

- **Decision**: `type=top` → a fixed `SearchTop { List<AccountResult> accounts, List<HashtagResult> hashtags, List<PlaceResult> places }` (no pagination; each section has "see more" → switch tab). `type=accounts|tags|places` → `CursorPage<T>` of the matching result. `SearchCubit` holds the active tab and lazily loads/paginates it; the Top snapshot is fetched once per term.
- **Rationale**: Directly mirrors the backend (`SearchTopDto` vs `AccountSearchPageDto`/`HashtagSearchPageDto`/`PlaceSearchPageDto`). "see more" switching (not inline expansion) matches the locked backend semantics.
- **Alternatives**: Paginating Top (backend doesn't support it); a separate cubit per tab (more wiring than one cubit tracking the active tab).

## R5. Account result relationship — read-only display, action deferred to #010

- **Decision**: Client `AccountResult = { UserSummary user, ViewerRelationship relationship }` where `ViewerRelationship = { bool following, bool requested, bool followsYou, bool blocking }` (mirrors `RelationshipStateDto`). The row renders **Follow / Requested / Following** as a **read-only label**; tapping the row opens the profile. No follow/unfollow action here (FR-006; #010 owns it).
- **Rationale**: The backend already returns the relationship on every account result (aliased `UserListItemDto`). Displaying it now avoids a second fetch in #010 and keeps the row honest, while the toggle stays in the follow spec.
- **Note**: `ViewerRelationship` is defined in the discovery slice for now; #010 may promote it to `core` as the canonical follow model — flagged so #010 doesn't duplicate it.

## R6. Recents — optimistic dedupe-and-promote over the server list

- **Decision**: `RecentsCubit` reads `GET /me/search-recents` (newest-first, capped, not paginated). Recording (tap a result / submit a term) optimistically promotes-or-inserts the entry at the top locally, then `POST`s; delete/clear-all update locally then `DELETE`. Server is authoritative on next read; failures revert silently (recents are incidental — no blocking toast).
- **Rationale**: Matches the locked dedupe-and-promote semantics and Constitution X (optimistic). Recording must never block navigation, so it is fire-and-forget after the optimistic update.
- **Alternatives**: Server-round-trip-before-UI (adds latency to every tap); local-only recents (diverges from the server list across devices).

## R7. Navigation & routes — Explore tab + nav-less pushed sub-screens

- **Decision**: `Explore` stays the tab-2 branch root (`/explore`). `Search` is a full-screen nav-less **push** from the Explore SearchBar (`AppRoutes.search`). Hashtag/place pages are nav-less pushes (`AppRoutes.hashtag(tag)` → `/hashtags/:tag`, `AppRoutes.place(id)` → `/places/:id`), reachable from search rows, category chips, and (later) tapped tags/locations elsewhere — so they are deep-linkable (FR-025). Category chips deep-link to `hashtag(tag)`.
- **Rationale**: Matches the IA (full-screen flows hide the bottom nav) and the #006/#008 push pattern. Deep-linkable pages satisfy FR-025.
- **Alternatives**: Search as an in-tab overlay (loses full-screen focus + back semantics); nested tab routes (unneeded).

## R8. Fakes — deterministic zero-network discovery

- **Decision**: `FakeDiscoveryRepository` synthesizes a deterministic explore grid (mixed post/reel `ExploreItem`s reusing the feed/reel fakes), a searchable in-memory set of accounts/hashtags/places (prefix+substring, case/accent-insensitive) honoring block/private rules, hashtag/place pages, and an in-memory recents list with dedupe-and-promote + a `failNextMutation`/`failNextQuery` seam (mirrors `FakeReelsRepository`/`FakeFeedRepository`). App runs `env:['fake']` zero-network (FR-029, SC-008).
- **Rationale**: Consistency with every prior slice; enables full bloc/widget/golden coverage offline.

## R9. Grid layout & tile performance

- **Decision**: Quilted 3-column grid on phones with an emphasized 2×2 hero tile (a `SliverGrid` with a custom tile layout / staggered pattern using core widgets — no new package); reels tiles carry a corner reels `AppIcon`. Tablet/iPad (≥700) uses a responsive `SliverGrid` (`SliverGridDelegateWithMaxCrossAxisExtent`, ~200 px). Images via `cached_network_image` with a bounded `cacheWidth` (carry the #001/#004 memory-ceiling discipline). Pull-to-refresh via `RefreshIndicator`.
- **Rationale**: SC-004 (5+ pages, no slowdown) + Constitution II/VII. Reuses existing tile/image patterns; no staggered-grid package needed for a fixed quilted pattern.
- **Alternatives**: `flutter_staggered_grid_view` package — rejected (avoid a new dependency for a fixed 2×2-hero pattern).
