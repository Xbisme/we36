# Implementation Plan: Saved Collections

**Branch**: `011-collections` | **Date**: 2026-07-07 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/011-collections/spec.md`

## Summary

Build the We36 client **personal-organization** surface — a **Saved** tab on the signed-in person's own profile that opens a 2-column grid of their saved-post **collections** (Screen 24), a default **"All saved"** view of everything they've saved, per-collection item grids, and the create / file / remove / rename / delete / set-cover flows — as a new `features/collections/` presentation layer over a thin `core/data/collections/` data slice consuming the already-shipped backend **B#011**. It **reuses shipped seams**: the canonical `Post.viewerHasSaved` + optimistic `save(postId,{save})` toggle (#004), the kind-tagged `ExploreItem` + `DiscoveryGrid`/`DiscoveryGridTile` (#009) for every item grid, `CursorPage<T>` + `PaginatedListCubit<T>` (#002) for the item grids, the `ProfileTabBar` (#010, extended `posts|tagged` → `+saved`), and shared `Avatar`/`AppButton`/`TopBar`/`ActionSheet`/`AppDialog`/`CountFormatter`. **Saved-state stays the one canonical `Post.viewerHasSaved`** (no divergent copy) so saving/unsaving from feed, post detail, or reels stays consistent with the Saved surface (SC-007). The **collections list** is the one canonical collections copy, held in a reactive **drift `SavedCollections` cache (schema v7→v8)** so the Saved screen opens offline-from-cache (FR-012); **collection item grids + "All saved" are live cursor pages** (not persisted; reconciled per open — matching #009/#010 grids). Per clarification: the **default Save saves silently to "All saved"**; **"Save to collection"** is the explicit filing action; **collection names need not be unique**; a **full unsave confirms only when the item is in ≥1 named collection**. All create/file/remove/rename/delete/set-cover mutations are **optimistic + idempotent** (client `Idempotency-Key`, rollback + Toast on failure). Every source has an in-memory fake so the app builds/tests zero-network. **No new pub dependency.**

## Technical Context

**Language/Version**: Dart 3.12.2 / Flutter 3.44.4 (repo baseline).

**Primary Dependencies**: `flutter_bloc` (4-state freezed Cubits), `get_it`+`injectable` (DI, `env:['real'|'fake']`), `go_router` (nav-less pushed collection routes + a new `ProfileTab.saved` body), `dio` via the shared `ApiClient` + `FailureMapper`, `freezed`+`json_serializable`, `drift` (new `SavedCollections` cache + DAO, reactive `.watch()`), `cached_network_image` (bounded cover/tile decode), `lucide_icons_flutter` via `AppIcon`, `intl` via `CountFormatter`. Reuses `core/data/discovery` (`ExploreItem`, `DiscoveryGrid`/`DiscoveryGridTile`), `core/data/feed` (`Post`, `FeedRepository.save` canonical toggle + `watchPost`), `core/domain` (`Result`/`AppFailure`/`CursorPage`/`PaginatedListCubit`), `features/profile` (`ProfileTabBar`). **No new pub dependency.**

**Storage**: **drift schema v7→v8** — one new `SavedCollections` table (id, name, itemCount, up-to-4 cover thumb refs, isDefault, updatedAt) + `saved_collections_dao` with reactive `watchCollections()`, so the Saved screen renders offline from cache (FR-012), matching the #009 `ExploreItems` precedent. The **canonical saved boolean stays `Post.viewerHasSaved`** in the existing `Posts` cache (#004) — no second copy. Collection **item grids** ("All saved" + per-collection) are **live cursor pages** (no persistence — matching #009 search / #010 profile grids). Membership (which collections a post is in) is server-authoritative and fetched on demand for the picker / unsave-confirm.

**Testing**: `flutter_test` + `bloc_test` + `mocktail` (fakes) + golden tests. Cubit/logic: collections load + offline cache, save→All-saved, file/remove membership optimistic + rollback + idempotency, full-unsave-confirm gating (in-named-collection vs All-saved-only), rename/delete/set-cover, count-consistency + cross-surface save consistency (SC-005/006/007), pagination. Widget tests seed **stub cubits** with a fixed 4-state (never real drift I/O inside `testWidgets` — the #009 gate learning). Log-redaction + a11y/text-scale/adaptive + goldens (collection card / collections grid / save-to-collection sheet / empty states, light+dark).

**Target Platform**: iOS + Android phones + iPad/Android tablets (adaptive by width; Screen 24 uses the centered-mobile fallback — no dedicated tablet layout in v1.0).

**Project Type**: Mobile app (Flutter client) over a custom REST backend; client-only feature (backend B#011 already shipped).

**Performance Goals**: 60 fps collection/item-grid scroll with a bounded memory ceiling over ≥5 pages; save/file/remove reflect optimistically in < 16 ms (local state); cover/tile images decode at a bounded `cacheWidth`.

**Constraints**: server-authoritative content (client never re-derives what is saved/in a collection beyond the canonical flag); Saved is **owner-private** (never rendered for another profile); all messages via Toast; semantic tokens only (no hardcoded hex/TextStyle); `lib/core/` must not import `lib/features/`; mutations idempotent (client key) + optimistic with rollback; one canonical saved flag + one canonical collections list.

**Scale/Scope**: 1 designed screen (24) → Saved collections grid, rendered as the profile **Saved** tab body; + a per-collection item-grid page (reuses `DiscoveryGrid`) and a **Save-to-collection** bottom sheet; ~4 cubits (collections-grid, collection-detail, save-to-collection picker, collection-edit); 1 new repository (+ real + fake) + 1 new drift table/DAO (v8); ~2 new client models (`SavedCollection`, a lightweight picker row); item grids reuse `ExploreItem`; the canonical save toggle + `ExploreItem`/`DiscoveryGrid` are reused as-is.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **I Clean Architecture / feature-first**: New `features/collections/` (presentation) + `core/data/collections/` (data). `core/` never imports `features/`; collections reuses `core/data/{feed,discovery}` — core→core only. The profile Saved tab is a small extension in `features/profile` that renders a `features/collections` widget via a router/DI seam (no feature→feature internals import). ✅
- **II Media discipline**: Collection covers + item tiles reuse the #009 static `DiscoveryGridTile` (bounded `cacheWidth`); no video in grids (reels open into #008). ✅
- **III BLoC 4-state**: Events plain / states freezed `initial/loading/loaded/error` (extended variants prefix the base). Use Cases injected into Cubits, not repos. Page-scoped `BlocProvider`; `@injectable` screen cubits, `@lazySingleton` repo/DAO/services. ✅
- **IV One API client / repo boundary**: All HTTP via the shared `ApiClient`; widgets/cubits never touch `dio`. New endpoints in `api_endpoints.dart` (no inline literals). ✅
- **V Result/AppFailure**: Repo returns `Result<T>`; errors centralized via `FailureMapper` → `AppFailure` → Toast. ✅
- **VI Design discipline**: Reuse shared `TopBar`, `AppButton`, `ActionSheet`, `AppDialog`, `Avatar`, `DiscoveryGrid`/`DiscoveryGridTile`, `CountFormatter`; semantic tokens only; brand color only on the create CTA / active state; neutral chrome so media is the star. ✅
- **VII Adaptive**: Phone 2-col collections grid + 3-col item grids via `AppBreakpoints`/`LayoutBuilder`; Screen 24 uses the centered-mobile fallback on tablet (no bespoke tablet layout — design §Responsive). Never device model. ✅
- **VIII Backend-agnostic + fakes**: Every source has an in-memory fake (`env:['fake']`); app builds/tests zero-network. ✅
- **IX One canonical cached copy**: **Two canonical copies, no divergence** — (a) the **saved boolean** is the existing `Post.viewerHasSaved` (#004 `Posts` cache, watched via `watchPost`), so unsaving anywhere flips it everywhere (SC-007); (b) the **collections list** is the new reactive drift `SavedCollections` cache. Item grids are live cursor pages (server-authoritative, re-fetched per open — no persisted copy to drift). ✅
- **X Optimistic + idempotent**: Save→All-saved, file/remove membership, create/rename/delete/set-cover apply immediately, carry a client `Idempotency-Key`, and roll back on failure (last-intent wins). Full unsave confirms first when the item is in ≥1 named collection. ✅
- **XI Cross-feature isolation**: `collections` does not import other features' internals; the profile Saved tab body is provided through a **`core/presentation/slots/SavedTabSlot`** abstraction (impl `@LazySingleton` in `features/collections`, consumed via `getIt` in `features/profile` — no direct `features/collections` import); the post/reel "Save to collection" entry points route through `core/router` + DI seams; item tiles open post detail via the existing `AppRoutes.postDetail`. ✅
- **XII Toast + AppLogger**: Toast for all messages; `AppLogger` (redacted) for logging; no `print`/`debugPrint`; no tokens leaked (log-redaction test). ✅

**Result: PASS** — one deliberate design choice justified in Complexity Tracking (a new drift table for the collections list).

## Project Structure

### Documentation (this feature)

```text
specs/011-collections/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/
│   └── collections-api.md   # Client-consumed B#011 subset (derived — reconcile w/ backend)
└── tasks.md             # /speckit.tasks output (later)
```

### Source Code (repository root)

```text
lib/core/presentation/slots/             # NEW cross-feature seam (Constitution XI)
└── saved_tab_slot.dart                  # abstract SavedTabSlot { Widget build(ctx); } — profile renders getIt<SavedTabSlot>()

