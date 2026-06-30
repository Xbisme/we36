---
description: "Task list for Spec #003 Auth & Onboarding"
---

# Tasks: Auth & Onboarding

**Input**: Design documents from `specs/003-auth-onboarding/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/](contracts/)

**Tests**: REQUIRED for this feature — Constitution XII makes unit + BLoC tests mandatory and widget tests required for engagement-critical flows. Test tasks are therefore included per story.

> **⚠️ Backend & device-testing banner**: the flow is CI-testable on fakes (zero network). OAuth round-trips, real token refresh under network, and OTP delivery need a **live dev backend + a real device** — covered by the deferred manual smoke task T075.

**Organization**: by user story (US1–US5) for independent implementation/testing. Paths follow [plan.md](plan.md) §Project Structure.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: parallelizable (different files, no incomplete-task dependency)
- **[Story]**: US1–US5; Setup/Foundational/Polish have no story label

---

## Phase 1: Setup (Shared Infrastructure)

- [x] T001 Add deps to `pubspec.yaml` (`google_sign_in: ^7.2.0`, `sign_in_with_apple: ^8.1.0`, `shared_preferences: ^2.5.5`) and run `flutter pub get`; commit `pubspec.lock`
- [ ] T002 [P] iOS native config in `ios/`: raise deployment target to 13.0, add the **Sign in with Apple** capability + entitlement, add the Google reversed-client-id URL scheme + `CFBundleURLTypes` in `ios/Runner/Info.plist`
- [ ] T003 [P] Android native config in `android/`: `minSdk 24`, set `sign_in_with_apple` launch mode (`singleTask`/`singleTop`) in `AndroidManifest.xml`, add Google config
- [x] T004 [P] Add auth + me endpoint constants to `lib/core/constants/api_endpoints.dart` (`/auth/register|login|oauth/{provider}|logout|forgot|reset|check-username`, `/me/setup`; `/auth/refresh` + `/me` already present)

---

## Phase 2: Foundational (Blocking Prerequisites)

**⚠️ CRITICAL**: the session + data spine — no user story can begin until this phase is complete.

- [x] T005 [P] `MeProfile` freezed model + JSON in `lib/core/data/me/me_profile.dart` (fields per [data-model.md](data-model.md))
- [x] T006 [P] Auth request/response DTOs (Session, Register/Login/OAuth/Refresh/Logout/Forgot/Reset/CheckUsername(+Response)/SetupProfile/UpdateMe) in `lib/core/data/auth/dto/`
- [x] T007 [P] `MeProfiles` drift table in `lib/core/data/cache/tables/me_profile_table.dart`
- [x] T008 `MeProfileDao` (`upsert` / `watch` / `clear`) in `lib/core/data/cache/daos/me_profile_dao.dart`
- [x] T009 Wire `MeProfiles` + DAO into `lib/core/data/cache/app_database.dart`, bump `schemaVersion` 1→2 with non-destructive `onUpgrade`, add `Future<void> clearUserScoped()` (deletes `meProfiles` + `users`)
- [x] T010 [P] `LocalFlags` wrapper over `shared_preferences` (`onboardingSeen`, `profileCompleted`) in `lib/core/services/session/local_flags.dart`
- [x] T011 `RealTokenStore` (**env-agnostic — NO `env` annotation; replaces `FakeTokenStore` in DI**, `flutter_secure_storage`, sync in-memory mirror + bootstrap hydrate + `clear()`) in `lib/core/services/session/real_token_store.dart`; demote `FakeTokenStore` to a test-only helper (un-register from DI). Resolves analyze finding **I1** — persistence works in both `fake` and `real` envs (storage needs no backend), so US1 cold-start/relaunch is demonstrable offline.
- [x] T012 `RealTokenRefresher` (`env:['real']`, `POST /auth/refresh` via `ApiClient`, persist rotated pair) in `lib/core/services/session/real_token_refresher.dart`
- [x] T013 `AuthRemoteDataSource` (dio calls + DTO decode for all auth endpoints) in `lib/core/data/auth/auth_remote_data_source.dart`
- [x] T014 [P] `AuthRepository` interface in `lib/core/data/auth/auth_repository.dart` (signatures per [data-model.md](data-model.md))
- [x] T015 `AuthRepositoryImpl` (`env:['real']`) in `lib/core/data/auth/auth_repository_impl.dart`
- [x] T016 [P] `FakeAuthRepository` (`env:['fake']`, seeded `demo@we36.app`/`password123`, register→new account, fixed dev OTP `123456`, username taken-set) in `lib/core/data/auth/fake_auth_repository.dart`
- [x] T017 `MeRemoteDataSource` (`GET /me`, `POST /me/setup`, `PATCH /me`) in `lib/core/data/me/me_remote_data_source.dart`
- [x] T018 [P] `MeRepository` interface in `lib/core/data/me/me_repository.dart`
- [x] T019 `MeRepositoryImpl` (`env:['real']`, upsert cache, reactive `watchMe`) in `lib/core/data/me/me_repository_impl.dart`
- [x] T020 [P] `FakeMeRepository` (`env:['fake']`) in `lib/core/data/me/fake_me_repository.dart`
- [x] T021 `SessionController` (`@lazySingleton` `ChangeNotifier`: `AuthStatus` + `profileCompleted` + `me`; `bootstrap()`; subscribe `AuthEventsSink.unauthenticated` → `clearUserScoped()`+`TokenStore.clear()`+flag clear once; `signOut()`) in `lib/core/services/session/session_controller.dart`
- [x] T022 Rewire `lib/core/router/app_router.dart` `redirect` + `refreshListenable` to `SessionController` (routing per [data-model.md](data-model.md) transitions); delete `lib/core/router/auth_guard_stub.dart`
- [x] T023 Ensure network-dependent impls register under `env:['real']` (AuthRepositoryImpl, MeRepositoryImpl, RealTokenRefresher) and their fakes under `env:['fake']`, while **`RealTokenStore` is env-agnostic** (per T011); keep `diEnvironment = 'fake'` default; regenerate `lib/core/di/injection.config.dart`
- [x] T024 Run `dart run build_runner build --delete-conflicting-outputs` + `flutter gen-l10n`; resolve analyzer to zero warnings
- [x] T025 [P] Base auth l10n keys (EN `app_en.arb` + VI `app_vi.arb`): shared buttons/labels (email, password, continue, etc.) with `@description`

**Checkpoint**: app boots into the real gate on fakes; session restore + guard functional.

---

## Phase 3: User Story 1 — Returning user signs in & stays signed in (Priority: P1) 🎯 MVP

**Goal**: Sign in with email/password, persistent restorable session, silent refresh, forced-re-login-once, logout wipes cache.

**Independent Test**: sign in with the demo account → Home; kill & relaunch (incl. airplane mode) → Home with no prompt; force refresh failure → signed out once to Sign in; logout → cache empty + Sign in on relaunch.

### Tests for User Story 1

- [x] T026 [P] [US1] `bloc_test` `SignInCubit` (loading → loadedSubmitting → loaded; error `invalidCredentials`, `rateLimited`) in `test/features/auth/sign_in_cubit_test.dart`
- [x] T027 [P] [US1] Unit test `RealTokenStore` round-trip + `RealTokenRefresher` single-flight against a mock secure storage / stubbed dio in `test/core/session/token_seams_test.dart`
- [x] T028 [P] [US1] `SessionController` test: bootstrap routing (no tokens / cached completed / cached incomplete), forced-unauthenticated wipe-once, logout clears cache (in-memory `AppDatabase.forTesting`) in `test/core/session/session_controller_test.dart`
- [x] T029 [P] [US1] Widget test `SignInPage` happy + wrong-password error, **plus tablet-width adaptive layout + text-scaling (e.g. 2.0) + semantics labels + light/dark** (FR-030, Constitution VI/VII/XII; partial fix for analyze finding **C2**) in `test/features/auth/sign_in_page_test.dart`
- [x] T030 [P] [US1] drift migration test v1→v2 in `test/core/cache/migration_v1_v2_test.dart`
- [x] T030a [P] [US1] **Privacy** (Constitution I, FR-014 / SC-008): assert a sign-in + refresh flow emits **no token/password/refresh-token** to `AppLogger` (capture log sink; verify redaction) in `test/core/session/log_redaction_test.dart` — resolves analyze finding **C1**

### Implementation for User Story 1

- [x] T031 [P] [US1] `SignIn` use case in `lib/features/auth/domain/usecases/sign_in.dart`
- [x] T032 [P] [US1] `SignOut` use case (best-effort `POST /auth/logout` → `SessionController.signOut()`) in `lib/features/auth/domain/usecases/sign_out.dart`
- [x] T033 [US1] `SignInCubit` (`@injectable`, extends `AppCubit`) in `lib/features/auth/presentation/sign_in/sign_in_cubit.dart`
- [x] T034 [US1] `SignInPage` UI (email + password fields, "Forgot password?" link, OAuth row slot, footer "Create account") from #001 shared widgets/tokens in `lib/features/auth/presentation/sign_in/sign_in_page.dart`
- [x] T035 [US1] `SplashPage` wired to `SessionController.bootstrap()` (session-restore surface; replaces placeholder) in `lib/features/auth/presentation/splash/splash_page.dart`
- [x] T036 [US1] Temporary logout entry point (e.g. on the Profile tab placeholder) to exercise wipe end-to-end in `lib/features/.../` (note for removal/relocation in #010/#014)
- [x] T037 [US1] l10n keys for sign-in + session messages (EN + VI)

**Checkpoint**: US1 fully functional — sign in, persist, refresh, logout, guard. This is the demoable MVP.

---

## Phase 4: User Story 2 — New user creates account & completes profile (Priority: P1)

**Goal**: Email/password sign-up → profile setup (username availability + display name, optional bio, no avatar) → Home; interrupted setup resumes at Profile setup.

**Independent Test**: register new email/password → Profile setup; type username → live available/taken/invalid (<1 s); set display name → Home; kill mid-setup → relaunch returns to Profile setup.

### Tests for User Story 2

- [x] T038 [P] [US2] `bloc_test` `SignUpCubit` (conflict email → `conflict`; weak/invalid → `validation`) in `test/features/auth/sign_up_cubit_test.dart`
- [x] T039 [P] [US2] `bloc_test` `ProfileSetupCubit` (debounced availability: available/taken/invalid; submit → loaded) in `test/features/auth/profile_setup_cubit_test.dart`
- [x] T040 [P] [US2] Widget test `SignUpPage` + `ProfileSetupPage` happy + error, **plus adaptive (tablet width) + text-scaling + semantics + light/dark** (FR-030; analyze finding **C2**) in `test/features/auth/signup_setup_page_test.dart`

### Implementation for User Story 2

- [x] T041 [P] [US2] `SignUp` use case in `lib/features/auth/domain/usecases/sign_up.dart`
- [x] T042 [P] [US2] `CheckUsername` use case in `lib/features/auth/domain/usecases/check_username.dart`
- [x] T043 [P] [US2] `SetupProfile` use case in `lib/features/auth/domain/usecases/setup_profile.dart`
- [x] T044 [US2] `SignUpCubit` in `lib/features/auth/presentation/sign_up/sign_up_cubit.dart`
- [x] T045 [US2] `SignUpPage` UI (email + password, terms note, OAuth row slot, footer "Log in") in `lib/features/auth/presentation/sign_up/sign_up_page.dart`
- [x] T046 [US2] `ProfileSetupCubit` (client-side username format pre-validation + ~400 ms debounced `check-username`) in `lib/features/auth/presentation/profile_setup/profile_setup_cubit.dart`
- [x] T047 [US2] `ProfileSetupPage` UI (username + availability state, display name, optional bio; **no avatar control**) in `lib/features/auth/presentation/profile_setup/profile_setup_page.dart`
- [x] T048 [US2] Post-auth routing: `profileCompleted == false` → Profile setup via `SessionController` (verify resume-on-relaunch)
- [x] T049 [US2] l10n keys sign-up + profile-setup (EN + VI)

**Checkpoint**: a brand-new user can reach Home; US1 + US2 both work independently.

---

## Phase 5: User Story 3 — Forgot password recovery (Priority: P2)

**Goal**: Request reset by email → enter 6-digit OTP + new password → back to Sign in; resend cooldown; graceful bad/expired/exhausted code.

**Independent Test**: Forgot → email → 6-box OTP step; resend disabled during cooldown; wrong code → non-revealing error; `123456` (dev `devCode`) + new password → Sign in → log in with new password.

### Tests for User Story 3

- [x] T050 [P] [US3] `bloc_test` `ForgotPasswordCubit` (request step; code step; wrong/expired `validation`; resend cooldown gating) in `test/features/auth/forgot_password_cubit_test.dart`
- [x] T051 [P] [US3] Widget test `ForgotPasswordPage` (email → OTP → reset happy + bad code), **plus OTP-input adaptive + text-scaling + semantics + light/dark** (FR-030; analyze finding **C2**) in `test/features/auth/forgot_password_page_test.dart`

### Implementation for User Story 3

- [x] T052 [P] [US3] `RequestPasswordReset` use case in `lib/features/auth/domain/usecases/request_password_reset.dart`
- [x] T053 [P] [US3] `ResetPassword` use case in `lib/features/auth/domain/usecases/reset_password.dart`
- [x] T054 [P] [US3] `OtpInput` 6-box numeric widget in `lib/features/auth/presentation/widgets/otp_input.dart`
- [x] T055 [US3] `ForgotPasswordCubit` (request → code steps; cooldown timer; dev `devCode` surfacing in dev flavor only) in `lib/features/auth/presentation/forgot/forgot_password_cubit.dart`
- [x] T056 [US3] `ForgotPasswordPage` UI in `lib/features/auth/presentation/forgot/forgot_password_page.dart`
- [x] T057 [US3] l10n keys forgot/reset (EN + VI)

**Checkpoint**: account recovery works end-to-end on fakes.

---

## Phase 6: User Story 4 — OAuth sign-in (Google/Apple) (Priority: P2)

**Goal**: Continue with Google / Apple → on-device id_token → backend create-or-link → same post-auth routing; cancel = silent no-op.

**Independent Test**: tap Google / Apple → provider sheet → Home or Profile setup; cancel → silent return, no error.

### Tests for User Story 4

- [x] T058 [P] [US4] `bloc_test` OAuth path (cancel → `oauthCancelled` no error toast; fail → `oauthFailed`) in `test/features/auth/oauth_test.dart`

### Implementation for User Story 4

- [x] T059 [P] [US4] Google init at bootstrap (`GoogleSignIn.instance.initialize(...)`) + `SignInWithGoogle` use case (`authenticate()` → idToken → `AuthRepository.oauth(google,...)`) in `lib/features/auth/domain/usecases/sign_in_with_google.dart` (+ `lib/bootstrap.dart` edit)
- [x] T060 [P] [US4] `SignInWithApple` use case (`getAppleIDCredential` → identityToken → `AuthRepository.oauth(apple,...)`) in `lib/features/auth/domain/usecases/sign_in_with_apple.dart`
- [x] T061 [US4] `OAuthButtons` widget (Google always; Apple iOS-only) in `lib/features/auth/presentation/widgets/oauth_buttons.dart`
- [x] T062 [US4] Wire `OAuthButtons` into Sign in + Sign up; route post-auth via `SessionController`
- [x] T063 [US4] Verify per-flavor Google client IDs + Apple Service ID/capability config; l10n keys (EN + VI)

**Checkpoint**: OAuth works on device; cancel/fail handled gracefully.

---

## Phase 7: User Story 5 — First-time visitor onboarding (Priority: P3)

**Goal**: First-launch intro slides only once; Get started → Sign up, Skip → Sign in; never shown again; a valid session skips slides.

**Independent Test**: fresh install → slides; Get started → Sign up / Skip → Sign in; relaunch → no slides; with session → straight into app.

### Tests for User Story 5

- [x] T064 [P] [US5] `bloc_test` `OnboardingCubit` + first-launch routing (seen flag persisted; Get started→signUp, Skip→signIn) in `test/features/auth/onboarding_test.dart`

### Implementation for User Story 5

- [x] T065 [P] [US5] `OnboardingCubit` (slide index; persist `onboardingSeen` on finish/skip) in `lib/features/auth/presentation/onboarding/onboarding_cubit.dart`
- [x] T066 [US5] `OnboardingPage` UI (image card slides, dot indicator, Skip + Get started) in `lib/features/auth/presentation/onboarding/onboarding_page.dart`
- [x] T067 [US5] First-launch routing in `SessionController`/`SplashPage` (`onboardingSeen` gate; unauthenticated → onboarding vs sign-in)
- [x] T068 [US5] l10n keys onboarding (EN + VI)

**Checkpoint**: all five stories independently functional.

---

## Phase 8: Polish & Cross-Cutting Concerns

- [x] T069 [P] Update `.claude/claude-app/ui-design-context.md` with the 3 agreed design deltas (Sign in/up email-only, Forgot 6-box OTP, Profile setup no avatar) + note why
- [x] T070 [P] Golden tests (light + dark) for Sign in / Sign up / Profile setup / Onboarding in `test/golden/auth/`
- [x] T071 Run the pre-commit gate: `dart format .`, `flutter analyze` (zero warnings), `flutter test`, `dart run bloc_tools:bloc lint .`
- [ ] T072 Run [quickstart.md](quickstart.md) scenarios 1–8 in fake mode
- [x] T073 [P] Draft docs updates for merge: `.claude/claude-app/project-context.md` Current Focus + `changelog.md` entry + roadmap status (apply at merge)
- [ ] T074 [US4] [US3] [US1] **Deferred manual** on-device + dev-backend smoke test: OAuth Google/Apple round-trip, real token refresh under network drop, OTP request→reset (record results; not CI-gated)

---

## Dependencies & Execution Order

### Phase dependencies

- **Setup (P1)** → no deps.
- **Foundational (P2)** → depends on Setup; **BLOCKS all stories**.
- **US1 (P3)** & **US2 (P4)** → both P1; depend only on Foundational; independently testable (US2 reuses US1's `SessionController` routing but is separately verifiable).
- **US3 (P5)**, **US4 (P6)** → depend on Foundational; US4 wires buttons into the US1/US2 screens (slots left in T034/T045).
- **US5 (P7)** → depends on Foundational; routing slot in `SessionController`.
- **Polish (P8)** → after the desired stories.

### Within each story

Tests authored to fail first → use cases → cubit → page → routing/l10n. Models before services; services before UI.

### Parallel opportunities

- Setup: T002/T003/T004 in parallel.
- Foundational: T005/T006/T007/T010/T014/T016/T018/T020/T025 in parallel (distinct files); T008→T009, T013→T015, T017→T019 are sequential; T021→T022 sequential; T024 after generated-code producers.
- Each story's `[P]` test + use-case tasks run together; the cubit→page→routing chain is sequential.
- With multiple devs: after Foundational, US1/US2/US3/US4/US5 proceed on separate branches.

---

## Implementation Strategy

### MVP first (US1)

Setup → Foundational → US1 → **STOP & validate** (sign in, persist, refresh, logout). Demoable gate.

### Incremental delivery

US1 (MVP) → US2 (new users in) → US3 (recovery) → US4 (OAuth) → US5 (onboarding polish) → Phase 8. Each story is an independently testable increment that doesn't break the previous.

---

## Notes

- `[P]` = different files, no incomplete-task dependency. `[Story]` label maps to spec User Stories.
- Constitution gate after every task group: `dart format` · `flutter analyze` (0 warn) · `flutter test` · `bloc lint` (0).
- Auth is privacy-sensitive (Constitution I) — T011/T012/T021/T022 (tokens, secure storage, wipe, guard) get extra review.
- Keep `diEnvironment = 'fake'` until the dev backend is wired; **network-dependent** impls live behind `env:['real']`, but `RealTokenStore` is env-agnostic so session persistence works in fake mode too (analyze I1).
- Run `build_runner` after any freezed/json/injectable/drift change; `gen-l10n` after ARB edits.
