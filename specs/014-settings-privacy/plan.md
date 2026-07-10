# Implementation Plan: Settings, Privacy & Safety

**Branch**: `014-settings-privacy` | **Date**: 2026-07-10 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/014-settings-privacy/spec.md`

## Summary

Build the We36 **Settings surface** (Screens 30–32) and the **privacy/safety controls** other features enforce: a grouped Settings hub (Account/Privacy/Notifications/Language/Theme/About, logout, About version); **private account** + a new owner-side **follow-request approval inbox**; **blocking** (immediate cross-surface content hiding + a Blocked-accounts list) and **report** (fixed reason set, surface-only ack); **close-friends** list management (the audience #005 already consumes); **activity status** (reciprocal presence visibility); device-scoped **language & theme**; and entry-only Two-factor / Download-your-data.

Technical approach: **contract-driven client** over the already-shipped backend settings/privacy/safety modules (source-verified — see [research.md](research.md) D1). New `core/data` slices (`settings`, `moderation`, `social`/follow-requests, `close_friends`) each with a real (`env:['real']`) + fake (`env:['fake']`) repository; a new **core `BlockedUsersStore`** as the cross-feature seam so blocked content vanishes in-session (Constitution XI); the canonical `RelationshipStore` (#010) reused for accept/block optimistic mutations; a new device-scoped `AppPreferences` (shared_preferences) + app-level `AppSettingsCubit` feeding `MaterialApp.router` for theme/locale. **No drift schema change** (stays v10). One new dependency: `package_info_plus`. One flagged backend gap: **`GET /me/blocks`** (built fake-first, bound at cutover).

## Technical Context

**Language/Version**: Dart 3.12.2 / Flutter 3.44.4 (repo canonical baseline).

**Primary Dependencies**: `flutter_bloc`, `get_it`+`injectable`, `go_router`, `freezed`+`json_serializable`, `dio` (ApiClient), `drift` (unchanged), `shared_preferences` (present), **`package_info_plus` (NEW)**. No `firebase`/realtime changes.

**Storage**: device-scoped prefs via `shared_preferences` (theme/locale); on-demand REST fetch + session in-memory stores for settings/requests/blocked/close-friends. **No new drift table** (research D9).

**Testing**: `bloc_test` + `mocktail` + golden + a11y/redaction; hermetic against fakes (`environment: 'fake'`).

**Target Platform**: iOS 15+ / Android (phones + tablets/iPad adaptive).

**Project Type**: Mobile app (Flutter), feature-first Clean Architecture.

**Performance Goals**: 60 fps lists; settings toggles feel instant (optimistic); no jank on paginated request/close-friends/blocked lists.

**Constraints**: offline-graceful (toggles roll back; theme/locale still apply); no secrets/PII in logs; EN+VI ARB; light+dark; 2× text scale.

**Scale/Scope**: 3 designed screens (30–32) + child surfaces (follow-requests inbox, blocked accounts, close-friends, privacy&security, language, theme, 2FA-entry, download-data-entry, report modal). ~5 new repositories, ~6 cubits, 1 core store, 1 prefs service.

## Constitution Check

*GATE: must pass before Phase 0 and re-checked after Phase 1.*

| Principle | Status | How this plan complies |
|---|---|---|
| I. Privacy, Safety & Trust | ✅ **Core of the feature** | Block reachable from every surface + enforced immediately (BlockedUsersStore); private account respects server verdict; close-friends enforced at render (#005); no tokens/PII in logs (FR-034/SC-008); report surface-only. Extra review scrutiny expected. |
| II. Media performance | ✅ light | No new media surfaces; lists are cursor-paginated (follow-requests, close-friends, blocked). |
| III. BLoC 4-state | ✅ | All feature cubits use `initial→loading→loaded→error` with prefixed extended variants (`loadedSubmitting`); `AppSettingsCubit` is a simple non-async cubit (holds theme/locale). |
| IV. Dart safety | ✅ | freezed immutables; generated JSON on DTOs; explicit types; `very_good_analysis` zero-warning. |
| V. Result<T> | ✅ | Repositories return `Result<T>`; cubits `.fold()`; central `FailureMapper`; add-close-friend `VALIDATION`→field message; no try/catch in cubits. |
| VI. Design system | ✅ | Semantic tokens only; build `SettingsRow`/`SettingsSectionHeader` once in `core/presentation/` from `Pressable`/`AppSwitch`; reuse `ActionSheet`/`AppDialog`/`Toast`; **fixed palette — theme picker is light/dark/system only (explicitly allowed by VI)**. |
| VII. Native/adaptive | ✅ | Phone list ↔ tablet sidebar/adaptive chrome; `package_info_plus` verified at T001 (XV); no new permissions/entitlements. |
| VIII. API & realtime | ✅ | Repositories behind ApiClient; endpoints/events centralized in `constants/`; no new socket events (activity-status reuses presence); cursor envelope reused. |
| IX. Data integrity / optimistic | ✅ | One canonical `RelationshipStore` + one `BlockedUsersStore`; optimistic block/accept/decline/toggle with rollback; idempotent accept/block via header. |
| X. go_router | ✅ | `AppRoutes.settings` exists; add child route constants (no hardcoded paths); report is a modal; deep-link `settings` already known. |
| XI. Feature-first modularity | ✅ | `core/` holds shared stores/repos; features read `BlockedUsersStore` via DI — **no `features/settings` import from feed/search/messaging**. |
| XII. Testing | ✅ | Fakes for every new repo; bloc_test all cubits; widget + golden for settings surfaces; a11y + redaction tests. |
| XIII. Simplicity/YAGNI | ✅ | No drift table; 2FA/data-export entry-only; no `in_app_review`; notification prefs = on/off toggles only. |
| XIV. i18n | ✅ | All new copy EN+VI ARB with `@description`; relative-time on requests via shared `intl` helper. |
| XV. Dependency hygiene | ✅ | Only `package_info_plus`; pin latest stable + verify platform mins from pub.dev at T001 before editing pubspec. |

**Result: PASS** (no violations; Complexity Tracking not required). Privacy/safety changes flagged for extra review per Governance.

## Project Structure

### Documentation (this feature)

```text
specs/014-settings-privacy/
├── plan.md              # this file
├── spec.md              # feature spec (+ Clarifications)
├── research.md          # Phase 0 — decisions D1–D11
├── data-model.md        # Phase 1 — models, stores, cubits
├── contracts/
│   └── settings-privacy-api.md   # source-verified B#014 contract (+ GET /me/blocks gap)
├── quickstart.md        # Phase 1 — validation scenarios
├── checklists/
│   └── requirements.md  # spec quality checklist (passing)
└── tasks.md             # Phase 2 — /speckit.tasks (NOT created here)
```

### Source Code (repository root)

```text
lib/
├── app/
│   └── app.dart                          # We36App → stateful/provider; reads AppSettingsCubit → themeMode/locale
├── core/
│   ├── constants/
│   │   ├── api_endpoints.dart            # + /me/settings, /me/follow-requests(+accept/reject),
│   │   │                                 #   /users/:id/block, /reports, /me/close-friends, (pending /me/blocks)
│   │   └── app_routes.dart               # + settings child routes (followRequests, blockedAccounts, closeFriends, privacy, twoFactor, dataExport)
│   ├── data/
│   │   ├── settings/                     # AccountSettings + NotificationPrefs, SettingsRepository (real+fake), remote source, dto
│   │   ├── social/                       # FollowRequest, FollowRequestsRepository (real+fake), dto  (or under profile/)
│   │   ├── moderation/                   # BlockRepository (real+fake), ReportRepository (real+fake),
│   │   │   ├── blocked_users_store.dart  #   NEW core cross-feature seam (@lazySingleton, session, clear() on logout)
│   │   │   └── dto/
│   │   └── close_friends/                # CloseFriendsRepository (real+fake), dto (reuses UserSummary)
│   ├── services/
│   │   ├── preferences/                  # AppPreferences (shared_preferences: themeMode, locale) — device-scoped
│   │   └── session/session_controller.dart  # + _blockedUsers.clear() in _clearSession()
│   └── presentation/
│       ├── settings_row.dart             # NEW shared row (label/leading/trailing: switch|chevron|value)
│       └── settings_section_header.dart  # NEW shared section header
└── features/
    └── settings/
        ├── presentation/
        │   ├── cubit/                    # settings, follow_requests, blocked_accounts, close_friends, report, app_settings
        │   ├── pages/                    # settings_page, privacy_page, follow_requests_page, blocked_accounts_page,
        │   │                             #   close_friends_page, language_page, theme_page, two_factor_entry_page, data_export_entry_page
        │   └── widgets/                  # settings groups, request_tile, blocked_row, close_friend_row, report_sheet, about_section
        └── domain/                       # usecases (accept/decline, block/unblock, add/remove close friend, submit report, toggle settings)