lib/core/data/collections/               # NEW data slice
├── saved_collection.dart                # SavedCollection (id,name,itemCount,coverRefs,isDefault,updatedAt) freezed+json
├── collections_repository.dart          # interface (Result<T>): list/create/rename/delete/setCover, items, allSaved, membership, file/unfile
├── collections_repository_impl.dart     # @LazySingleton(as:…, env:['real'])  → ApiClient + SavedCollectionsDao
├── fake_collections_repository.dart     # @LazySingleton(as:…, env:['fake'])  → in-memory graph over the shipped fake Posts/saved flag
└── collections_remote_data_source.dart  # ApiClient calls → Result

lib/core/data/cache/
├── tables/saved_collections_table.dart  # NEW drift table (v8)
└── daos/saved_collections_dao.dart       # NEW DAO: watchCollections(), upsertAll(), clearUserScoped()
   (app_database.dart: schemaVersion 7→8 + migration; register table+DAO)

lib/features/collections/
├── domain/usecases/
│   ├── collections_usecases.dart        # WatchCollections / LoadCollections (grid + All-saved header)
│   ├── collection_items_usecases.dart   # LoadCollectionItems / LoadAllSaved (cursor) + RemoveFromCollection
│   ├── save_to_collection_usecases.dart # LoadPicker(postId) / CreateCollectionInline / FileInto / Unfile
│   └── manage_collection_usecases.dart  # CreateCollection / RenameCollection / DeleteCollection / SetCover
├── presentation/
│   ├── cubit/
│   │   ├── collections_cubit(.dart/_state)          # Saved tab: collections grid (watch drift v8) + All-saved tile
│   │   ├── collection_detail_cubit(.dart/_state)    # one collection's item grid (PaginatedListCubit) + remove
│   │   ├── save_to_collection_cubit(.dart/_state)   # picker sheet: memberships + create-inline + file/unfile
│   │   └── collection_edit_cubit(.dart/_state)      # create/rename/delete/set-cover (optimistic)
│   ├── saved_collections_view.dart       # Screen 24 body (rendered inside the profile Saved tab)
│   ├── collection_detail_page.dart       # one collection's item grid (nav-less push; id=all → All saved)
│   └── widgets/
│       ├── collection_card.dart          # 4-image quilt cover + name + "N saved" (radius-16)
│       ├── collections_grid.dart         # 2-col grid of collection_card (+ All saved first)
│       ├── save_to_collection_sheet.dart # bottom sheet: pick/create + toggle membership
│       ├── create_collection_dialog.dart # name input (create / rename); non-unique; ≤50 chars
│       └── collection_more_sheet.dart    # rename / delete(confirm) / set-cover action sheet
└── (routes added to core/router/app_router.dart + AppRoutes; ProfileTab gains `saved`)

