# Phase 0 Research: Home Feed & Stories

All Technical-Context unknowns resolved below. No `NEEDS CLARIFICATION` remain (the four spec
clarifications from Session 2026-07-01 pre-decided media count, "Your story" behavior, refresh
triggers, and seen persistence).

---

## D1 — Feed contract source of truth

**Decision**: Model the feed on the **real backend B#004 posts-feed contract**
(`backend/specs/004-posts-feed/contracts/openapi.yaml`): `GET /feed` → `FeedPage {items:Post[],
nextCursor?, hasMore}`; `POST|DELETE /posts/{id}/like`, `POST|DELETE /posts/{id}/save` →
`EngagementState {postId, likeCount, saveCount, viewerHasLiked, viewerHasSaved}`. Reuse the #002
`CursorPage<T>`/`PageRequest` envelope (identical `{items,nextCursor,hasMore}` shape).

**Rationale**: The backend contract exists and is stable; matching it now means the `env:['real']`
seam is real (not fictional) and the fake synthesizes contract-shaped payloads, so the client is
correct the moment a dev backend is pointed at it (Constitution VIII).

**Alternatives**: Invent a client-only feed shape — rejected (would diverge from the shipped
backend and break at cutover).

---

## D2 — Feed list source: drift-reactive vs in-memory `PaginatedListCubit`

**Decision**: The feed list is **backed by the drift `Posts` cache and read reactively**
(`PostsDao.watchHomeFeed()` → `Stream<List<Post>>`), NOT held in the #002 in-memory
`PaginatedListCubit<T>`. `FeedCubit` owns cursor/`hasMore` state and drives pagination
(first/next/refresh) by **upserting pages into drift**; the watch stream is the single render
source. Optimistic like/save writes the toggled `Post` to drift first (instant UI via the stream),
then reconciles with the server `EngagementState` (or rolls back).

**Rationale**: Constitution IX requires "one canonical cached representation that all screens read …
via a reactive cache/stream". A drift-backed list gives instant cold-start (SC-001), automatic
consistency across every on-screen copy (FR-013), and offline-from-cache for free. Holding items in
the in-memory `PaginatedListCubit` would create a second copy that drifts from the cache and from
future screens (post detail #006, profile #010).

**Alternatives**: (a) `PaginatedListCubit<Post>` in memory + separate cache — rejected (two sources
of truth). (b) No cache, network-only — rejected (fails SC-001 cold-start + offline FR-004).
The `CursorPage`/`PageRequest` envelope and its cursor/`hasMore` semantics are still reused inside
`FeedCubit`; only the item *storage* differs.

**Feed ordering in cache**: reverse-chronological is `ORDER BY createdAt DESC`. Only the home feed
writes `Posts` in #004, so a dedicated feed-order index table is unnecessary now (YAGNI,
Constitution XIII). `refresh()` clears + repopulates from the first page; `loadMore()` appends
older posts; dedupe by `id` on upsert.

---

## D3 — Post media rendering (single image)

