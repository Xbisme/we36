---
description: "Task list for #010 Profile & Follow (We36 Flutter client)"
---

# Tasks: Profile & Follow

**Input**: Design documents from `specs/010-profile-follow/`
**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/profile-api.md](contracts/profile-api.md)

**Tests**: Included (the repo's pre-commit gate requires `flutter test` green; every prior slice ships bloc/widget/golden/fake/redaction coverage). Widget tests seed **stub cubits** — never real drift I/O inside `testWidgets` (the #009 gate learning).

**Organization**: Grouped by user story (US1–US6 from spec.md). Phase 2 builds the shared `core/data/profile/` slice + `RelationshipStore` that all stories consume. Reuses shipped `MeProfile`/`User`/`ViewerRelationship`/`ExploreItem`/`DiscoveryGridTile`/`CursorPage`/`MediaUploadService`/`/auth/check-username`. **No drift schema change; no new pub dependency.**

## Format: `[ID] [P?] [Story] Description with file path`

- **[P]**: parallelizable (different files, no dependency on an incomplete task).
- **[Story]**: US1–US6 (Setup/Foundational/Polish carry no story label).

---

## Phase 1: Setup (Shared Infrastructure)

- [x] T001 Add profile/follow endpoints to `lib/core/constants/api_endpoints.dart` — `userByUsername` (extend doc → ProfileView), `userFollow(id)` (POST/DELETE), `userFollowers(id)`, `userFollowing(id)`, `userPosts(id)`, `userTagged(id)`, `meUpdate` (PATCH `/me`); reuse `authCheckUsername`. No inline literals elsewhere.
- [x] T002 [P] Add profile routes to `lib/core/constants/app_routes.dart` — `userProfile = '/user/:username'` + `userProfilePath`, `userConnections = '/user/:username/connections'` + path + `?tab=`, `editProfile = '/profile/edit'`.
- [x] T003 [P] Add EN+VI ARB keys in `lib/l10n/arb/app_en.arb` + `app_vi.arb` — follow/following/requested labels, "Follows you", stats labels (posts/followers/following), edit-field labels (name/username/pronouns/website/bio), "Change profile photo", "This account is private", unfollow/withdraw confirm titles+bodies, share/message/report/block acks, edit success/validation/username errors.
- [x] T004 [P] Scaffold folders: `lib/core/data/profile/` and `lib/features/profile/{domain/usecases,presentation/cubit,presentation/widgets}` with barrel-free file placeholders per [plan.md](plan.md) structure.

---

## Phase 2: Foundational (data slice — BLOCKS all user stories)

- [x] T005 [P] `ProfileView` freezed+json in `lib/core/data/profile/profile_view.dart` (`user: User`, `relationship: ViewerRelationship`, `isMe`, `gated` + derivations `showFollowControl`/`showPrivateGate`/`canOpenConnections`).
- [x] T006 [P] `AccountRow` freezed+json in `lib/core/data/profile/account_row.dart` (`user: UserSummary`, `relationship: ViewerRelationship`).
- [x] T007 `RelationshipStore` `@lazySingleton` in `lib/core/data/profile/relationship_store.dart` — `Map<userId, ViewerRelationship>` + per-key broadcast stream; `watch(id)`/`seed(id,rel)`/`apply(id, mutator)`/`clear()`.
- [x] T008 `ProfileRepository` interface in `lib/core/data/profile/profile_repository.dart` — `Result<ProfileView> getProfile(username)`, `Result<FollowResult> follow(id)/unfollow(id)`, `Result<CursorPage<AccountRow>> followers/following(id, cursor?, q?)`, `Result<CursorPage<ExploreItem>> posts/tagged(id, cursor?)` (+ `FollowResult{relationship, followersCount}`).
- [x] T009 `ProfileRemoteDataSource` in `lib/core/data/profile/profile_remote_data_source.dart` — `ApiClient` calls per [contracts/profile-api.md](contracts/profile-api.md) (Idempotency-Key on follow/unfollow); returns typed DTOs.
- [x] T010 `ProfileRepositoryImpl` `@LazySingleton(as: ProfileRepository, env: ['real'])` in `lib/core/data/profile/profile_repository_impl.dart` — maps DTO→domain, seeds `RelationshipStore`, `Result`/`FailureMapper`.
- [x] T011 `FakeProfileRepository` `@LazySingleton(as: ProfileRepository, env: ['fake'])` in `lib/core/data/profile/fake_profile_repository.dart` — in-memory graph (public/private/verified/blocked/follows-you accounts, seeded posts/tagged/followers/following); honors gating + block exclusion; fail-next seams for rollback tests.
- [x] T012 Extend `MeRepository` (+ impl + fake) in `lib/core/data/me/` — add `Future<Result<MeProfile>> updateProfile({displayName, username, pronouns, website, bio, avatarMediaId})` (PATCH `/me`, optimistic cache write) and `Future<Result<bool>> checkUsername(String)` (reuse `/auth/check-username`).
- [x] T013 Run `dart run build_runner build --delete-conflicting-outputs` and verify DI graph resolves `ProfileRepository` + `RelationshipStore` (`env:['fake']` for the app; `['real']` annotated).
- [x] T014 [P] `FakeProfileRepository` tests in `test/core/data/profile/fake_profile_repository_test.dart` — profile-by-handle (public/private/blocked), gating flag, follow→following/requested, followers/following pagination + `q` search, posts/tagged pages, block exclusion.
- [x] T015 [P] `RelationshipStore` test in `test/core/data/profile/relationship_store_test.dart` — seed/watch emits, `apply` mutates + notifies, `clear` resets.

**Checkpoint**: data slice builds + fakes green → user stories can proceed.

---

## Phase 3: US1 — View my own profile (P1) 🎯 MVP

**Goal**: The Profile tab renders the signed-in person's header (avatar/name/handle/bio/website + counts), Posts + Tagged grids, and the Edit/Share/Settings/Create + stats entry points.

**Independent test**: Seed the current user + posts/tagged; open the Profile tab; verify header, Posts grid (reels marked) + pagination, Tagged tab, entry points routed, stats tap → lists, and empty/loading/error/offline states.

- [x] T016 [US1] `profile_usecases.dart` in `lib/features/profile/domain/usecases/` — `WatchMe` (reuse `MeRepository.watchMe`), `LoadMyProfile` (ProfileView isMe), `LoadProfileGrid(id, ProfileTab)` (posts|tagged cursor).
- [x] T017 [US1] `MyProfileCubit` + `MyProfileState` (freezed 4-state: `loaded(ProfileView, grid, activeTab, isOffline)`) in `lib/features/profile/presentation/cubit/` — cache-first header via `watchMe`, background reconcile (FR-005), tab switch, grid pagination.
- [x] T018 [P] [US1] `ProfileStats` widget in `lib/features/profile/presentation/widgets/profile_stats.dart` — posts/followers/following via `CountFormatter`, tappable (followers/following → lists), Semantics.
- [x] T019 [P] [US1] `ProfileHeader` widget in `lib/features/profile/presentation/widgets/profile_header.dart` — `Avatar`+ring, name/@handle/bio/website(violet link), stats; adaptive phone vs. wide (≥700) via `AppBreakpoints`.
- [x] T020 [P] [US1] `ProfileGrid` wrapper in `lib/features/profile/presentation/widgets/profile_grid.dart` — reuses #009 `DiscoveryGrid`/`DiscoveryGridTile` for a uniform Posts/Tagged grid (reels marked), tap → post-detail (#006) / reels (#008).
- [x] T021 [US1] `MyProfilePage` in `lib/features/profile/presentation/my_profile_page.dart` — Posts/Tagged `TabBar`, header, grid, Edit/Share/Settings/Create actions; empty/loading/error-retry/offline states.
- [x] T022 [US1] Wire the **Profile tab** in `lib/core/router/app_router.dart` — replace the #001 placeholder with `BlocProvider(create: getIt<MyProfileCubit>()..loadInitial())` → `MyProfilePage`.
- [x] T023 [P] [US1] `MyProfileCubit` tests in `test/features/profile/my_profile_cubit_test.dart` (`test()`/`blocTest`) — header from cache, grid load + paginate, tab switch, offline flag, error.
- [x] T024 [P] [US1] `MyProfilePage` widget test in `test/features/profile/my_profile_page_test.dart` — **stub cubit** seeded `loaded`; header + grid render, reels marker, entry points present, stats tappable, and **no `FollowButton` on the own profile** (Edit profile shown instead — FR-012) (no real drift).

**Checkpoint**: MVP — own profile is viewable end-to-end.

---

## Phase 4: US2 — Another person's profile & follow (P1)

**Goal**: Open `/user/:username`; header + stats + bio; optimistic Follow/Unfollow (confirm on unfollow), idempotent, canonical relationship + counts; "Follows you"; Message/Report/Block surface-only.

**Independent test**: Seed public/verified/follows-you accounts; open a profile; Follow flips instantly + count +1; forced failure rolls back; Unfollow confirms then reverts; retry yields one net follow; Message/Report/Block only toast.

- [x] T025 [US2] `follow_usecases.dart` in `lib/features/profile/domain/usecases/` — `Follow`/`Unfollow`/`WithdrawRequest`: optimistic `RelationshipStore.apply` + count deltas (viewed follower + own following), `Idempotency-Key`, rollback on failure, last-intent guard.
- [x] T026 [US2] `FollowCubit` + `FollowState` in `lib/features/profile/presentation/cubit/` — seeds from `RelationshipStore.watch(id)`, exposes `busy`; drives every Follow control (profile + list rows).
- [x] T027 [P] [US2] `FollowButton` widget in `lib/features/profile/presentation/widgets/follow_button.dart` — Follow(primary)/Following(secondary)/Requested states; **confirm dialog** (`AppDialog`) on Unfollow + Withdraw; Semantics announces state.
- [x] T028 [US2] `ProfileCubit` + `ProfileState` (other) in `lib/features/profile/presentation/cubit/` — `loaded(ProfileView, grid, activeTab)`; loads by username, seeds `RelationshipStore`, applies optimistic follower-count deltas.
- [x] T029 [US2] `ProfilePage` + widgets `profile_more_sheet.dart` in `lib/features/profile/presentation/` — header (with FollowButton + Message + overflow Report/Block surface-only toasts), "Follows you" chip, grid; adaptive wide on tablet.
- [x] T030 [US2] Add `/user/:username` route in `lib/core/router/app_router.dart` (nav-less push) → `ProfilePage`; own handle redirects to the Profile tab.
- [x] T031 [P] [US2] Follow-logic tests in `test/features/profile/follow_cubit_test.dart` — optimistic follow/unfollow, rollback on failure, idempotent retry = one net (SC-003), count consistency across store watchers (SC-004), withdraw.
- [x] T032 [P] [US2] `ProfilePage` widget test in `test/features/profile/profile_page_test.dart` — **stub cubits**; Follow→Following flip, unfollow confirm dialog appears, "Follows you" shown, surface-only actions toast.

**Checkpoint**: the social graph is usable — following works everywhere it appears.

---

## Phase 5: US3 — Followers & following lists (P2)

**Goal**: Two-tab followers/following list with search; each row a read-write Follow control sharing the canonical store; blocked never shown.

**Independent test**: Seed a profile's followers/following; open lists; tabs + counts; search filters; row toggle behaves like US2 and reflects on the profile; row tap opens profile; pagination; blocked absent.

- [x] T033 [US3] `follow_list_usecases.dart` in `lib/features/profile/domain/usecases/` — `LoadFollowers`/`LoadFollowing` (cursor + `q`), row toggle via the `Follow`/`Unfollow` use cases.
- [x] T034 [US3] `FollowListCubit` + `FollowListState` in `lib/features/profile/presentation/cubit/` — over `PaginatedListCubit<AccountRow>`; tab + `query`; rows seed `RelationshipStore`.
- [x] T035 [P] [US3] `AccountRowTile` widget in `lib/features/profile/presentation/widgets/account_row_tile.dart` — `Avatar` + name/@handle + `FollowButton`; tap → `/user/:username`.
- [x] T036 [US3] `FollowListPage` in `lib/features/profile/presentation/follow_list_page.dart` — two tabs (N followers / N following), `AppSearchBar`, paginated list, empty/loading/error states.
- [x] T037 [US3] Add `/user/:username/connections` route (`?tab=`) in `lib/core/router/app_router.dart`; wire stats-tap navigation from `ProfileStats`.
- [x] T038 [P] [US3] `FollowListCubit` tests in `test/features/profile/follow_list_cubit_test.dart` — pagination (no dupes ≥5 pages), search `q`, row toggle propagates to store (profile reflects), blocked excluded.
- [x] T039 [P] [US3] `FollowListPage` widget test in `test/features/profile/follow_list_page_test.dart` — **stub cubit**; tabs render, search field filters, row tap routes.

---

## Phase 6: US4 — Private accounts, viewer-side (P2)

**Goal**: Private account renders header + counts but gates the grid + connection lists ("This account is private"); Follow → Requested; withdraw confirms; blocked never viewable.

**Independent test**: Seed a private (non-approved) account → grid replaced by gate, counts non-tappable; Follow → Requested; Requested → confirm → withdrawn; seed an approved private account → grid renders; blocked deep-link → empty/error.

- [x] T040 [P] [US4] `PrivateGate` widget in `lib/features/profile/presentation/widgets/private_gate.dart` — "This account is private" state (Semantics), shown when `ProfileView.gated`.
- [x] T041 [US4] Gating in `ProfileCubit`/`ProfilePage` — when `gated`: render `PrivateGate` instead of the grid, make followers/following counts non-navigable (tap → "private" Toast); Follow sets `requested` (via `follow_usecases`).
- [x] T042 [P] [US4] Private-gating tests in `test/features/profile/private_account_test.dart` — gated profile shows no grid items + blocks connection nav; follow→requested; withdraw; approved-follower sees grid; blocked account not viewable (SC-005).

---

## Phase 7: US5 — Edit my profile (P2)

**Goal**: Edit name/username(live availability)/pronouns/website/bio + change photo (pick→crop→upload via #007); optimistic save; discard confirm.

**Independent test**: Open Edit profile pre-filled; username live availability blocks Save when taken; change photo previews new avatar; Save persists + header updates without refresh; forced save failure rolls back; back-out with edits → discard confirm.

- [x] T043 [US5] `edit_profile_usecases.dart` in `lib/features/profile/domain/usecases/` — `LoadEditForm` (from `MeProfile`), `CheckUsername` (debounced), `ChangeAvatar` (PhotoLibrary→crop→`MediaUploadService`→finalize→mediaId), `SaveProfile` (`MeRepository.updateProfile`, optimistic).
- [x] T044 [US5] `EditProfileCubit` + `EditProfileState` in `lib/features/profile/presentation/cubit/` — `editing(form, usernameStatus, saving, avatarUploading)`; dirty tracking; Save gate on `usernameStatus`.
- [x] T045 [P] [US5] `EditFieldRow` widget in `lib/features/profile/presentation/widgets/edit_field_row.dart` — labeled editable row (reuse `AppTextField`), inline validation slot.
- [x] T046 [US5] `EditProfilePage` in `lib/features/profile/presentation/edit_profile_page.dart` — nav-less push; pre-filled fields, live username feedback, Change profile photo (crop 1:1), Save (rose check), discard-confirm on back.
- [x] T047 [US5] Add `/profile/edit` route + wire the own-profile "Edit profile" action to it in `lib/core/router/app_router.dart`.
- [x] T048 [P] [US5] Edit tests in `test/features/profile/edit_profile_cubit_test.dart` — username states (checking/available/taken/invalid), save optimistic + rollback, avatar cancel/fail keeps prior avatar, username-taken-at-save rejected, dirty/discard.
- [x] T049 [P] [US5] `EditProfilePage` widget test in `test/features/profile/edit_profile_page_test.dart` — **stub cubit**; fields pre-filled, Save disabled while taken, discard confirm dialog.

---

## Phase 8: US6 — Inclusive & adaptive (P3)

**Goal**: Harden US1–US5 — a11y labels, 2× text scale, light/dark, phone↔tablet reflow, abbreviated counts.

**Independent test**: Screen-reader labels on stats/tiles/controls; 2× text scale no overflow (light+dark); tablet wide header (avatar 130 + inline actions, centered ~900, more grid columns).

- [x] T050 [P] [US6] a11y + text-scale + adaptive widget test in `test/features/profile/a11y_adaptive_test.dart` — labels on `ProfileStats`/`DiscoveryGridTile`/`FollowButton`; 2× scale no overflow; phone vs ≥700 header reflow.
- [x] T051 [P] [US6] Goldens in `test/features/profile/goldens/` — `ProfileHeader` (own + other), `FollowButton` (follow/following/requested), `PrivateGate`, `AccountRowTile` (light + dark).
- [x] T052 [US6] Verify `CountFormatter` abbreviates stats (12.3k/1.2M) without overflow at 2× scale across header + rows (FR-029).

---

## Phase 9: Polish & Cross-Cutting

- [x] T053 [P] Route every author avatar/username to `/user/:username` — feed `PostCard`, comment author (#006), explore/search `AccountResultRow` (#009), reel author (#008) — via `core/router` (no cross-feature imports).
- [x] T054 [P] Clear `RelationshipStore` on logout — wire into the session cache-wipe path (`SessionController`).
- [x] T055 [P] Log-redaction test in `test/features/profile/log_redaction_test.dart` — no `print`/`debugPrint`; no tokens; handles not logged as secrets.
- [x] T056 [US1] [US2] Confirm all user messages route through `ToastService` (follow errors, save success/failure, surface-only acks) — no `ScaffoldMessenger`.
- [x] T057 Run pre-commit gate (`dart format .`, `flutter analyze` zero warnings, `flutter test` all pass, `dart run bloc_tools:bloc lint .`) + walk [quickstart.md](quickstart.md) US1–US6. **SC-004/SC-006** automated coverage authoritative; on-device VoiceOver/TalkBack + rotation + long-list memory profiling deferred to the **#015** release gate (matches #004/#008/#009).

---

## Dependencies & Execution Order

- **Phase 1 (Setup)** → **Phase 2 (Foundational)** block everything.
- **US1 (P1)** is the MVP and has no dependency on US2–US6.
- **US2 (P1)** depends on Phase 2 (`RelationshipStore`, repo); independent of US1 but shares the header widgets from US1.
- **US3 (P2)** depends on US2 (`FollowButton`, follow use cases).
- **US4 (P2)** depends on US2 (`ProfileCubit`/`ProfilePage` gating).
- **US5 (P2)** depends on Phase 2 (`MeRepository.updateProfile`) + #007 pipeline; independent of US2–US4.
- **US6 (P3)** hardens US1–US5 (do after they exist).
- **Polish** last.

## Parallel Opportunities

- Setup: T002/T003/T004 in parallel after T001.
- Foundational: T005/T006 in parallel; T014/T015 in parallel after the slice builds (T013).
- Within each story, `[P]` widget/test tasks run parallel to sibling widgets (different files).
- US1 and US5 can be built in parallel by two developers (disjoint files) once Phase 2 is done; US2→US3→US4 are a chain.

## Implementation Strategy

- **MVP = Phase 1 + Phase 2 + US1** (own profile viewable). Ship/demo, then layer US2 (follow) → US3 (lists) → US4 (private) → US5 (edit) → US6 (hardening) → Polish.
- Keep the app on DI `environment: 'fake'`; reconcile `contracts/profile-api.md` with the shipped B#010 before wiring `ProfileRepositoryImpl` (`env:['real']`).
