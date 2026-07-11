---
description: "Task list for Settings, Privacy & Safety (#014)"
---

# Tasks: Settings, Privacy & Safety

**Input**: Design documents from `specs/014-settings-privacy/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/settings-privacy-api.md](contracts/settings-privacy-api.md), [quickstart.md](quickstart.md)

**Tests**: INCLUDED — Constitution XII mandates bloc_test for all cubits + widget/golden for engagement-critical flows + log-redaction; every prior We36 spec shipped this coverage.

**Organization**: Grouped by user story (US1–US7) for independent implementation/testing. App runs DI `environment: 'fake'` (zero-network); real impls are `env:['real']`, source-reconciled to [contracts](contracts/settings-privacy-api.md).

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependency on incomplete tasks)
- **[Story]**: US1–US7 (Setup/Foundational/Polish carry no story label)
- After any task that adds freezed/DTO/DI/injectable code, run: `dart run build_runner build --delete-conflicting-outputs`

---

## Phase 1: Setup (Shared Infrastructure)

- [X] T001 Add `package_info_plus` to `pubspec.yaml` (look up latest stable + platform mins on pub.dev per Constitution XV — do NOT guess the version), then `flutter pub get`. `shared_preferences` already present.
- [X] T002 [P] Scaffold folders: `lib/features/settings/{presentation/{cubit,pages,widgets},domain/usecases}`, `lib/core/data/{settings,moderation/dto,close_friends,social}`, `lib/core/services/preferences/`.
- [X] T003 [P] Add all #014 endpoint constants to `lib/core/constants/api_endpoints.dart`: `meSettings` (`/me/settings`), `followRequests` (`/me/follow-requests`), `followRequestAccept(id)`, `followRequestReject(id)`, `userBlock(id)` (`/users/:id/block`), `meBlocks` (`/me/blocks` — mark "pending B#014"), `reports` (`/reports`), `closeFriends` (`/me/close-friends`), `closeFriend(id)`. Cite backend source per [contract](contracts/settings-privacy-api.md).
- [X] T004 [P] Add settings child-route constants to `lib/core/constants/app_routes.dart`: `settingsPrivacy`, `settingsFollowRequests`, `settingsBlocked`, `settingsCloseFriends`, `settingsLanguage`, `settingsTheme`, `settingsTwoFactor`, `settingsDataExport` (all under `/settings/...`). No hardcoded paths at call sites (Constitution X).
- [X] T005 [P] Add EN+VI ARB key scaffolds in `lib/l10n/arb/{app_en.arb,app_vi.arb}` for the settings/privacy/safety surface (group headers, toggles, report reasons, confirmations) — each with `@description` (Constitution XIV).

---

## Phase 2: Foundational (Blocking Prerequisites)

**⚠️ CRITICAL**: shared building blocks every settings surface reuses. Complete before user-story UI.

- [X] T006 [P] Build shared `SettingsRow` in `lib/core/presentation/settings_row.dart` — label + optional leading icon + trailing (switch | chevron+value | none), tokens-only, `Semantics` + text-scaling + light/dark; compose from `Pressable`/`AppSwitch`/`AppIcon`.
- [X] T007 [P] Build shared `SettingsSectionHeader` in `lib/core/presentation/settings_section_header.dart` (group label, tokenized).
- [X] T008 [P] Widget + golden test for `SettingsRow` (switch/chevron/value variants, light+dark) in `test/core/presentation/settings_row_test.dart`.

**Checkpoint**: shared row/header ready — user stories can begin.

---

## Phase 3: User Story 1 — Reach and navigate my Settings (Priority: P1) 🎯 MVP

**Goal**: Grouped Settings hub reachable from profile, with About (version/build) and working logout.

**Independent Test**: Profile → gear opens Settings; groups render; each row navigates; About shows version/build; Log out → confirm → sign-in. (SC-001)

- [X] T009 [P] [US1] `AboutSection` widget in `lib/features/settings/presentation/widgets/about_section.dart` reading app name/version/build via `package_info_plus`.
- [X] T010 [US1] `SettingsPage` shell in `lib/features/settings/presentation/pages/settings_page.dart` — grouped `SettingsSectionHeader` + `SettingsRow`s (Account [incl. **Edit profile** row → `context.push(AppRoutes.editProfile)`, FR-002] / Privacy / Notifications / Language / Theme / About) navigating via `context.push(AppRoutes.settings*)`; About section; adaptive (`MaxWidthBox` centered on tablet).
- [X] T011 [US1] Repoint `AppRoutes.settings` from `PlaceholderPage` to `SettingsPage` in `lib/core/router/app_router.dart`; confirm the profile gear entry (`my_profile_page.dart`) still navigates.
- [X] T012 [US1] Logout `SettingsRow` → `showAppDialog` confirm → `getIt<SessionController>().signOut()` (no cross-feature import; via DI).
- [X] T013 [P] [US1] EN+VI ARB copy for hub group headers, About labels, logout confirm.
- [X] T014 [P] [US1] Widget test `test/features/settings/settings_page_test.dart` — groups render, rows navigate (stubbed router), About shows version, logout triggers confirm. (Seed a stub — no real drift I/O per [memory gotcha].)
- [X] T015 [P] [US1] Golden `settings_page` light + dark.
- [X] T016 [US1] a11y labels on every hub row (screen-reader label + role).

**Checkpoint**: US1 independently functional — the MVP shell ships.

---

## Phase 4: User Story 2 — Private account + approve followers (Priority: P1)

**Goal**: Private-account toggle; owner-side follow-request inbox with optimistic Approve/Decline.

**Independent Test**: Toggle private; a pending request appears; Approve → follower +1, row gone; Decline → gone, no count change; retry Approve → exactly one follower. (SC-002, SC-003, FR-011/012)

### Settings data layer (shared with US6)

- [X] T017 [P] [US2] `AccountSettings` + `NotificationPrefs` freezed models in `lib/core/data/settings/account_settings.dart`.
- [X] T018 [P] [US2] `SettingsViewDto` (+ `NotificationPrefsDto`) with generated JSON + mapper in `lib/core/data/settings/dto/settings_view_dto.dart`.
- [X] T019 [US2] `SettingsRepository` interface + `SettingsRepositoryImpl` (`env:['real']`, GET/PATCH `/me/settings`) + `FakeSettingsRepository` (`env:['fake']`) in `lib/core/data/settings/`.
- [X] T020 [US2] `SettingsCubit` (4-state) in `lib/features/settings/presentation/cubit/settings_cubit.dart` — load settings; `togglePrivate()` optimistic PATCH + rollback (`loadedSubmitting`).

### Follow-request inbox

- [X] T021 [P] [US2] `FollowRequest` freezed model in `lib/core/data/social/follow_request.dart` (reuse `UserSummary`, `requestedAt`).
- [X] T022 [P] [US2] `FollowRequestDto` + `FollowRequestPageDto` (+ mapper) in `lib/core/data/social/dto/`.
- [X] T023 [US2] `FollowRequestsRepository` interface + real (`env:['real']`: GET list, accept, reject) + `FakeFollowRequestsRepository` (`env:['fake']`, seeded pending requests) in `lib/core/data/social/`.
- [X] T024 [US2] `FollowRequestsCubit` (4-state, cursor-paginated via `PaginatedListCubit` pattern) — accept/decline optimistic, on accept update canonical `RelationshipStore` + follower count; idempotent via Idempotency-Key header; reconcile `NOT_FOUND` (remove row).
- [X] T025 [US2] `PrivacyPage` in `lib/features/settings/presentation/pages/privacy_page.dart` — private-account `AppSwitch` (via `SettingsCubit`) + a "Follow requests" row (count) → follow-requests page.
- [X] T026 [US2] `FollowRequestsPage` + `request_tile.dart` widget (avatar, name, relative time, Approve/Decline) in `lib/features/settings/presentation/{pages,widgets}/`.
- [X] T027 [P] [US2] EN+VI ARB for privacy toggle, follow-requests, approve/decline, empty state.
- [X] T028 [P] [US2] Tests: `fake_settings_repository_test`, `settings_cubit_test` (toggle + rollback); `fake_follow_requests_repository_test`, `follow_requests_cubit_test` (load/accept/decline/rollback/idempotent/not-found) in `test/features/settings/` + `test/core/data/`.
- [X] T029 [P] [US2] Widget + golden for `FollowRequestsPage` (loaded/empty, light+dark) with a stub cubit.

**Checkpoint**: US1 + US2 both independently testable.

---

## Phase 5: User Story 3 — Block and report to stay safe (Priority: P1)

**Goal**: Block hides content immediately across surfaces + Blocked-accounts list; Report with fixed reasons.

**Independent Test**: Block from a profile → content gone from feed/search/DM without reload; Unblock restores (no follow restore); Report → pick reason → ack. (SC-004/005, FR-014–020)

### Core block seam

- [X] T030 [US3] `BlockedUsersStore` (core, `@lazySingleton`, session, reactive `Stream<Set<String>>`, `isBlocked`, `add`/`remove`, `clear`) in `lib/core/data/moderation/blocked_users_store.dart`.
- [X] T031 [US3] Wire `_blockedUsers.clear()` into `SessionController._clearSession()` (logout wipe, FR-033) in `lib/core/services/session/session_controller.dart`.

### Block + report repositories

- [X] T032 [P] [US3] `BlockRepository` interface + real (`env:['real']`: POST/DELETE `/users/:id/block`; `listBlocked()` → pending `/me/blocks`, throws `unimplemented`/returns empty with TODO) + `FakeBlockRepository` (`env:['fake']`, full block/unblock + seeded blocked list) in `lib/core/data/moderation/`.
- [X] T033 [P] [US3] `ReportDraft` + `ReportTargetType`/`ReportReason` enums (backend-aligned, research D2) in `lib/core/data/moderation/report.dart`; `ReportCreateDto`/`ReportAckDto` (+ mapper) in `dto/`.
- [X] T034 [P] [US3] `ReportRepository` interface + real (`env:['real']`: POST `/reports`) + `FakeReportRepository` (`env:['fake']`, ack) in `lib/core/data/moderation/`.
- [X] T035 [US3] Block use case: optimistic — flip `RelationshipStore` (`blocking=true`, sever follow both ways, `requested=false`), `BlockedUsersStore.add`, call repo, rollback on failure (FR-015). Unblock symmetric (no follow restore, FR-016).

### Cross-surface enforcement (Constitution XI — via core store, no feature imports)

- [X] T036 [US3] Wire feed to filter `BlockedUsersStore.blockedIds` reactively (`lib/features/feed/...` read core store); blocked authors drop in-session.
- [X] T037 [P] [US3] Wire search results + explore to filter `BlockedUsersStore`.
- [X] T038 [P] [US3] Wire messaging conversation list to hide/remove blocked participants; wire notifications to filter blocked actors.

### UI + wiring existing stubs

- [X] T039 [US3] `BlockedAccountsCubit` (4-state, paginated) + `BlockedAccountsPage` + `blocked_row.dart` (unblock action) in `lib/features/settings/presentation/`.
- [X] T040 [US3] `ReportSheet` (reason picker over `showAppActionSheet`/modal) in `lib/features/settings/presentation/widgets/report_sheet.dart` → `ReportRepository` → ack toast.
- [X] T041 [US3] Replace surface-only stubs with real calls: profile more-sheet (`user_profile_page.dart` block/report), reel more-sheet (`reel_more_sheet.dart` report), comment report → route to block use case / `ReportSheet`.
- [X] T069 [US3] Add block + report entry points to the **DM surface** (FR-013/018, Constitution I) — conversation/chat overflow more-menu in `lib/features/messaging/presentation/` → block use case (`targetType: user`) + `ReportSheet` (`targetType: message|user`). None exists today (seam scan); wire via DI, no cross-feature import.
- [X] T070 [US3] Add block + report entry points to the **story viewer** more-menu (FR-013/018, Constitution I) in `lib/features/stories/presentation/` → block use case + `ReportSheet` (`targetType: story|user`).
- [X] T071 [P] [US3] Widget test: block/report reachable from DM overflow + story viewer; blocking from a conversation removes it from the list (ties to T038).
- [X] T042 [P] [US3] EN+VI ARB for block/unblock confirms, blocked-accounts, report reasons (9 backend-aligned), ack.
- [X] T043 [P] [US3] Tests: `blocked_users_store_test`, `fake_block_repository_test`, block use-case (optimistic + rollback + mutual-sever + idempotent), `fake_report_repository_test`, cross-surface filter test (feed/search hide blocked), `blocked_accounts_cubit_test`.
- [X] T044 [P] [US3] Widget + golden `BlockedAccountsPage` + `ReportSheet` (light+dark) with stub cubits.
- [X] T045 [US3] Log-redaction test: block/unblock/report actions leak no tokens/PII (FR-034/SC-008).

**Checkpoint**: US1–US3 (all P1) independently functional — core privacy/safety shipped.

---

## Phase 6: User Story 4 — Curate my Close Friends list (Priority: P2)

**Goal**: View/add/remove close friends; membership persists, idempotent; feeds the #005 audience.

**Independent Test**: Add accounts (only followers addable), remove one, reopen → persisted, no dupes. (FR-021/022/023)

- [X] T046 [P] [US4] `CloseFriendsRepository` interface + real (`env:['real']`: GET/POST/DELETE `/me/close-friends`) + `FakeCloseFriendsRepository` (`env:['fake']`) in `lib/core/data/close_friends/` (items reuse `UserSummary`).
- [X] T047 [US4] `CloseFriendsCubit` (4-state, paginated) — add/remove optimistic + rollback; surface backend `VALIDATION` ("must follow you first") as a friendly message.
- [X] T048 [US4] `CloseFriendsPage` + `close_friend_row.dart` + add-picker (search followers) in `lib/features/settings/presentation/`.
- [X] T049 [P] [US4] EN+VI ARB for close-friends surface + guard message.
- [X] T050 [P] [US4] Tests: `fake_close_friends_repository_test`, `close_friends_cubit_test` (add/remove/idempotent/guard); widget + golden with stub cubit.

**Checkpoint**: US4 works; close-friends audience (#005) now manageable.

---

## Phase 7: User Story 5 — Language & theme (Priority: P2)

**Goal**: Device-scoped language (EN/VI/System) + theme (Light/Dark/System), persisted across launches.

**Independent Test**: Switch VI → copy changes; Dark → palette changes; relaunch → both persist; System → follows device. (SC-006, FR-024–027)

- [X] T051 [P] [US5] `AppPreferences` interface + `@LazySingleton(as: AppPreferences)` impl over `SharedPreferencesAsync` (keys `themeMode`, `locale`; device-scoped, survives logout) in `lib/core/services/preferences/app_preferences.dart`.
- [X] T052 [US5] `AppSettingsCubit` (`@lazySingleton`, holds `{ThemeMode, Locale?}`, setters persist via `AppPreferences`) in `lib/features/settings/presentation/cubit/app_settings_cubit.dart` (or `core`).
- [X] T053 [US5] Wire `We36App` (`lib/app/app.dart`) to read `AppSettingsCubit` (BlocProvider/BlocBuilder or ChangeNotifier) → set `MaterialApp.router` `themeMode:` + `locale:`; load persisted values at startup in `bootstrap.dart`.
- [X] T054 [P] [US5] `LanguagePage` (EN/VI/System radio list) + `ThemePage` (Light/Dark/System) in `lib/features/settings/presentation/pages/`.
- [X] T055 [P] [US5] EN+VI ARB for language/theme options.
- [X] T056 [P] [US5] Tests: `app_preferences_test` (persistence round-trip), `app_settings_cubit_test` (set + persist); widget test that changing theme/locale rebuilds `MaterialApp`.

**Checkpoint**: US5 works; preferences survive relaunch + logout.

---

## Phase 8: User Story 6 — Secondary account, privacy & data controls (Priority: P2)

**Goal**: Activity-status toggle (reciprocal); Two-factor + Download-your-data entry screens.

**Independent Test**: Toggle activity off → messaging presence hidden both ways; open 2FA + data-export entries without error. (FR-028/029)

- [X] T057 [US6] Add `toggleActivityStatus()` to `SettingsCubit` (optimistic PATCH `activityStatusVisible` + rollback); add the switch to `PrivacyPage`.
- [X] T072 [US6] Create a **core `PresenceVisibility` seam** (`@lazySingleton` in `lib/core/data/settings/` or `lib/core/services/`, reactive `Stream<bool>`/value) that `SettingsCubit` writes on `activityStatusVisible` change and messaging reads — resolves the cross-feature boundary (Constitution XI; no `features/settings` import from messaging).
- [X] T058 [US6] Reciprocal presence gate: when `PresenceVisibility` is false, suppress own presence + hide others' active-now/typing in messaging (`active_now_rail`, `conversation_tile`, chat header, `typing_indicator`) — read via the T072 core seam.
- [X] T059 [P] [US6] `TwoFactorEntryPage` (entry-only, explains 2FA, no enrolment) in `lib/features/settings/presentation/pages/two_factor_entry_page.dart`.
- [X] T060 [P] [US6] `DataExportEntryPage` (entry-only) in `lib/features/settings/presentation/pages/data_export_entry_page.dart`.
- [X] T061 [P] [US6] EN+VI ARB for activity-status, 2FA-entry, data-export-entry copy.
- [X] T062 [P] [US6] Tests: `settings_cubit` activity-status toggle + rollback; widget test that presence hides when activity-status off; entry pages render.

**Checkpoint**: US6 works; all functional stories complete.

---

## Phase 9: User Story 7 — Accessible & adaptive (Priority: P3) + Cross-Cutting Polish

**Goal**: Every settings surface a11y-correct, adaptive, light/dark; final gate.

**Independent Test**: 2× text, light+dark, phone+tablet, screen reader → labels present, correct reflow, no clipping. (SC-007, FR-030/031)

- [X] T063 [P] a11y sweep: `Semantics` labels + states on all settings pages/rows/toggles/sheets (privacy, follow-requests, blocked, close-friends, language, theme, report, entries).
- [X] T064 [P] Text-scaling (2×) + light/dark audit across all #014 surfaces; fix any clipping.
- [X] T065 [P] Adaptive: settings surfaces use sidebar/adaptive chrome + centered content on tablet/iPad width (reuse `MaxWidthBox`/`AppBreakpoints`).
- [X] T066 [P] Golden sweep (light+dark) for remaining #014 pages not covered per-story.
- [X] T067 Run [quickstart.md](quickstart.md) scenarios 1–10 in fake mode; fix gaps.
- [X] T068 Pre-commit gate: `dart format .`, `flutter analyze` (zero warnings), `flutter test` (all pass), `dart run bloc_tools:bloc lint .` (note if no local CLI). Update `.claude/claude-app/changelog.md` + `project-context.md` (#014 status) + roadmap.

---

## Dependencies & Execution Order

- **Setup (P1)** → **Foundational (P2, shared row/header)** → user stories.
- **US1 (P1)**: after Foundational. MVP — no dependency on other stories.
- **US2 (P1)**: after Foundational. Builds the shared settings data layer (T017–T020) reused by US6.
- **US3 (P1)**: after Foundational. Independent; cross-surface tasks touch feed/search/messaging/notifications.
- **US4 (P2)**, **US5 (P2)**, **US6 (P2)**: after Foundational. US6's activity-status reuses US2's `SettingsCubit`/`SettingsRepository` (T019/T020) — sequence US2 before US6.
- **US7 (P3)**: after the surfaces it hardens exist (US1–US6).

### Within a story: models → DTO/repo → cubit → page → tests. Optimistic mutations before their rollback tests.

### Parallel opportunities
- All `[P]` Setup (T002–T005) together.
- Foundational T006/T007/T008 together.
- Within US2: T017/T018/T021/T022 (models/DTOs) parallel; then repos; then cubits.
- Within US3: T032/T033/T034 (repos/enums) parallel; T037/T038 cross-surface parallel.
- US4 and US5 can be built in parallel by different developers after Foundational.

---

## Implementation Strategy

- **MVP** = Phase 1 + 2 + **US1** (settings hub + About + logout). Stop, validate, demo.
- **P1 complete** = + US2 + US3 → private/requests + block/report shipped (the privacy/safety core).
- **Incremental** = add US4 → US5 → US6 → US7, each independently testable and demoable.
- **Cutover follow-up** (not a client blocker): implement backend **`GET /me/blocks`** (contract D5) and bind `RealBlockRepository.listBlocked()`.

## Notes

- Widget tests must NOT drive real drift `NativeDatabase` I/O — seed a stub cubit with a fixed 4-state (repo memory: `widget-test-no-real-drift`).
- `[P]` = different files, no incomplete-task dependency.
- Commit after each task or logical group; keep account-scoped state cleared on logout, device prefs exempt.
- Report reasons + block sever semantics + activity reciprocity are locked in [spec Clarifications](spec.md#clarifications) — do not re-decide.
