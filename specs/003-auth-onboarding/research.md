# Phase 0 Research: Auth & Onboarding

All decisions below resolve the Technical Context. No open `NEEDS CLARIFICATION` remain (spec was clarified pre-plan).

## D1 — Backend contract is fixed and implemented

- **Decision**: Consume `we36-backend` B#002 as-is (base `/v1`). Endpoints: `POST /auth/register|login|refresh|logout|forgot|reset|check-username`, `POST /auth/oauth/{google|apple}`, `GET /me`, `POST /me/setup`, `PATCH /me`. Session = `{accessToken, refreshToken, expiresIn, tokenType:"Bearer"}`. Error envelope `{error:{code,message,details}}`.
- **Rationale**: Backend is production-ready and contract-tested; the client conforms. Mirrored into [contracts/auth-openapi.yaml](contracts/auth-openapi.yaml).
- **Alternatives**: Defining our own contract — rejected (backend already shipped).

## D2 — Token storage & refresh seams (#002 → real)

- **Decision**: `RealTokenStore` wraps `flutter_secure_storage` storing `accessToken` + `refreshToken` (+ in-memory mirror so the synchronous `accessToken` getter the `AuthTokenInterceptor` reads stays non-blocking; hydrated once at bootstrap). **It is registered env-agnostically (NO `env` annotation) and replaces the #002 `FakeTokenStore` in DI** — token *persistence* needs no backend, so the real secure-storage impl is correct in **both** the `fake` and `real` environments. `FakeTokenStore` is demoted to a test-only helper (constructor-injected in unit tests, not DI-registered). Only the **network-dependent** seams stay env-split: `RealTokenRefresher` (`env: ['real']`) calls `POST /auth/refresh` and persists the rotated pair; `FakeTokenRefresher` (`env: ['fake']`) for offline tests/demo. The existing `refresh_interceptor` already does single-flight on `401 SESSION_EXPIRED` and fires `AuthEventsSink.onUnauthenticated()` once on failure — reuse unchanged.
- **Rationale**: Resolves analyze finding **I1** — with an in-memory fake store the MVP US1 "kill & relaunch → Home" and SC-002 (offline cold-start) could not be demonstrated in the default `fake` env. Making storage env-agnostic means a fake-issued session (from `FakeAuthRepository`) persists across restarts just like a real one, so the gate is fully exercisable offline. Tokens never touch `shared_preferences`/drift/logs (Constitution I).
- **Alternatives**: Keep `RealTokenStore` behind `env:['real']` + a persisting fake store — rejected (two persistence paths to maintain). A new refresh path in `AuthRepository` — rejected (would duplicate single-flight logic; Constitution VIII says one refresh path).

## D3 — App-wide session state & router guard

