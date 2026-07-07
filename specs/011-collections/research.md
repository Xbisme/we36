# Phase 0 Research: Saved Collections (#011)

All decisions below resolve the Technical Context and the spec's clarifications. Because #011 sits on shipped seams, most "research" is confirming the reuse boundary rather than picking new tech. **No new pub dependency; one drift schema bump (v7→v8) for the collections list.**

## R1 — "All saved" is a virtual view, named collections are real (clarification, FR-003)

- **Decision**: The default **"All saved"** collection is a **virtual view** of every post/reel where the canonical `Post.viewerHasSaved == true`, sourced from a `GET /me/saved` cursor endpoint — it is **not** a real backend collection and holds no membership rows. **Named collections** are real entities (`GET/POST/PATCH/DELETE /me/collections…`) with explicit membership. The client models "All saved" as a synthetic `SavedCollection` (`isDefault: true`, id `all`) rendered first in the grid; its item grid calls `GET /me/saved`, every other card calls `GET /me/collections/{id}/items`.
- **Rationale**: "All saved" must always equal the canonical saved set with zero drift; deriving it from the saved flag (not a parallel membership list) makes that automatic — saving/unsaving anywhere updates it for free (SC-002/SC-007). It also matches Instagram's "All Posts" default. Keeps the default un-renamable/un-deletable naturally (no entity to mutate).
- **Alternatives considered**: modeling "All saved" as a real server collection that every save auto-joins — rejected: duplicates the saved flag as membership, invites drift, and complicates unsave; the spec only needs the *capability*, and the virtual view is simpler + always-consistent.

## R2 — Canonical saved state stays `Post.viewerHasSaved`; collections list is the new canonical copy (Constitution IX, SC-007)