lib/l10n/arb/{app_en.arb, app_vi.arb}     # + all new settings/privacy/safety copy
```

**Structure Decision**: Feature-first mobile layout (Constitution XI). Cross-feature enforcement (block hiding) lives in `core/data/moderation/blocked_users_store.dart` so feed/search/messaging/notifications consume it via DI without importing `features/settings`. The Settings feature folder is created fresh (none exists); the `/settings` route + profile-gear entry already exist and are repointed from `PlaceholderPage` to the real page.

## Phase 0 — Research

Complete → [research.md](research.md). All unknowns resolved (D1–D11). Highlights: backend is contract-complete except `GET /me/blocks` (D5); report enum reconciled to backend (D2, spec FR-019 updated); no drift change (D9); theme/locale device-scoped via shared_preferences (D7); `package_info_plus` the only new dep (D11).

## Phase 1 — Design & Contracts

Complete → [data-model.md](data-model.md), [contracts/settings-privacy-api.md](contracts/settings-privacy-api.md), [quickstart.md](quickstart.md). Models are freezed; DTOs generated; cubits 4-state; the cross-feature block seam and device-pref seam are specified. Agent-context update script not present in this repo (skipped).

## Phase 2 — Task planning approach (for /speckit.tasks)

`/speckit.tasks` will generate `tasks.md` ordered by user-story priority (P1: US1 hub, US2 private+requests, US3 block+report → then P2 US4 close-friends, US5 language/theme, US6 secondary → P3 US7 a11y/adaptive). Expected task shape:

1. **Setup**: add `package_info_plus` (verify latest at pub.dev), scaffold `features/settings/`, add endpoint + route constants, EN+VI ARB stubs.
2. **Core seams**: `BlockedUsersStore` + logout wiring; `AppPreferences` + `AppSettingsCubit` + `We36App` theme/locale wiring; shared `SettingsRow`/`SettingsSectionHeader`.
3. **Per-slice (repo+dto+fake+cubit+page+tests)**: settings, follow-requests, block(+report), close-friends — each independently testable.
4. **Cross-surface enforcement**: wire feed/search/messaging/notifications to filter `BlockedUsersStore`; wire existing profile/reel/comment more-sheet stubs to real block/report.
5. **Activity-status**: settings toggle + reciprocal messaging-presence gate.
6. **Polish (US7)**: a11y labels, 2× text, light/dark goldens, tablet reflow, log-redaction test, quickstart pass, pre-commit gate.

Record the **B#014 `GET /me/blocks` addition** as a cutover follow-up (not a client blocker — fake-complete).

## Complexity Tracking

No constitution violations — section intentionally empty.