- **Decision**: New `SessionController` (`@lazySingleton`, `ChangeNotifier`) holds `AuthStatus { unknown, authenticated, unauthenticated }` + a cached `profileCompleted` bool + current `MeProfile?`. It is the router's `refreshListenable`; `_redirect` reads it (replacing `AuthGuardStub`). On construct it runs `bootstrapSession` (read secure storage → if tokens present, set authenticated + read cached `profileCompleted` for instant offline routing, then refresh `MeProfile` from `/me` in the background). It subscribes to `AuthEventsSink.unauthenticated` → wipe + go unauthenticated exactly once.
- **Rationale**: Centralizes the logged-in/out split (Constitution X), keeps cold-start routing offline-capable (SC-002) via the cached flag (D6).
- **Alternatives**: A `SessionCubit` exposed as `Listenable` — `ChangeNotifier` is simpler for a pure `refreshListenable`; screen cubits remain `AppCubit`-based. Keeping `AuthGuardStub` — rejected (it's a manual toggle).

## D4 — Repository placement (core vs feature)

- **Decision**: `AuthRepository` + `MeRepository` (each interface + `env:['real']` + `env:['fake']`) live in `lib/core/data/`. Use cases + pages + screen cubits live in `lib/features/auth/`.
- **Rationale**: `core/` (router guard, `RealTokenRefresher`, `SessionController`) needs these but cannot import `features/`. Mirrors the #002 `core/data/user/` reference slice exactly (same file layout + DI annotations).
- **Alternatives**: Repos in `features/auth/data/` — rejected (would force `core/` → `features/` import, violating Constitution XI).

## D5 — Current-user model: new `MeProfile`, not the existing `User`

- **Decision**: New freezed `MeProfile` (id, username?, displayName?, email, avatarMediaId?, bio?, website?, pronouns?, isPrivate, isVerified, profileCompleted, createdAt) in `core/data/me/`. Keep the public-profile `User` (`core/data/user/`) untouched.
- **Rationale**: `MeProfile` carries auth-sensitive fields (email, profileCompleted) absent from the social `User`; conflating them would leak the current user's email into the public-profile cache. #010 may unify later.
- **Alternatives**: Extend `User` with optional auth fields — rejected (semantic mixing + cache-table coupling).

## D6 — Local non-secret flags: `shared_preferences`

- **Decision**: Add `shared_preferences ^2.5.5`. Store `onboardingSeen` (first-launch gate) and a cached `profileCompleted` (offline cold-start routing). A thin `LocalFlags` wrapper in `core/services/session/`.
- **Rationale**: Non-secret, sync-after-load, simplest fit (Constitution XIII). Constitution I forbids only *credentials* in `shared_preferences`; these are not credentials.
- **Alternatives**: Secure storage for these flags — rejected (slower, overkill, reserved for secrets). drift row — rejected (extra table for two booleans).

## D7 — OAuth: google_sign_in v7 + sign_in_with_apple

- **Decision**: `google_sign_in ^7.2.0`, `sign_in_with_apple ^8.1.0`. Obtain the provider **id_token** on-device, POST it to `/auth/oauth/{provider}`. Google v7: call `GoogleSignIn.instance.initialize(...)` once at bootstrap, then `authenticate()`; read `idToken` from the resulting authentication. Apple: `SignInWithApple.getAppleIDCredential(scopes:[email])` → `identityToken`. Map user-cancel → `AppFailure.oauthCancelled` (no error toast), verify-fail/`OAUTH_FAILED` → `oauthFailed`.
- **Rationale**: Backend verifies the id_token via JWKS and create-or-links; the client only needs the token. Apple offered on iOS where Google is (FR-022); on Android, Google only.
- **Alternatives**: Web/redirect OAuth — rejected (native sheets are the platform norm and the backend takes an id_token, not an auth code). **Config flagged**: Google client IDs (`GOOGLE_OAUTH_CLIENT_IDS` audiences) + Apple capability/Service ID provisioned per flavor outside this spec (Constitution XV / build task).

## D8 — Forgot-password OTP UI

- **Decision**: 6-box numeric OTP input built from `TextField`s (custom `OtpInput` widget in `features/auth/presentation/widgets/`), matching the design delta (6 not 4). Resend gated by a client cooldown timer (default 45 s, locale-aware countdown). On `/auth/forgot` in dev the response `devCode` is surfaced only in the dev flavor (for testing), never prod.
- **Rationale**: No pin/OTP package needed (Constitution XIII). Backend OTP is 6 digits, TTL 10 min, 5 attempts.
- **Alternatives**: `pin_code_fields` — rejected (YAGNI; trivial to build).

## D9 — Profile-setup username availability

- **Decision**: Debounced (≈400 ms) `check-username` call as the user types; show available/taken/invalid inline; format pre-validated client-side (`^[a-z0-9](?:[a-z0-9._]{1,28})[a-z0-9]$`, lowercased) before hitting the network. Confirm disabled until available + displayName present.
- **Rationale**: Meets SC-006 (<1 s feedback) without spamming the endpoint (backend rate-limits check-username 30/60s).
- **Alternatives**: Validate only on submit — rejected (worse UX, wastes a round-trip on a known-taken name).

## D10 — Cache wipe on logout / forced re-login

- **Decision**: `AppDatabase.clearUserScoped()` deletes all user-scoped tables (today: `MeProfiles`, `Users`); `SessionController` calls it + `TokenStore.clear()` + `LocalFlags.clearProfileCompleted()` on both explicit logout and the `AuthEventsSink.unauthenticated` signal. `onboardingSeen` is preserved (not user-scoped).
- **Rationale**: Privacy on shared devices (FR-012/013, SC-010); establishes the rule before the cache grows in later specs.
- **Alternatives**: Clear only on explicit logout — rejected (a forced re-login on a shared device would leak the prior user's cached data).

## D11 — Native floors & build config

- **Decision**: Bump minimums to **iOS 13 / Android minSdk 24** (highest floor among shared_preferences + google_sign_in). Add the "Sign in with Apple" capability + entitlement (release/build task); Android `singleTask`/`singleTop` launch mode for `sign_in_with_apple`.
- **Rationale**: Principle XV — verify native floors at plan time before Dart is written. These are config tasks, surfaced explicitly in tasks.md.
- **Alternatives**: none.
