# Implementation Plan: Explore & Search

**Branch**: `009-explore-search` | **Date**: 2026-07-03 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/009-explore-search/spec.md`

## Summary

Build the We36 client **discovery** surface — an Explore grid, full-text Search (Top/Accounts/Tags/Places), recent-search history, and hashtag/place pages — as a new `features/explore/` presentation layer over a new `core/data/discovery/` data slice that consumes the already-shipped backend **B#009** contract (`GET /explore`, `GET /search`, `GET /hashtags/:tag`, `GET /places/:id`, `GET/POST/DELETE /me/search-recents`). Discovery is **non-personalized**; the backend enforces all visibility/block rules and the client only renders what it returns. Grid tiles reuse the existing `Post` (#004) and `Reel` (#008) content models via a kind-tagged `ExploreItem`. The Explore grid is the only surface persisted on-device (drift **v6→v7**) so it opens offline on a cold start; Search and hashtag/place pages are live-query. Search runs live as-you-type (debounced ~300 ms, ≥2 chars). Every source has an in-memory fake so the app builds/tests zero-network.

## Technical Context

**Language/Version**: Dart 3.12.2 / Flutter 3.44.4 (repo baseline).

**Primary Dependencies**: `flutter_bloc` (4-state freezed Cubits), `get_it`+`injectable` (DI, `env:['real'|'fake']`), `go_router` (routes + nav-less push), `dio` via the shared `ApiClient` + `FailureMapper`, `drift` (explore cache), `freezed`+`json_serializable`, `cached_network_image` (bounded tile decode), `lucide_icons_flutter` via `AppIcon`, `intl` (count/relative-time formatters). **No new pub dependency expected.**

**Storage**: drift `AppDatabase` — one new `ExploreItems` table (schema **v6→v7**) holding the ordered Explore-grid snapshot (the only persisted discovery surface). Search results, recents, hashtag/place pages are live/in-memory.

**Testing**: `flutter_test` + `bloc_test` + `mocktail` (fakes) + golden tests; drift migration test (v6→v7); log-redaction test; a11y/text-scale/adaptive widget tests. Mirrors #008 coverage.

**Target Platform**: iOS + Android phones + iPad/Android tablets (adaptive by width).

**Project Type**: Mobile app (Flutter client) over a custom REST backend; client-only feature (backend B#009 already shipped).

**Performance Goals**: 60 fps grid scroll with a bounded memory ceiling over ≥5 pages (SC-004); search results render < 1 s (SC-002); tile images decode at a bounded `cacheWidth`.

**Constraints**: offline-capable Explore (persisted cache, cold-start); server-authoritative visibility/block (client never re-derives — FR-026); all messages via Toast; tokens/semantic-aliases only (no hardcoded hex/TextStyle); `lib/core/` must not import `lib/features/`.

**Scale/Scope**: 4 screens (16–19) → Explore, Search (recents + results in one screen), Hashtag page, Place page; ~5 cubits; 1 repository (+ real + fake); ~6 client models; cursor pagination reused; 1 drift table.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **I Clean Architecture / feature-first**: New `features/explore/` (presentation) + `core/data/discovery/` (data). `core/` never imports `features/`; discovery reuses `core/data/feed` (`Post`/`UserSummary`/`Place`) and `core/data/reels` (`Reel`) — core→core only. ✅
- **II Media discipline**: Grid tiles are static thumbnails (bounded `cacheWidth`, `cached_network_image`); no video plays in the grid (reels open into the #008 player). ✅
- **III BLoC 4-state**: Events plain / states freezed `initial/loading/loaded/error` (extended variants prefix the base). Use Cases injected into Cubits, not repos. Page-scoped `BlocProvider`; `@injectable` screen cubits, `@lazySingleton` repo/services. ✅
- **IV One API client / repo boundary**: All HTTP via the shared `ApiClient`; widgets/cubits never touch `dio`. Endpoints in `api_endpoints.dart` (no inline literals). ✅
- **V Result/AppFailure**: Repo returns `Result<T>`; errors centralized via `FailureMapper` → `AppFailure` → Toast. ✅
- **VI Design discipline**: Reuse shared `SearchBar`, `Avatar`, `Tag` chip, grid tiles; semantic tokens only; reels marker + hero tile per design; brand color only on active tab underline / follow-state. ✅
- **VII Adaptive**: Phone 3-col grid + bottom nav; ≥700 responsive grid; results tabs + pages reflow by width (LayoutBuilder/MediaQuery, never device model). ✅
- **VIII Backend-agnostic + fakes**: Every source has an in-memory fake (`env:['fake']`); app builds/tests zero-network (SC-008). ✅
- **IX One canonical cached copy**: Explore grid persisted as one ordered snapshot in `ExploreItems`; hashtag/place/search are transient. *Tradeoff (justified below):* explore tiles are display-only navigation targets — engagement/canonical state lives in the opened post-detail (#006) / reel (#008) surface, so a lightweight display snapshot does not create a competing canonical engagement copy. ✅ (see Complexity Tracking)
- **X Optimistic + idempotent**: Recents record/delete/clear are optimistic (local list updates immediately; POST/DELETE reconcile; dedupe-and-promote client + server). No other mutations (follow is out of scope / surface-only). ✅
- **XI Cross-feature isolation**: `explore` does not import other features' internals; navigation to profile/post/reel via `core/router` routes. ✅
- **XII Toast + AppLogger**: Toast for all messages; `AppLogger` (redacted) for logging; no `print`/`debugPrint`; no query terms/urls/tokens leaked (log-redaction test). ✅

**Result: PASS** (one justified tradeoff under Constitution IX, recorded in Complexity Tracking).

## Project Structure

### Documentation (this feature)

```text
specs/009-explore-search/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/
│   └── discovery-api.md # Client-consumed B#009 subset
└── tasks.md             # /speckit.tasks output (later)
```

### Source Code (repository root)

```text
lib/core/data/discovery/                 # NEW data slice
├── explore_item.dart                    # ExploreItem (kind-tagged Post|Reel) freezed+json
├── search_results.dart                  # SearchTop, AccountResult, HashtagResult, PlaceResult, ViewerRelationship
├── search_recent.dart                   # SearchRecent (term|account|hashtag|place) freezed+json
├── discovery_page.dart                  # HashtagPage / PlacePage envelopes (tag/place + CursorPage<ExploreItem>)
├── discovery_repository.dart            # interface (Result<T>, reactive explore read)
├── discovery_repository_impl.dart       # @LazySingleton(as:…, env:['real'])
├── fake_discovery_repository.dart       # @LazySingleton(as:…, env:['fake'])
└── discovery_remote_data_source.dart    # ApiClient calls → Result

