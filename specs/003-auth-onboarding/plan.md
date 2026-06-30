# Implementation Plan: Auth & Onboarding

**Branch**: `003-auth-onboarding` | **Date**: 2026-06-30 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/003-auth-onboarding/spec.md`

## Summary

Spec #003 turns the #001 auth-guard skeleton + #002 networking/token seams into a real, persisted session and the six Group-A screens (Splash, Onboarding, Sign in, Sign up, Forgot password, Profile setup). It implements the seams #002 left as fakes (`TokenStore`, `TokenRefresher`) against `flutter_secure_storage`, adds an `AuthRepository` + `MeRepository` (real + in-memory fake) over the **already-implemented** backend contract (`we36-backend` B#002, base path `/v1`), and replaces the `AuthGuardStub` with an app-wide `SessionController` that drives the router redirect from real auth + profile state. Email-only credentials, Google/Apple OAuth, email 6-digit OTP reset, username-checked profile setup. The whole flow ships with fakes so it builds and tests with zero network, and switches the DI environment from `'fake'` to `'real'` when wired to the dev backend.

## Technical Context

**Language/Version**: Dart 3.11.5 / Flutter 3.41.7 (stable floor, per #001).

**Primary Dependencies**: existing — `flutter_bloc ^9.1.1`, `get_it ^9.2.1` + `injectable ^3.0.0`, `go_router ^17.3.0`, `dio ^5.10.0`, `drift ^2.34.0`, `flutter_secure_storage ^10.3.1`, `freezed ^3.2.5` + `json_serializable ^6.14.0`, `uuid ^4.5.3`. **New (verified on pub.dev 2026-06-30)** — `google_sign_in ^7.2.0` (v7 singleton API: `GoogleSignIn.instance` + `initialize()` + `authenticate()`), `sign_in_with_apple ^8.1.0`, `shared_preferences ^2.5.5`.

**Storage**: `flutter_secure_storage` for credentials (access + refresh tokens) ONLY; `drift` (`AppDatabase`) for the cached current-user profile (`MeProfile` table); `shared_preferences` for non-secret local flags (`onboardingSeen`, cached `profileCompleted` for offline cold-start routing).

**Testing**: `flutter_test`, `bloc_test ^10.0.0`, `mocktail ^1.0.5`, golden tests; all auth repos exercised through in-memory fakes (zero network in CI). API/DTO mapping tested against stubbed `dio` responses (the #002 pattern).

**Target Platform**: iOS + Android phones + tablets/iPad (adaptive). New native floors from the added plugins: Android `minSdk 24` (shared_preferences), iOS `13.0` (shared_preferences) / `12.0` (google_sign_in) → effective floor **iOS 13 / Android 24**; Sign in with Apple needs the "Sign in with Apple" capability + a paid Apple Developer account (config, not code — flagged for the build/release task).

**Project Type**: Mobile app (Flutter, Clean Architecture, feature-first) — auth UI in `lib/features/auth/`, app-wide session + credential plumbing in `lib/core/`.

**Performance Goals**: cold-start routing decision < 2 s offline (SC-002, satisfied by the locally cached `profileCompleted` flag, no `/me` round-trip on the launch path); username availability feedback < 1 s after typing pause (SC-006, debounced `check-username`).

**Constraints**: offline-capable cold start; credentials in secure storage only, never in logs/`shared_preferences`/drift; single-flight refresh (reuse the #002 `refresh_interceptor`, never a parallel refresh path); forced re-login exactly once (no redirect loop); logout + forced re-login wipe all user-scoped drift data.

**Scale/Scope**: 6 screens + 1 app-wide session controller; ~9 use cases; 2 new repositories (Auth, Me) each with real + fake; 1 new drift table; ~30 new l10n keys (EN + VI). Single developer, ~1.5 weeks (roadmap).

## Constitution Check

*GATE: must pass before Phase 0 and re-checked after Phase 1.*

| Principle | Gate | Status |
|---|---|---|
| **I. Privacy, Safety & Trust** | Tokens in secure storage only; no secrets in logs (logging interceptor already redacts `authorization`); cache wiped on logout/forced-relogin; uniform non-enumerating errors on login/forgot; input validation on every DTO field. | ✅ Designed in (FR-014, FR-005/015, FR-012/013). Auth is privacy-sensitive → extra review per Workflow. |
| **III. BLoC 4-state** | Screen cubits extend `AppCubit<T>` (initial/loading/loaded/error); extended variants prefix base (e.g. `loadedSubmitting`); side-effects via `BlocListener`; screen cubits `@injectable`, `SessionController` app-wide `@lazySingleton`. | ✅ |
| **IV. Code Quality** | freezed models + generated JSON; explicit types; `very_good_analysis` zero-warning; `bloc_lint` zero. | ✅ |
| **V. Result<T>** | All repo/use-case methods return `Result<T>`; cubits `.fold()`; no try/catch in cubits; field errors map via `AppFailure.validation(fields)`. All needed `AppFailure` variants already exist (incl. `oauthCancelled`, `conflict`, `rateLimited`, `validation`). | ✅ |
| **VI. Design System** | Six screens built from #001 shared widgets + tokens (`AppButton`, `AppTextField`?, `Avatar`, `Toast`, `Wordmark`); no hardcoded hex/TextStyle; brand gradient only on CTAs/wordmark; adaptive (pre-auth = centered column on tablet). UI deltas (email-only, 6-box OTP, no avatar) update `ui-design-context.md`. | ✅ (see Phase 1 note on a shared `AppTextField`/`OtpInput` if absent) |
| **VIII. API & Realtime** | All calls via the single `ApiClient`; HTTP→`AppFailure` centralized (already maps all 7 auth codes); endpoints in `ApiEndpoints` (no inline literals); base URL per-flavor; single-flight refresh reused. No realtime in #003. | ✅ |
| **IX. Data Integrity & Cache** | One canonical cached `MeProfile`; reactive `.watch()` read for the current user; non-destructive drift migration (schemaVersion 1→2) with migration test; malformed payloads handled. | ✅ |
| **X. go_router** | Centralized `AppRoutes` (exist); redirect driven by app-wide `SessionController` (replaces stub) — no per-screen auth checks; auth screens are nav-less flow routes (exist). Deep-link validation N/A for #003 (no new deep links). | ✅ |
| **XI. Feature-First** | `core/` must not import `features/`. App-wide session + credential plumbing (TokenStore, TokenRefresher, SessionController, AuthRepository, MeRepository) lives in `core/`; only UI (pages + screen cubits + use cases) in `features/auth/`. No feature↔feature imports. | ✅ (rationale in Structure Decision) |
| **XII. Testing** | Fake AuthRepository/MeRepository + fake TokenStore (exists); bloc_test for every cubit (load/submit/error); widget tests for sign-in/sign-up/forgot/profile-setup happy + error; golden optional for the auth screens; refresh + guard tested against stubbed dio / fake seams. | ✅ |
| **XIII. Simplicity / YAGNI** | No OTP/pin package — build the 6-box input from `TextField`s. No "remember me" (session always persists). No 2FA/phone/avatar (deferred). Three new packages, each justified (Google, Apple, prefs). | ✅ |
| **XIV. i18n** | All copy in ARB (EN primary + VI); error text from `AppFailure` mapping (auth error keys already exist); add button/label/hint/message keys; locale-aware OTP cooldown timer formatting. | ✅ |
| **XV. Dependency Hygiene** | Versions sourced from pub.dev today; `google_sign_in` v7 API-break noted (singleton + `authenticate()`); native floors verified (iOS 13 / Android 24); Apple capability/entitlement flagged; caret pins; lockfiles committed. | ✅ |

**Result**: PASS — no violations, Complexity Tracking not required. The one judgment call (placing `AuthRepository`/`MeRepository` in `core/` rather than `features/auth/`) is justified under Structure Decision and stays within Principle XI (core owns app-wide session; features own UI).

## Project Structure

### Documentation (this feature)

```text
specs/003-auth-onboarding/
├── plan.md              # This file
├── research.md          # Phase 0 — decisions & rationale
├── data-model.md        # Phase 1 — entities, DTOs, drift table, state shapes
├── quickstart.md        # Phase 1 — how to run/validate the flow
├── contracts/
│   └── auth-openapi.yaml # Phase 1 — the /v1 auth+me slice consumed by the client
└── checklists/
    └── requirements.md  # from /speckit.specify
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── constants/
│   │   ├── api_endpoints.dart        # ADD auth/* + me/* paths (relative to /v1 base)
│   │   └── app_routes.dart           # exists (auth routes present)
│   ├── data/
│   │   ├── auth/                      # NEW — app-wide credential repository
│   │   │   ├── auth_repository.dart            # interface
│   │   │   ├── auth_repository_impl.dart        # env: ['real'] — over ApiClient
│   │   │   ├── fake_auth_repository.dart        # env: ['fake'] — in-memory accounts
│   │   │   ├── auth_remote_data_source.dart     # dio calls + DTO decode
│   │   │   └── dto/ (register/login/oauth/reset/session/check_username)
│   │   ├── me/                       # NEW — app-wide current-user profile
│   │   │   ├── me_profile.dart                  # freezed model (MeProfile)
│   │   │   ├── me_repository.dart                # interface
│   │   │   ├── me_repository_impl.dart           # env: ['real'] — /me, /me/setup, PATCH /me
│   │   │   ├── fake_me_repository.dart            # env: ['fake']
│   │   │   └── me_remote_data_source.dart
│   │   └── cache/
│   │       ├── app_database.dart      # ADD MeProfiles table + clearUserScoped()
│   │       ├── tables/me_profile_table.dart      # NEW
│   │       └── daos/me_profile_dao.dart          # NEW (upsert/watch/clear)
│   ├── services/session/
│   │   ├── token_store.dart           # exists (interface + FakeTokenStore)
│   │   ├── real_token_store.dart      # NEW env-agnostic — flutter_secure_storage (replaces FakeTokenStore)
│   │   ├── token_refresher.dart       # exists (interface + FakeTokenRefresher)
│   │   ├── real_token_refresher.dart  # NEW env: ['real'] — POST /auth/refresh + rotate
│   │   ├── auth_events.dart           # exists (AuthEventsSink)
│   │   ├── session_controller.dart    # NEW @lazySingleton ChangeNotifier (Listenable)
│   │   └── local_flags.dart           # NEW — shared_preferences (onboardingSeen, profileCompleted)
│   └── router/
│       ├── app_router.dart            # EDIT — refreshListenable + redirect → SessionController
│       └── auth_guard_stub.dart       # REMOVE (replaced by SessionController)
└── features/auth/
    ├── domain/usecases/               # NEW — thin orchestration (Result<T>)
    │   ├── sign_in.dart  sign_up.dart  sign_in_with_google.dart
    │   ├── sign_in_with_apple.dart  request_password_reset.dart
    │   ├── reset_password.dart  check_username.dart  setup_profile.dart
    │   └── sign_out.dart  bootstrap_session.dart
    └── presentation/
        ├── splash/        splash_page.dart
        ├── onboarding/    onboarding_page.dart (+ onboarding_cubit.dart)
        ├── sign_in/       sign_in_page.dart + sign_in_cubit.dart
        ├── sign_up/       sign_up_page.dart + sign_up_cubit.dart
        ├── forgot/        forgot_password_page.dart + forgot_password_cubit.dart
        ├── profile_setup/ profile_setup_page.dart + profile_setup_cubit.dart
        └── widgets/       otp_input.dart, oauth_buttons.dart (shared within auth)
```

**Structure Decision**: Mobile-app, feature-first per Constitution XI. The credential + session plumbing that must be **app-wide** — token storage/refresh, the `SessionController` that gates the router, and the `AuthRepository`/`MeRepository` they call — lives in `lib/core/` (where the #002 token seams already are), because `core/` cannot import `features/` yet the router guard and refresher (both core) depend on them. Only the **UI** (six pages, their `@injectable` screen cubits, and thin use cases) lives in `lib/features/auth/`, which may import `core/`. This keeps `core/` free of feature coupling while satisfying the dependency direction. `MeProfile` (current user) is deliberately separate from the existing public-profile `User` model (`core/data/user/`); #010 may later unify them.

## Complexity Tracking

> No Constitution violations — section intentionally empty.
