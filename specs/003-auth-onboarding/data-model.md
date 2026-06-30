# Phase 1 Data Model: Auth & Onboarding

Field names are **camelCase** matching the backend JSON (`api-context.md`). Ids are string UUIDv7. Timestamps are ISO-8601 UTC strings → `DateTime` (UTC). All models are `@freezed` with generated JSON.

## Domain models

### MeProfile  (`core/data/me/me_profile.dart`)

The authenticated current user. Mirrors backend `MeProfile`.

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | UUID |
| `username` | `String?` | null until setup; `[a-z0-9._]` 3–30, no leading/trailing dot, case-insensitive |
| `displayName` | `String?` | null until setup; 1–50 |
| `email` | `String` | unique, case-insensitive |
| `avatarMediaId` | `String?` | reference only; upload deferred to B#003 |
| `bio` | `String?` | ≤150 |
| `website` | `String?` | ≤200 |
| `pronouns` | `String?` | ≤30 |
| `isPrivate` | `bool` | stored, not enforced in #003 |
| `isVerified` | `bool` | badge flag |
| `profileCompleted` | `bool` | **routing source of truth** (Home vs Profile setup) |
| `createdAt` | `DateTime` | UTC |

`fromJson`/`toJson` generated. No business logic on the model.

### Session  (`core/data/auth/dto/session.dart`)

Issued by register/login/oauth/refresh. **Never cached in drift; tokens go to secure storage only.**

| Field | Type |
|---|---|
| `accessToken` | `String` |
| `refreshToken` | `String` |
| `expiresIn` | `int` (seconds) |
| `tokenType` | `String` (`"Bearer"`) |

### UsernameAvailability  (`core/data/auth/dto/check_username.dart`)

| Field | Type | Notes |
|---|---|---|
| `available` | `bool` | |
| `reason` | `UsernameReason?` | enum `{ taken, invalid }`, null when available |

### Request DTOs (`core/data/auth/dto/`)

