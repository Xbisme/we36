# Quickstart: Validate Auth & Onboarding

Run guide proving the feature end-to-end. Two modes: **fake** (zero-network, CI/default) and **real** (against the dev backend).

## Prerequisites

- Flutter 3.41.7 / Dart 3.11.5; `flutter pub get` (new deps: `google_sign_in ^7.2.0`, `sign_in_with_apple ^8.1.0`, `shared_preferences ^2.5.5`).
- Codegen after model/DI changes: `dart run build_runner build --delete-conflicting-outputs`.
- l10n: `flutter gen-l10n` (or via build) after ARB edits.
- Real mode only: `we36-backend` running (`npm run dev:up`) at `http://localhost:3000`; dev flavor `apiBaseUrl` → `http://localhost:3000/v1`; OAuth client IDs configured (`GOOGLE_OAUTH_CLIENT_IDS`, Apple Service ID + capability). Forgot OTP: dev response includes `devCode`.

## Run

```bash
# fake env (default — in-memory accounts, no backend)
flutter run --flavor dev -t lib/main_dev.dart
# real env: flip DI to 'real' (diEnvironment / configureDependencies(environment:'real')) then run the dev flavor
```

Fake demo account: `demo@we36.app` / `password123` (profileCompleted=true). New sign-up → profile-setup flow. Fake OTP: `123456`.

## Validation scenarios (map to spec User Stories / SC)

1. **US5 first-launch** — fresh install (clear app data) → onboarding slides; **Get started → Sign up**, **Skip → Sign in**; relaunch → no slides. (`onboardingSeen` persisted.)
2. **US2 sign-up + setup** — register a new email/password → Profile setup; type a username → live available/taken/invalid (<1 s, SC-006); set display name → Home. Kill app mid-setup → relaunch returns to Profile setup (SC: interrupted setup).
3. **US1 sign-in + persistence** — sign in with the demo account → Home; **kill & relaunch → Home, no sign-in** (SC-002, offline too: enable airplane mode before relaunch → still Home instantly). Works in **fake** mode because token storage is env-agnostic (`RealTokenStore` over secure storage; only the network seams are faked) — the fake-issued session persists across restarts exactly like a real one.
4. **US1 silent refresh** — (real) let the access token expire (or force a 401 SESSION_EXPIRED in fake via `FakeTokenRefresher.succeeds=true`) → next action succeeds with no visible re-auth (SC-003). Set refresher to fail → signed out exactly once to Sign in, clear message, no loop (SC-004).
5. **US1 logout wipes cache** — sign in → logout → confirm `MeProfiles`/`Users` drift tables empty and a relaunch shows Sign in (SC-010); `onboardingSeen` still true (no slides).
6. **US3 forgot password** — Forgot → enter email → 6-box OTP step; resend disabled during cooldown; enter wrong code → non-revealing error; enter `123456` (dev: `devCode`) + new password → back to Sign in; sign in with the new password.
7. **US4 OAuth** — tap Continue with Google / Continue with Apple → provider sheet → Home or Profile setup; cancel the sheet → returns silently, no error (oauthCancelled).
8. **Errors** — duplicate email on sign-up → CONFLICT message; wrong password → uniform INVALID_CREDENTIALS (no enumeration); repeated failures → RATE_LIMITED "try again in N"; offline on any call → retry-able message, no crash (SC-007).

## Tests

```bash
very_good test --test-randomize-ordering-seed random   # or: flutter test
dart run bloc_tools:bloc lint .
flutter analyze && dart format --set-exit-if-changed .
```

Expected coverage: bloc_test for each cubit (load/submit/error/rollback); DTO (de)serialization + `FailureMapper` for the auth codes; `RealTokenRefresher` single-flight + `SessionController` bootstrap/wipe against fakes; drift v1→v2 migration test; widget tests for the four interactive screens (happy + one error each). No live network in CI.

## Done = green

`flutter analyze` zero warnings · all tests pass · `bloc_lint` zero · `dart format` clean (the #001/#002 pre-commit gate), plus the 8 scenarios above pass in fake mode and (when wired) real mode.