- **Decision**: The one canonical **saved boolean** remains `Post.viewerHasSaved` in the shipped `Posts` drift cache (#004), toggled via the existing `FeedRepository.save(postId,{save})` optimistic path and watched via `watchPost`. #011 adds **no second saved flag**. The one canonical **collections list** is a new reactive drift `SavedCollections` cache (v8), watched by `CollectionsCubit`. Collection **item grids** and "All saved" are live cursor pages (not persisted).
- **Rationale**: SC-007 (cross-surface save consistency) is satisfied for free by reusing the canonical `Post` cache — a save/unsave from feed/detail/reels already repaints every surface that watches the post. The collections *list* is small, bounded, and needs offline cold-start (FR-012), so it earns a drift table (precedent #009 `ExploreItems`); the item grids are unbounded + server-authoritative, so they stay live (precedent #009 search / #010 profile grids).
- **Alternatives considered**: (a) a full drift model of every collection's membership — rejected: unbounded persistence + migration cost for server-authoritative, re-fetched data; (b) an in-memory collections store like #010's `RelationshipStore` — rejected: cannot render the Saved screen offline-from-cache (FR-012).

## R3 — Default Save = silent to "All saved"; "Save to collection" = explicit filing (clarification, FR-004/005)

- **Decision**: The plain bookmark tap calls the shipped `save(postId,{save:true})` and shows **no picker** — the post enters "All saved" (via the canonical flag). Filing into a named collection is the separate **"Save to collection"** action (long-press the bookmark / post action sheet) that opens `SaveToCollectionSheet`: it loads the post's current memberships (`GET /me/saved/{postId}/collections`), lets the person toggle collections and **create one inline**, and calls `POST/DELETE /me/collections/{id}/items` per change. If the post was not yet saved, filing it also sets the canonical saved flag.
- **Rationale**: Matches the clarified UX (least friction on the common save) and the Instagram model; reuses the shipped optimistic save toggle unchanged for the default path.
- **Idempotency**: `POST /me/collections/{id}/items` carries a client `Idempotency-Key`; a retry yields exactly one membership (SC-004). The default save is already idempotent (#004).
- **Alternatives considered**: always opening the picker on save — rejected by clarification; a bespoke "save+file" atomic endpoint — deferred (client composes save + file; the backend may offer a combined call, reconciled in contracts).

## R4 — Full-unsave confirmation gating (clarification, FR-008)

- **Decision**: **Removing an item from a named collection** (`DELETE /me/collections/{id}/items/{postId}`) is immediate, no confirm — it only drops that membership. **Fully unsaving** (canonical `save:false`) is gated: before calling it, the client checks whether the item is in ≥1 **named** collection (known from the picker load or a `membershipCount`); if so it shows an `AppDialog` confirm ("This will remove it from N collections"), and only on confirm flips the canonical flag (which cascades: server removes all memberships, `Post.viewerHasSaved=false` everywhere, "All saved" drops it). An item only in "All saved" unsaves silently/optimistically.
- **Rationale**: Guards against accidental membership loss exactly where loss is possible, while keeping the common case (save only in All-saved) friction-free — matches the clarification and the #010 confirm-on-destructive pattern.
- **Alternatives considered**: always confirm unsave (rejected by clarification); never confirm (rejected — silent multi-collection membership loss is surprising).

## R5 — Item grids + covers reuse #009 (FR-002/007, reuse)

- **Decision**: Every item grid ("All saved" and per-collection) reuses the #009 `ExploreItem` (kind-tagged `Post`|`Reel`) + `DiscoveryGrid`/`DiscoveryGridTile` verbatim (uniform grid, reels marked, bounded `cacheWidth`) over `CursorPage<ExploreItem>`. A **collection card's 4-image quilt cover** is a small static composite of up to 4 recent item thumbnails (or the owner-set cover first), built from the `coverRefs` on `SavedCollection` — no new tile engine.
- **Rationale**: Identical visual + data contract to explore/hashtag/profile grids; zero new grid code (Constitution XI reuse). Card covers are cheap static thumbnails.
- **Alternatives considered**: a bespoke collection grid item — rejected as duplicative; the explore quilted hero layout is **not** used (collection item grids are uniform, per design).

## R6 — Saved tab placement + routing (FR-001, owner-private, adaptive)

- **Decision**: Extend `ProfileTab { posts, tagged }` → add **`saved`**, rendered **only on the owner's own profile** (`isMe`); it is never shown on another person's profile (FR-001/FR-014). The Saved tab body renders `SavedCollectionsView` (Screen 24's 2-col collections grid + a create `+` affordance in the tab header). Opening a collection or the All-saved tile pushes the nav-less route **`/collections/:id`** (`id=all` → All saved) rendering that collection's cursor `DiscoveryGrid`; item tiles open `AppRoutes.postDetail`. Save-to-collection, create/rename, and manage are **sheets/dialogs** (no route). New `AppRoutes.collection(id)` helper + `we36://collections/:id`.
- **Cross-feature render seam (Constitution XI — pinned)**: `features/profile` must **not** import `features/collections` to embed its Saved tab body. Instead a tiny **widget-slot seam lives in `core`** — `SavedTabSlot` (`abstract class SavedTabSlot { Widget build(BuildContext); }` in `core/presentation/slots/`). `features/collections` provides the concrete impl (`@LazySingleton(as: SavedTabSlot)` returning a `BlocProvider(CollectionsCubit) → SavedCollectionsView`); `features/profile` renders `getIt<SavedTabSlot>().build(context)` for the Saved tab, depending only on the core abstraction. This keeps the inline-tab UX (matching design) with zero cross-feature internal import (precedent: the app already hands off between features via `core/router` + DI). The per-collection detail + save-to-collection sheet are reached by **route/DI** (also core), not direct imports.
- **Rationale**: Keeps tabs consistent with the inline Posts/Tagged pattern (#010) while realizing Screen 24's content and honoring Constitution XI; owner-only rendering enforces privacy at the presentation seam (the backend also never returns another user's saved set).
- **Alternatives considered**: (a) `features/profile` importing `SavedCollectionsView` directly — rejected: Constitution XI (cross-feature coupling); (b) the Saved tab **pushing** a standalone `/collections` page instead of embedding — viable and constitution-clean, but rejected as inconsistent with the inline Posts/Tagged tabs (the slot seam gives the same isolation while keeping the inline UX); (c) a top-level `/saved` menu entry — rejected: the design ties Saved to the profile tab bar. Tablet two-pane — rejected: Screen 24 uses the centered-mobile fallback (design §Responsive).

## R7 — Optimistic collection mutations + count/cover reconciliation (FR-005/008/009/010, Constitution X)

- **Decision**: `create` (optimistic insert of a temp collection → replace with server id), `rename` (optimistic name), `delete` (optimistic remove; **posts stay saved** — no canonical-flag change), `set-cover` (optimistic cover swap), `file`/`remove` (optimistic membership + `itemCount ±1` on the affected card) all update the reactive `SavedCollections` cache immediately, carry a client `Idempotency-Key`, and roll back with a Toast on failure. `itemCount` and `coverRefs` are reconciled from the mutation response / next `watchCollections` reconcile. Deleting a collection never touches `Post.viewerHasSaved` (SC-006).
- **Rationale**: Matches the shipped optimistic-engagement pattern (#004/#006/#010) and the spec's SC-003/004/006.
- **Alternatives considered**: server-first mutations — rejected (violates optimistic UX SC-003).

## R8 — Validation & limits (FR-005/009, assumptions)

- **Decision**: Collection **names**: non-empty, trimmed, length-capped at **50 characters** (truncate with an accessible full-name label), **not required unique** (create/rename never rejects a duplicate — clarification). No cap on number of collections in v1.0 (backend may impose one; the client surfaces any `4xx` as a Toast). Reordering within a collection is out of scope (default order = backend-provided, newest-first).
- **Rationale**: Encodes the clarified rules + a reasonable name cap so create/rename tests are deterministic.

## R9 — Testing strategy (repo gate + #009 learning)

- **Decision**: Widget tests seed **stub cubits** with a fixed 4-state (`StubCollectionsCubit`, …) — never drive a real repository over drift `NativeDatabase` inside `testWidgets` (that deadlocks in faked-async; the #009 gate regression). Drift-touching + optimistic/idempotent logic is covered by plain `test()` / `blocTest` cubit tests with the in-memory fake repo (+ a real in-memory `AppDatabase` for the DAO-level tests, driven in plain `test()` with real async). Coverage: collections load + offline cache render, save→All-saved, file/remove membership optimistic+rollback+idempotency, unsave-confirm gating, rename/delete/set-cover, count-consistency (SC-005/006), cross-surface save consistency (SC-007), pagination, log-redaction, a11y/text-scale/adaptive, and goldens (collection card, collections grid, save-to-collection sheet, empty states, light+dark).
- **Rationale**: Encodes the #009 gate learning so #011 lands green the first time; also freezes any clock-dependent fake seams (the #005/post-#10 time-bomb learning — no fixed wall-clock in tests).

## Resolved unknowns

| Unknown (Technical Context) | Resolution |
|---|---|
| "All saved" real vs virtual | Virtual view over the canonical saved flag (R1) |
| Canonical copies (saved flag vs collections) | Saved flag = `Post.viewerHasSaved` (#004); collections list = new drift v8 cache (R2) |
| Default Save vs Save-to-collection | Plain save silent → All saved; explicit sheet files into a collection (R3) |
| Unsave confirmation | Confirm only when in ≥1 named collection (R4) |
| Item grid item + tiles + covers | Reuse `ExploreItem` + `DiscoveryGrid` (R5) |
| Saved tab placement + routes | Owner-only `ProfileTab.saved` body + `/collections/:id` push (R6) |
| Optimistic mutations + counts/cover | R7 (optimistic; delete keeps posts saved) |
| Name validation/limits | ≤50 chars, non-empty, non-unique (R8) |
| B#011 endpoint/DTO shapes | Derived in `contracts/collections-api.md` — **reconcile with the shipped backend** |

## Open item to reconcile with backend

The exact B#011 endpoint paths, the "All saved" endpoint (`GET /me/saved`), the membership-lookup shape (`GET /me/saved/{postId}/collections`), whether a combined save-and-file call exists, and the collection cover/`itemCount` fields in `contracts/collections-api.md` are **derived from repo conventions** (envelope `{data,…}` / `{error:{code,message,details}}`, `CursorPage<T>`, `Idempotency-Key`) and must be cross-checked against the shipped B#011 contract before/at implementation. No spec requirement depends on a specific path — only on the capabilities.
