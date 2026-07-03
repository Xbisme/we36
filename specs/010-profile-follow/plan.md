# Implementation Plan: Profile & Follow

**Branch**: `010-profile-follow` | **Date**: 2026-07-03 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/010-profile-follow/spec.md`

## Summary

Build the We36 client **identity + social-graph** surface — my profile, another person's profile, followers/following lists, and edit profile — as a new `features/profile/` presentation layer over a small `core/data/profile/` data slice that consumes the already-shipped backend **B#010** contract. It **reuses shipped models**: `MeProfile` (#003, editable identity + `avatarMediaId`), `User` (#002, public account + counts), `ViewerRelationship` (#009, follow state), the kind-tagged `ExploreItem` + `DiscoveryGridTile` (#009) for the Posts/Tagged grids, `CursorPage<T>` + `PaginatedListCubit<T>` (#002) for lists/grids, the `MediaUploadService` + crop pipeline (#007) for the avatar, and `/auth/check-username` (#003) for live username availability. **Follow/unfollow is optimistic + idempotent** and updates one canonical `ViewerRelationship` held in an in-memory reactive `RelationshipStore` (session-scoped; server-authoritative, re-fetched per profile open) so the profile and the followers/following lists stay in sync without a manual refresh; the viewer's own **following** count and the viewed account's **follower** count adjust optimistically in cubit state and reconcile with the server. **Unfollow** and **withdraw-request** confirm first; **Follow** applies instantly. Private accounts are handled **viewer-side only** (Follow → Requested; content grid + followers/following lists gated behind a "private" notice; counts still visible). Message / Share / Report / Block are **surface-only** (defer to #012/#014). Every source has an in-memory fake so the app builds/tests zero-network. **No new drift schema and no new pub dependency.**

## Technical Context

**Language/Version**: Dart 3.12.2 / Flutter 3.44.4 (repo baseline).

**Primary Dependencies**: `flutter_bloc` (4-state freezed Cubits), `get_it`+`injectable` (DI, `env:['real'|'fake']`), `go_router` (routes + nav-less push, tab), `dio` via the shared `ApiClient` + `FailureMapper`, `freezed`+`json_serializable`, `cached_network_image` (bounded avatar/tile decode), `lucide_icons_flutter` via `AppIcon`, `intl` via `CountFormatter`. Reuses `core/data/discovery` (`ExploreItem`), `core/data/me` (`MeProfile`), `core/data/user` (`User`), `core/services/media_upload_service` + `image_processing_service` (#007 crop/upload), `core/domain` (`Result`/`AppFailure`/`CursorPage`/`PaginatedListCubit`). **No new pub dependency.**

**Storage**: **No drift schema change (stays v7).** My-profile identity reuses the existing `MeProfiles` cache (`watchMe`) for the cold-start header (FR-005); the canonical follow relationship lives in an in-memory reactive `RelationshipStore` (`@lazySingleton`, session-scoped — precedent: #005 `OwnStoryStore`); other profiles, grids (Posts/Tagged), and followers/following lists are **live-query** cursor pages (no persistence — matching #009 search).

**Testing**: `flutter_test` + `bloc_test` + `mocktail` (fakes) + golden tests; optimistic-follow rollback + idempotency tests; count-consistency test (SC-004); log-redaction test; a11y/text-scale/adaptive widget tests. Widget tests seed **stub cubits** (never real drift I/O inside `testWidgets` — see the #009 gate learning) with a fixed 4-state.

**Target Platform**: iOS + Android phones + iPad/Android tablets (adaptive by width).

**Project Type**: Mobile app (Flutter client) over a custom REST backend; client-only feature (backend B#010 already shipped).

**Performance Goals**: 60 fps grid/list scroll with a bounded memory ceiling over ≥5 pages; optimistic follow reflects in < 16 ms (local state); avatar/tile images decode at a bounded `cacheWidth`.

**Constraints**: server-authoritative visibility/block (client never re-derives — a blocked/private account is only ever what the API returns); all messages via Toast; semantic tokens only (no hardcoded hex/TextStyle); `lib/core/` must not import `lib/features/`; follow mutations idempotent (client key) + optimistic with rollback; one canonical relationship copy.

**Scale/Scope**: 4 screens (20–23) → My profile, Other profile, Followers/Following (one two-tab screen), Edit profile; ~6 cubits (my-profile, profile[other], follow, follow-list, edit-profile, username-check); 1 new repository (+ real + fake) + 1 in-memory `RelationshipStore`; ~3 new client models (`ProfileView`, `AccountRow`; grid item = reuse `ExploreItem`); cursor pagination + `PaginatedListCubit` reused; avatar via #007 pipeline; **no drift table**.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **I Clean Architecture / feature-first**: New `features/profile/` (presentation) + `core/data/profile/` (data). `core/` never imports `features/`; profile reuses `core/data/{me,user,discovery,feed}` — core→core only. ✅
- **II Media discipline**: Grid tiles reuse the #009 static `DiscoveryGridTile` (bounded `cacheWidth`); avatar decode bounded; no video in grids (reels open into #008). Avatar upload reuses the #007 pipeline. ✅
- **III BLoC 4-state**: Events plain / states freezed `initial/loading/loaded/error` (extended variants prefix the base). Use Cases injected into Cubits, not repos. Page-scoped `BlocProvider`; `@injectable` screen cubits, `@lazySingleton` repo/store/services. ✅
- **IV One API client / repo boundary**: All HTTP via the shared `ApiClient`; widgets/cubits never touch `dio`. New endpoints in `api_endpoints.dart` (no inline literals). ✅
- **V Result/AppFailure**: Repo returns `Result<T>`; errors centralized via `FailureMapper` → `AppFailure` → Toast. ✅
- **VI Design discipline**: Reuse shared `Avatar`+ring, `AppButton` (Follow primary / Following secondary), `AppSearchBar`, `TopBar`, `DiscoveryGridTile`, `CountFormatter`; semantic tokens only; brand color only on Follow CTA / active tab underline / unseen-ring; website link violet. ✅
- **VII Adaptive**: Phone push nav + 3-col grid vs. ≥700 wide header (avatar 130 + inline stats/actions, centered max ~900, responsive grid) via `AppBreakpoints`/`LayoutBuilder` (never device model). Followers/following is a pushed screen on phone; on tablet it renders within the centered profile column. ✅
- **VIII Backend-agnostic + fakes**: Every source has an in-memory fake (`env:['fake']`); app builds/tests zero-network. ✅
- **IX One canonical cached copy**: The follow relationship has **one canonical copy** in the in-memory reactive `RelationshipStore` (keyed by userId), watched by the profile + list cubits so a follow on one surface reflects on the other without a manual refresh (SC-004). *Tradeoff (justified below):* the store is in-memory/session-scoped (not drift-persisted) because relationships are server-authoritative and re-fetched on every profile open — persistence across app-kill adds no value and a schema migration would be unjustified overhead (precedent: #005 `OwnStoryStore`). ✅ (see Complexity Tracking)
- **X Optimistic + idempotent**: Follow/unfollow/withdraw update the canonical relationship + counts immediately, carry a client `Idempotency-Key`, and roll back on failure (last-intent wins; superseded in-flight ignored). Edit-profile save is optimistic with rollback. ✅
- **XI Cross-feature isolation**: `profile` does not import other features' internals; entry from feed/explore/comments/reels is via `core/router` routes; the Create action reuses the existing contextual route. ✅
- **XII Toast + AppLogger**: Toast for all messages; `AppLogger` (redacted) for logging; no `print`/`debugPrint`; no tokens/handles-as-secrets leaked (log-redaction test). ✅

**Result: PASS** (one justified tradeoff under Constitution IX, recorded in Complexity Tracking).

## Project Structure

### Documentation (this feature)

```text
specs/010-profile-follow/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/
│   └── profile-api.md   # Client-consumed B#010 subset (derived — reconcile w/ backend)
└── tasks.md             # /speckit.tasks output (later)
```

### Source Code (repository root)

```text
lib/core/data/profile/                   # NEW data slice
├── profile_view.dart                    # ProfileView (User + ViewerRelationship + isMe + gated) freezed+json
├── account_row.dart                     # AccountRow (UserSummary + ViewerRelationship) for lists freezed+json
├── relationship_store.dart              # @lazySingleton in-memory canonical ViewerRelationship (reactive .watch(userId))
├── profile_repository.dart              # interface (Result<T>): profile-by-handle, follow/unfollow, lists, grids
├── profile_repository_impl.dart         # @LazySingleton(as:…, env:['real'])  → ApiClient
├── fake_profile_repository.dart         # @LazySingleton(as:…, env:['fake'])  → in-memory graph
└── profile_remote_data_source.dart      # ApiClient calls → Result