lib/core/data/cache/
├── tables/explore_items_table.dart      # NEW drift table (ordered explore snapshot)
└── daos/explore_dao.dart                # NEW DAO (watch/replace/append)
# app_database.dart: schemaVersion 6→7 + migration step

lib/features/explore/
├── domain/usecases/                     # explore_grid, search, recents, discovery_page use cases
├── presentation/cubit/                  # ExploreCubit, SearchCubit, RecentsCubit, DiscoveryGridCubit (hashtag/place)
├── presentation/explore_page.dart       # Screen 16 (tab): searchbar + chips + grid
├── presentation/search_page.dart        # Screens 17+18: recents (empty query) ↔ results tabs (≥2 chars)
├── presentation/hashtag_page.dart       # Screen 19 (hashtag)
├── presentation/place_page.dart         # Screen 19 (place)
└── presentation/widgets/                # DiscoveryGridTile, AccountResultRow, Hashtag/PlaceRow, RecentRow, CategoryChips, ResultsTabs

lib/core/constants/api_endpoints.dart    # + explore/search/hashtag/place/recents
lib/core/constants/app_routes.dart       # + search, hashtag(tag), place(id)
lib/core/router/app_router.dart          # wire Explore tab body + pushed routes
lib/l10n/arb/app_en.arb + app_vi.arb     # discovery strings

test/features/explore/ + test/core/data/discovery/ + test/core/data/cache/  # bloc/widget/golden/fake/migration/redaction/a11y/adaptive
```

**Structure Decision**: Mirror the shipped #008 reels slice — a `core/data/discovery/` data layer (models + repository + real/fake + remote source + cache DAO) consumed by a `features/explore/` presentation layer (cubits + pages + widgets). Explore, hashtag, and place grids all render a `CursorPage<ExploreItem>`, so hashtag/place reuse the shared `PaginatedListCubit<ExploreItem>` (live) while `ExploreCubit` adds the persistent-cache reactive read. Search (Screens 17+18) is one `SearchPage`: an empty/short query shows recents; ≥2 chars shows the tabbed results — driven by one `SearchCubit` (query + debounce + Top snapshot + active single-type paginated list) with a separate `RecentsCubit`.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Explore grid persisted as its own `ExploreItems` snapshot (Constitution IX — a post/reel may also live in another cached table) | FR-027 requires Explore to open offline on a cold start; the discovery ordering is server-defined and not derivable from the feed/reel caches | Reusing the feed `Posts`/reels `Reels` tables can't represent discovery ordering or content the viewer doesn't follow; a session-only cache fails the cold-start-offline requirement. The snapshot is display-only (tiles navigate into the canonical post/reel surface for engagement), so it introduces no competing canonical *engagement* copy. |