**Decision**: Parse the full contract `media: PostMedia[]` array but **render only the first
image** in `PostCard` (`media[0].media` → `variants` delivery URL). Multi-image carousels are out
of scope (spec clarification → deferred to #007). Video-kind media is not rendered inline in #004
(reels = #008); the fake produces `kind:image, status:ready` single-item arrays.

**Rationale**: The existing `PostCard` takes a single `ImageProvider? media`; single-image matches
it with zero component change and satisfies the clarified scope. Keeping the array in the model
avoids a breaking model change when carousels arrive.

**Alternatives**: Extend `PostCard` to a `PageView` carousel now — rejected (scope creep; clarified
out).

---

## D4 — Optimistic engagement + idempotency

**Decision**: Like/save follow the constitution IX pattern: (1) toggle the canonical `Post` in
drift immediately; (2) call `POST|DELETE /posts/{id}/like|save` via `ApiClient` with an
idempotency key (`ApiClient.post(idempotent:true)`); (3) on success reconcile counts/flags from the
returned `EngagementState`; (4) on failure re-upsert the prior `Post` and surface a `Toast`. The
server contract is explicitly idempotent (liking an already-liked post is a no-op), so a retry
never double-applies (FR-012/FR-016).

**Rationale**: Instant feel (SC-003) with server-authoritative reconcile and safe retries. Reusing
`EngagementState` means the client never guesses counts — it adopts the server's numbers.

**Alternatives**: Fire-and-forget optimism with no reconcile — rejected (counts drift from server).

---

## D5 — Stories: no backend contract yet

**Decision**: There is **no backend stories contract** (only auth/posts/media/comments exist).
Stories ship a **client-defined domain** (`StoryReel`, `StorySegment`) and a **fake repository**
(`env:['fake']`, the one that runs) that synthesizes deterministic reels for followed accounts +
the current user. A **real-seam** `StoriesRepositoryImpl` (`env:['real']`) is registered for
graph completeness under the `real` environment but targets **provisional** endpoints and returns a
safe default (`Result.err(offline)` / empty) until a backend stories spec lands — documented as a
follow-up. The app runs `fake`, so the seam is never exercised in #004.

**Rationale**: Constitution VIII/XII require every repository to have a fake and the app to build
under both environments; a documented placeholder real impl keeps the DI graph valid without
asserting a fictional contract (same approach #002 used for not-yet-built endpoints).

**Alternatives**: Omit the real registration — rejected (breaks `env:['real']` graph resolution).
Fabricate a full stories OpenAPI now — rejected (backend owns that contract; would risk drift).

---

## D6 — Story seen-state persistence

**Decision**: Persist **only seen-state** in drift (`StorySeenSegments` table: `segmentId` PK +
`seenAt`), not the synthesized reels/segments themselves. The rail ring is `unseen` when a reel has
any segment not in the seen set; viewing marks each shown segment seen (`StorySeenDao.markSeen`),
which the rail observes via `watchSeen()`. Seen survives relaunch (spec clarification).

**Rationale**: The fake regenerates identical deterministic reels each launch, so only the
*viewer-specific* seen-state needs durability. Minimal table, satisfies FR-027 + SC without caching
full story media (lighter than a full stories cache, which a future backend spec will own).

**Alternatives**: Persist full reels + seen — rejected (premature; fake is deterministic).
Session-only seen — rejected (spec clarified seen must persist).

---

## D7 — Story viewer playback & Reduce-Motion

**Decision**: `StoryViewerCubit` models playback as `{reelIndex, segmentIndex, progress 0..1,
paused}`. Segments auto-advance on a per-segment duration (default **5 s** image; a segment may
carry its own `durationMs`); a `Ticker`/periodic timer drives `progress`. Tap right region → next
segment, left region → previous; press-and-hold → `paused=true`, release → resume. After a reel's
last segment → next reel; after the last reel → close. **Reduce-Motion** (from `MediaQuery`) keeps
auto-advance/progress but removes decorative crossfades/animated transitions (FR-033).

**Rationale**: Matches Screen 8 and the constitution's Reduce-Motion rule; timer-driven progress is
deterministic and testable (inject a clock/fake ticker in `bloc_test`).

**Alternatives**: `video_player`-driven timing — rejected (no video segments in #004).

---

## D8 — Drift schema migration v2 → v3

**Decision**: Bump `AppDatabase.schemaVersion` 2 → 3. `onUpgrade`: when `from < 3`, create `Posts`
+ `StorySeenSegments`. Extend `clearUserScoped()` to also delete both (feed + seen are user-scoped;
wiped on logout/forced-logout per Constitution I). Add a v2→v3 migration test (and keep the v1→v2
test) — Constitution IX requires covering every prior version.

**Rationale**: Non-destructive, additive; matches the #003 v1→v2 pattern exactly.

**Alternatives**: Recreate DB — rejected (destructive, violates IX).

---

## D9 — Adaptive layout & header placeholders

**Decision**: Reuse the #001 `AdaptiveShell`. Home renders: `TopBar` (Wordmark + Activity bell w/
unseen dot + Messages icon) → `StoriesRail` → feed list. `<700` single column under bottom nav;
`≥700` centered ~560 column + sidebar rail; `≥1100` add a right rail (footer links + static
`SearchBar` — no navigation, no suggestions). Activity/Messages icons are **inert placeholders**
(no route target yet → no-op, never a dead route). Story viewer is a pushed nav-less full-screen
route on all widths.

**Rationale**: Constitution VI/VII adaptive-by-width; the placeholders keep the header faithful to
Screen 7 without pulling in #012/#013 scope.

**Alternatives**: Hide placeholders until their features exist — rejected (diverges from design).

---

## D10 — Dependencies

**Decision**: **No new packages.** Everything reuses the existing stack (`flutter_bloc`, `drift`,
`dio`, `cached_network_image`, `freezed`, `intl`, `lucide_icons_flutter`). `cached_network_image`
with bounded `cacheWidth` fulfills the #001 carried follow-up for feed thumbnails.

**Rationale**: Constitution XIII/XV — add nothing without a concrete need; the feed/stories UI is
buildable from existing primitives.

---

## Summary of decisions

| # | Decision |
|---|---|
| D1 | Feed = real B#004 contract (`/feed`, `/posts/{id}/like|save`, cursor envelope) |
| D2 | Feed list drift-reactive (canonical `Post`), `FeedCubit` owns cursor; not in-memory `PaginatedListCubit` |
| D3 | Render `media[0]` image; parse full array; carousel deferred |
| D4 | Optimistic like/save → drift → server → reconcile `EngagementState` / rollback; idempotent |
| D5 | Stories fake-only; real seam provisional (no backend contract) |
| D6 | Persist seen-state only (`StorySeenSegments`); reels synthesized deterministically |
| D7 | `StoryViewerCubit` timer playback (5 s default); Reduce-Motion keeps advance, drops decoration |
| D8 | drift v2→v3 additive migration + test; `clearUserScoped()` extended |
| D9 | Reuse `AdaptiveShell`; header Activity/Messages inert; right rail static; viewer full-screen |
| D10 | No new packages |