lib/features/collections/presentation/
└── saved_tab_slot_impl.dart             # @LazySingleton(as: SavedTabSlot) → BlocProvider(CollectionsCubit) → SavedCollectionsView

lib/features/profile/                     # EXTEND (minimal)
├── domain/usecases/profile_usecases.dart # enum ProfileTab { posts, tagged, saved }  (+saved, owner-only)
└── presentation/widgets/profile_tab_bar.dart  # render the Saved tab (owner-only); body = getIt<SavedTabSlot>().build(ctx) (no features/collections import)
```

**Structure Decision**: Feature-first (matches #004–#010). A new `features/collections/` presentation layer over a thin `core/data/collections/` slice; the profile gains a third **Saved** tab (owner-only) whose body renders `SavedCollectionsView` (Screen 24's 2-col collections grid + create), keeping tabs consistent with the inline Posts/Tagged pattern (#010). Opening a collection (or the "All saved" tile) pushes the nav-less `/collections/:id` route (`id=all` = All saved) showing that collection's cursor `DiscoveryGrid`. "Save to collection" is a bottom sheet reachable from the shipped post/reel save affordances. The canonical **saved flag** is the existing `Post.viewerHasSaved`; the canonical **collections list** is the new reactive drift `SavedCollections` cache.

## Complexity Tracking

| Choice | Why Needed | Simpler Alternative Rejected Because |
|--------|------------|-------------------------------------|
| A new drift `SavedCollections` table (schema v7→v8), rather than the in-memory-store approach #010 used for relationships | FR-012 requires the Saved screen to render **offline-from-cache**, and the collections list is the one canonical collections copy watched reactively by the grid. Persisting it (like the #009 `ExploreItems` grid) gives instant offline cold-start at low cost. | An **in-memory** collections store (like #010's `RelationshipStore`) was rejected: it cannot satisfy the offline-cold-start requirement (FR-012). Persisting the **item grids** too was rejected: they are server-authoritative, re-fetched per open, and unbounded — persisting them would be an unjustified migration + memory cost (matches the #009/#010 live-grid precedent). Only the small, bounded collections list is persisted. |
