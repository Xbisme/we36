# Phase 0 Research: Profile & Follow (#010)

All decisions below resolve the Technical Context and the spec's clarifications. Because #010 sits on shipped seams, most "research" is confirming the reuse boundary rather than picking new tech. **No new pub dependency; no drift schema change.**

## R1 — Canonical follow-relationship representation (SC-004, Constitution IX)

- **Decision**: One canonical `ViewerRelationship` per userId in an **in-memory reactive `RelationshipStore`** (`@lazySingleton`, `Map<userId, ViewerRelationship>` + a broadcast stream per key; `watch(userId)` / `seed(userId, rel)` / `apply(userId, mutator)`). The `FollowCubit` and `FollowListCubit` both read/write it, so an optimistic follow on the profile reflects in the followers/following rows and vice-versa without a refresh.
- **Rationale**: Relationships are server-authoritative and re-fetched every time a profile/list loads, so persistence across app-kill adds no value; an in-memory reactive store delivers the required within-session canonical reactivity at the lowest cost. Precedent: #005 `OwnStoryStore` bridges write→read in-memory; #006 applied count deltas through the owning repository.
- **Alternatives considered**: (a) a drift `Relationships` table (persisted, reactive) — rejected: unjustified migration + schema-test overhead for session-scoped, re-fetched state; (b) each surface holding its own `ViewerRelationship` copy (as #009 search rows do today) — rejected: violates "one canonical copy" and would drift after an optimistic follow.
- **Cross-feature note**: #009 search/explore result rows embed a read-only `ViewerRelationship` snapshot and are **not** rewired to the store in #010; they reconcile on their next fetch. Live cross-surface sync is scoped to the profile + its followers/following lists (the SC-004 matrix for this feature).

## R2 — Optimistic follow / unfollow / withdraw + counts (FR-007..009, spec clarifications)

- **Decision**: `Follow` applies **instantly** (optimistic): `RelationshipStore.apply` flips `following` (public) or `requested` (private), bumps the viewed account's `followerCount` +1 and the viewer's own `followingCount` +1 in the owning cubit state, then calls `POST /users/{id}/follow` with an `Idempotency-Key`. `Unfollow` and `withdraw-request` first show a **confirmation dialog** (`AppDialog`), then apply the reverse optimistic change and call `DELETE /users/{id}/follow`. On failure, the store + counts **roll back** and a Toast explains. Last-intent wins; a superseded in-flight request is ignored (guard by a per-user busy flag + a monotonic intent token).
- **Rationale**: Matches the shipped optimistic-engagement pattern (#004 like/save, #006 comment count deltas) and the spec clarifications (confirm on unfollow only; own following-count updates optimistically).
- **Idempotency**: the client `Idempotency-Key` per intent means a retry after a transient failure yields exactly one net relationship (SC-003); the server treats a duplicate follow/unfollow as a no-op returning the current `ViewerRelationship`.
- **Alternatives considered**: server-first (await before UI change) — rejected: violates optimistic UX (SC-002). Confirm on every toggle — rejected by clarification (only unfollow/withdraw confirm).

## R3 — Profile grid item + tiles (FR-002/003, reuse)

- **Decision**: The Posts and Tagged grids reuse the #009 `ExploreItem` (kind-tagged `Post`|`Reel`) and the `DiscoveryGrid` / `DiscoveryGridTile` widgets verbatim (a uniform 3-col grid with a reels marker + bounded `cacheWidth`). The profile grid endpoints return `CursorPage<ExploreItem>`.
- **Rationale**: Identical visual + data contract to explore/hashtag grids; zero new tile code, one canonical grid-item model (Constitution XI reuse).
- **Alternatives considered**: a bespoke `ProfileGridItem` — rejected as duplicative; the quilted hero layout of explore is **not** used (profile grids are uniform, per design Screen 20/21).

## R4 — My-profile identity + counts source (FR-001/005)

- **Decision**: The own-profile **header identity** (name/handle/bio/website/avatar/privacy) reuses the existing `MeProfiles` drift cache via `MeRepository.watchMe()` (cold-start from cache, background `GET /me` reconcile — FR-005). The own-profile **counts** (posts/followers/following) come from the profile endpoint as a `ProfileView` for the current user (`isMe = true`); `MeProfile` itself carries no counts and is kept as the editable-identity model only. My own following count is adjusted optimistically in `MyProfileCubit` state when I follow/unfollow elsewhere (reconciled on next `GET`).
- **Rationale**: Reuses the shipped `MeProfiles` cache (no new persistence) while sourcing counts from the same `ProfileView` shape used for other users — one profile-view model for both.
- **Alternatives considered**: extending `MeProfile` with counts — rejected: `MeProfile` is the editable-identity contract (#003); counts belong to the read `ProfileView`.

## R5 — Edit profile: username availability + avatar (FR-021..025)

- **Decision**: Reuse the shipped **`/auth/check-username`** seam (as #003 profile-setup did) for debounced live availability; block Save while checking/taken/invalid; re-validate at Save (a handle taken by then is rejected with a clear message). Avatar reuses the **#007 pipeline**: `PhotoLibraryService` pick → `crop_your_image` (1:1 crop) → `ImageProcessingService` bake → `MediaUploadService` upload → `finalize` → the returned `mediaId` becomes `avatarMediaId` on the `PATCH /me` payload. Save is optimistic (update `MeProfiles` cache + header, roll back on failure). A cancelled/failed avatar upload leaves the previous `avatarMediaId` intact and does not block saving the text fields.
- **Rationale**: Both seams are shipped and proven; avatar is exactly the #003-deferred piece now unblocked by #007.
- **Alternatives considered**: a new avatar-specific upload path — rejected (reuse `MediaUploadService`); free-form username without server check — rejected (uniqueness is server-owned).

## R6 — Private-account gating (FR-017..020, clarification)

- **Decision**: Gating is **server-authoritative** — the `ProfileView` carries an explicit `viewable`/`gated` signal (the API omits/oks the grid based on privacy + relationship). Client behavior: if `gated`, render the header + counts but replace the grid(s) with `PrivateGate` and make the followers/following counts **non-navigable** (tap → "This account is private" Toast). Follow on a private account sets `requested`. A blocked account is never returned by the API (client shows a generic "user not found"/empty state if deep-linked).
- **Rationale**: The client must never re-derive visibility (Constitution constraint); it renders the server's gating flag. Matches the clarification (counts shown, lists gated).
- **Alternatives considered**: client-side privacy inference from `isPrivate && !following` — rejected: the server owns approval state; the client trusts the returned flag.

## R7 — Navigation & routing (FR-004/008/014, adaptive)

- **Decision**: The **Profile tab** (`AppRoutes.profile`) renders `MyProfilePage` (replacing the #001 placeholder). New pushed, nav-less routes: `/user/:username` (`ProfilePage`), `/user/:username/connections?tab=followers|following` (`FollowListPage`), `/profile/edit` (`EditProfilePage`). Every avatar/username across the app (feed author, comment author, explore/search account row, reel author) routes to `/user/:username`; the viewer's own handle routes to the Profile tab instead of a duplicate push. On tablet (≥700) the profile renders a wide centered header; the followers/following list renders within the centered column rather than a separate push.
- **Rationale**: Consistent with the existing `we36://` route table + `AppRoutes` helpers (postDetail/hashtag/place); adaptive reflow via `AppBreakpoints` (as #006/#009).
- **Alternatives considered**: a two-pane master/detail for profile — rejected: profile is single-column centered on tablet (design §Responsive `TabletProfile`), two-pane is reserved for Messages (#012) / Post detail (#006).

## R8 — Testing strategy (repo gate + #009 learning)

- **Decision**: Widget tests seed **stub cubits** with a fixed 4-state (`StubProfileCubit`, `StubFollowCubit`, …) — never drive a real repository over drift `NativeDatabase` inside `testWidgets` (that deadlocks in faked-async; the #009 gate regression). Drift-touching + optimistic/idempotent logic is covered by plain `test()` / `blocTest` cubit tests with the in-memory fake repo + `RelationshipStore`. Coverage: follow optimistic+rollback+idempotency, count-consistency (SC-004), private gating, username-check, avatar-save rollback, log-redaction, a11y/text-scale/adaptive, and goldens for the header / follow button states / private gate / account row.
- **Rationale**: Encodes the #009 gate learning so #010 lands green the first time.

## Resolved unknowns

| Unknown (Technical Context) | Resolution |
|---|---|
| Canonical relationship storage | In-memory reactive `RelationshipStore` (R1) — no drift change |
| Optimistic follow + counts + confirm | R2 (instant follow; confirm unfollow/withdraw; idempotent) |
| Profile grid item | Reuse `ExploreItem` + `DiscoveryGridTile` (R3) |
| Own counts source | `ProfileView(isMe)` from the profile endpoint (R4) |
| Username + avatar | Reuse `/auth/check-username` + #007 pipeline (R5) |
| Private gating | Server flag on `ProfileView`; counts shown, lists gated (R6) |
| Routes | Profile tab + `/user/:username`(+/connections) + `/profile/edit` (R7) |
| B#010 endpoint/DTO shapes | Derived in `contracts/profile-api.md` — **reconcile with the shipped backend** |

## Open item to reconcile with backend

The exact B#010 endpoint paths, follow-response shape, and the private-gating flag name in `contracts/profile-api.md` are **derived from repo conventions** (envelope `{data,…}` / `{error:{code,message,details}}`, `CursorPage<T>`, `Idempotency-Key`) and must be cross-checked against the shipped B#010 contract before/at implementation. No spec requirement depends on a specific path — only on the capabilities.