- `RegisterRequest { email, password, phone?, deviceId? }` — #003 sends email+password only (no phone field in UI).
- `LoginRequest { email, password, deviceId? }`
- `OAuthRequest { idToken, deviceId? }` (provider in path)
- `RefreshRequest { refreshToken }`
- `LogoutRequest { refreshToken }`
- `ForgotRequest { email }`
- `ResetRequest { email, code, newPassword }`
- `CheckUsernameRequest { username }`
- `SetupProfileRequest { username, displayName, bio? }` — `avatarMediaId` omitted in #003.
- `UpdateMeRequest { username?, displayName?, bio?, website?, pronouns?, avatarMediaId? }` — partial; used by `MeRepository.updateMe` (minimal in #003).

`deviceId` = a stable client label (optional). Forgot dev response: `{ devCode? }` (dev flavor only).

## Repository interfaces

### AuthRepository  (`core/data/auth/auth_repository.dart`)

```
Future<Result<Session>> register(String email, String password);
Future<Result<Session>> login(String email, String password);
Future<Result<Session>> oauth(OAuthProvider provider, String idToken);   // provider: google|apple
Future<Result<Session>> refresh(String refreshToken);                     // used by RealTokenRefresher
Future<Result<void>>    logout(String refreshToken);                      // best-effort; 204 idempotent
Future<Result<String?>> requestPasswordReset(String email);              // returns devCode in dev, else null
Future<Result<void>>    resetPassword(String email, String code, String newPassword);
Future<Result<UsernameAvailability>> checkUsername(String username);
```

### MeRepository  (`core/data/me/me_repository.dart`)

```
Future<Result<MeProfile>> getMe();                          // GET /me  → upsert cache
Stream<MeProfile?>        watchMe();                         // reactive read from drift
Future<Result<MeProfile>> setupProfile(SetupProfileRequest req);   // POST /me/setup
Future<Result<MeProfile>> updateMe(UpdateMeRequest req);           // PATCH /me (minimal use in #003)
```

**Real impls** (`env:['real']`) call `ApiClient` via a remote data source and upsert the drift `MeProfiles` cache. **Fakes** (`env:['fake']`) hold accounts/profile in memory: `FakeAuthRepository` seeds one demo account (`demo@we36.app` / `password123`, profileCompleted=true) + supports register→new account (profileCompleted=false), a fixed dev OTP (e.g. `123456`), and username taken-set; `FakeMeRepository` returns the current fake user and flips `profileCompleted` on setup.

## drift cache

### MeProfiles table  (`core/data/cache/tables/me_profile_table.dart`)

Single-row table (current user). `@DataClassName('CachedMeProfile')`, PK `id`.

| Column | Type | Null |
|---|---|---|
| `id` | text | no |
| `username` | text | yes |
| `displayName` | text | yes |
| `email` | text | no |
| `avatarMediaId` | text | yes |
| `bio` | text | yes |
| `website` | text | yes |
| `pronouns` | text | yes |
| `isPrivate` | bool | no |
| `isVerified` | bool | no |
| `profileCompleted` | bool | no |
| `createdAt` | dateTime | no |
| `cachedAt` | dateTime | no |

**MeProfileDao**: `upsert(MeProfile)`, `Stream<MeProfile?> watch()`, `Future<void> clear()`.

**AppDatabase changes**: register `MeProfiles` + `MeProfileDao`; bump `schemaVersion 1 → 2` with a non-destructive `onUpgrade` (`m.createTable(meProfiles)`); add `Future<void> clearUserScoped()` deleting `meProfiles` + `users`. Migration test covers v1→v2 (Constitution IX).

## Local flags (`shared_preferences`)

| Key | Type | Purpose | Cleared on logout? |
|---|---|---|---|
| `onboardingSeen` | bool | first-launch gate | **No** (device-level) |
| `profileCompleted` | bool | offline cold-start routing (mirror of MeProfile) | Yes |

## State shapes (cubits)

App-wide `SessionController` (`ChangeNotifier`, not `AppCubit`):

```
enum AuthStatus { unknown, authenticated, unauthenticated }
status: AuthStatus           // unknown until bootstrap resolves
profileCompleted: bool       // drives Home vs Profile-setup
me: MeProfile?               // current user (background-loaded)
isSignedIn => status == authenticated
```

Screen cubits (extend `AppCubit<T>`, 4-state; extended variants prefix base):

- `SignInCubit` / `SignUpCubit` — `T = MeProfile` (or `Session`); add `loadedSubmitting` while the call is in flight; success drives `SessionController` then router.
- `ForgotPasswordCubit` — models steps: request-email → enter-code; tracks resend cooldown; `loadedSubmitting` per step.
- `ProfileSetupCubit` — `T = MeProfile`; holds debounced `UsernameAvailability`; `loadedSubmitting` on continue.
- `OnboardingCubit` — current slide index; "seen" persisted on finish/skip.

## State transitions

**Session / routing**

```
launch → SessionController.bootstrap:
  no tokens                      → unauthenticated → (onboardingSeen? signIn : onboarding)
  tokens + cached !completed     → authenticated, profileCompleted=false → profileSetup   (offline-ok)
  tokens + cached completed      → authenticated, profileCompleted=true  → home           (offline-ok)
  [background] GET /me           → reconcile profileCompleted + me; if 401→refresh→ok, else unauthenticated

auth success (login/register/oauth):
  store tokens → load /me → set profileCompleted → redirect (completed? home : profileSetup)

profile setup success: profileCompleted=true (+ cache + flag) → home

forced unauthenticated (refresh fail signal) | logout:
  POST /auth/logout (best-effort) → clear tokens + clearUserScoped() + clear profileCompleted flag
  → unauthenticated → signIn   (exactly once; no loop)
```

**Onboarding**: first launch → slides → Get started→signUp / Skip→signIn, set `onboardingSeen`. Subsequent launches skip slides.