lib/core/data/me/                        # EXTEND
└── me_repository.dart (+impl,+fake)      # + updateProfile(...) + checkUsername (reuse /auth/check-username)

lib/features/profile/
├── domain/usecases/
│   ├── profile_usecases.dart            # WatchProfile / LoadProfile / LoadProfileGrid (posts|tagged)
│   ├── follow_usecases.dart             # Follow / Unfollow / WithdrawRequest (optimistic, canonical, counts)
│   ├── follow_list_usecases.dart        # LoadFollowers / LoadFollowing (cursor) + row follow toggle
│   └── edit_profile_usecases.dart       # LoadEditForm / CheckUsername / ChangeAvatar / SaveProfile
├── presentation/
│   ├── cubit/
│   │   ├── my_profile_cubit(.dart/_state)      # own profile (watchMe header + grid)
│   │   ├── profile_cubit(.dart/_state)         # other profile (ProfileView + gating)
│   │   ├── follow_cubit(.dart/_state)          # optimistic follow state (drives every Follow control)
│   │   ├── follow_list_cubit(.dart/_state)     # followers/following (PaginatedListCubit-based)
│   │   └── edit_profile_cubit(.dart/_state)    # edit form + username-check + avatar + save
│   ├── my_profile_page.dart             # Screen 20 (Profile tab)
│   ├── profile_page.dart                # Screen 21 (other user; wide on tablet)
│   ├── follow_list_page.dart            # Screen 22 (Followers/Following two-tab)
│   ├── edit_profile_page.dart           # Screen 23 (nav-less push)
│   └── widgets/
│       ├── profile_header.dart          # avatar ring + name/handle/bio/website + stats (adaptive)
│       ├── profile_stats.dart           # posts/followers/following (CountFormatter, tappable)
│       ├── follow_button.dart           # Follow/Following/Requested control (+ unfollow confirm)
│       ├── profile_grid.dart            # reuses DiscoveryGrid/DiscoveryGridTile (#009) for Posts/Tagged
│       ├── private_gate.dart            # "This account is private" state
│       ├── account_row_tile.dart        # list row (avatar + name + FollowButton)
│       └── edit_field_row.dart          # labeled editable row (name/username/pronouns/website/bio)
└── (routes added to core/router/app_router.dart + AppRoutes)
```

**Structure Decision**: Feature-first (matches #004–#009). A new `features/profile/` presentation layer over a thin `core/data/profile/` slice; the own-profile identity + edit reuse the existing `core/data/me` seam (extended with `updateProfile`). The Profile tab (`AppRoutes.profile`) swaps its placeholder for `MyProfilePage`; new pushed routes `/user/:username` (other profile), `/user/:username/connections` (followers/following), `/profile/edit`. The follow relationship is the one canonical entity, held reactively in `RelationshipStore` and consumed by both the profile and the lists.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Canonical relationship in an **in-memory** `RelationshipStore` rather than the drift canonical cache (Constitution IX prefers a persisted reactive copy) | Follow state must be **one canonical, reactive** copy shared by the profile + followers/following lists so an optimistic follow on one surface reflects on the other without a refresh (SC-004). | A drift `Relationships` table (persisted) was rejected: relationships are **server-authoritative and re-fetched on every profile open**, so cross-restart persistence adds no user value while a schema migration + migration test is unjustified overhead. An in-memory reactive store gives the required within-session canonical reactivity at lower cost (precedent: #005 `OwnStoryStore`). Persisted-count deltas are applied in cubit state and reconciled by the server. |
