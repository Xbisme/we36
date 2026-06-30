# Phase 1 Data Model — Project Foundation

#001 has **no persistence and no network**. The "data model" here is the set of foundation types (value objects, sealed states, config) and the in-memory mock sample shapes that placeholder destinations render. Real domain models for feed/profile/DM/etc. arrive with their own specs.

---

## 1. Foundation primitives (`core/domain/`)

### `Result<T>` (freezed sealed)
| Variant | Fields | Notes |
|---|---|---|
| `Ok` | `T value` | success |
| `Err` | `AppFailure failure` | failure |

- Methods: `fold(onOk, onErr)`, `isOk`, `valueOrNull`, `map`. No throwing for expected failures (Constitution V).

### `AppFailure` (freezed sealed) — full vocabulary defined now
Auth: `unauthenticated`, `sessionExpired`, `invalidCredentials`, `oauthCancelled`, `oauthFailed` ·
Authz/resource: `forbidden`, `notFound`, `accountSuspended` ·
Validation: `validation(Map<String,String> fields)`, `conflict`, `rateLimited` ·
Media: `uploadFailed`, `mediaTooLarge`, `unsupportedMedia`, `cameraUnavailable`, `permissionDenied` ·
Realtime: `realtimeDisconnected`, `messageFailed` ·
Network: `networkError`, `serverError`, `timeout`, `offline` ·
Fallback: `unknown(String? message, Object? error)`.
- Each variant → a localized user-facing message via an `AppFailure.toMessage(l10n)` mapper. #001 only exercises a handful (e.g. `unknown`, `offline`) in the 4-state demo; the rest are declared for #002+.

### `AppState<T>` (freezed sealed) — mandatory 4-state
| State | Fields |
|---|---|
| `initial` | — |
| `loading` | — |
| `loaded` | `T data` |
| `error` | `AppFailure failure` |
- Extended variants (later specs) MUST prefix the base name (`loadedPaginating`, etc.) — not `success`/`failed`.

### `AppCubit<T>` (base)
- `emitLoading()`, `emitLoaded(T)`, `emitError(AppFailure)`, and `Future<void> run(Future<Result<T>> Function())` that drives initial→loading→loaded/error. Closed on dispose. Extended by every feature Cubit.

---

## 2. Configuration (`core/config/`)

### `Flavor` (enum): `dev`, `prod`
### `AppConfig`
| Field | dev | prod | Notes |
|---|---|---|---|
| `flavor` | `Flavor.dev` | `Flavor.prod` | |
| `appName` | "We36 Dev" | "We36" | |
| `bundleId` | `app.we36.dev` | `app.we36` | confirmed |
| `apiBaseUrl` | `""` (empty) | `""` (empty) | reserved for #002 |
| `realtimeUrl` | `""` (empty) | `""` (empty) | reserved for #002 |
- Selected in `main_dev.dart` / `main_prod.dart`, registered in DI, read everywhere via injected `AppConfig`.

---

## 3. Design-token model (`core/theme/`) — see contracts/design-tokens.md for values

| Token group | Type | Notes |
|---|---|---|
| `AppColorsX` (ThemeExtension) | semantic color aliases | full light + dark instances; read via `context.tokens` |
| `AppGradients` | brand / brand-soft / story | story gradient only for unseen ring |
| `AppTypography` | display (Plus Jakarta Sans) + body (Inter) text styles | scale: Display/H1/H2/H3/Body/Label/Caption |
| `AppSpacing` | 4·8·12·16·24·32·48·64 | 4px base |
| `AppRadius` | sm8·md12·lg20·full | pill default |
| `AppShadow` | xs·sm·md·lg·brand | ink-tinted, never pure black |
| `AppMotion` | standard/emphasized/spring durations+curves | press scale 0.97/0.88; Reduce-Motion → static |

---

## 4. Navigation model (`core/router/`) — see contracts/navigation.md

### `NavDestination` (enum + metadata): `home`, `explore`, `reels`, `messages`, `profile`
| Field | Notes |
|---|---|
| `route` | from `AppRoutes` |
| `icon` / `activeIcon` | Lucide outline / solid |
| `label` | localized |
| `badge` | unread count (Messages only) |
- Rail-only first-class extras: `notifications`, `create` (not bottom-nav destinations).

### `AdaptiveLayoutMode` (derived from width): `phone` (`<700`), `tabletCompact` (`700–979`), `tabletFull` (`980–1099`), `tabletWide` (`≥1100`)
- Selects chrome (bottom nav vs rail compact/full) + whether Home shows the right rail.

### `TwoPaneSelection<T>` (primitive state)
| Field | Notes |
|---|---|
| `items` | list pane source |
| `selected` | current detail (nullable) |
- Tablet: detail rendered in pane; phone: detail pushed. Resize preserves `selected`.

---

## 5. Mock sample shapes (`core/mock/` or `features/dev/`) — in-memory only

> Illustrative display data for placeholders/goldens. **Not** the real domain models; no JSON/persistence. Images come from bundled assets / fake providers (no network).

### `MockUser`: `id`, `username`, `displayName`, `avatarAsset`, `hasUnseenStory`, `isOnline`
### `MockPost`: `id`, `author: MockUser`, `imageAsset` (4:5), `likeCount`, `caption`, `commentCount`, `relativeTime`, `location?`
### `MockStory`: `id`, `author: MockUser`, `seen`
### `MockConversation`: `id`, `peer: MockUser`, `preview`, `relativeTime`, `unread`, `typing`
- `MockData` provider exposes curated lists used by Home (stories + posts), Messages (two-pane demo), etc.

---

## Validation & rules

- All visual rendering of the above MUST go through shared components + tokens (no hardcoded values) — FR-018/023.
- Mock rendering MUST cause zero network requests (FR-026); golden tests use fake image providers.
- `AppFailure` variants each MUST have a localized message in both EN and VI ARB (FR-031).
- `AppState` MUST exercise all four variants in the demo (FR-028a) and be bloc_tested.
