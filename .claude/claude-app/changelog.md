# We36 — Changelog

> Append-only ship history. One entry per spec as it lands. Newest at top.
> Format: `### YYYY-MM-DD — Spec #NNN <Name> ✅ <verb>` + 1–4 bullets.
> (See [`dev-workflow.md`](dev-workflow.md) §Changelog Entry Format for the `<verb>` vocabulary.)

---

### 2026-06-30 — Spec #003 Auth & Onboarding ✅ COMPLETE (branch `003-auth-onboarding`, awaiting merge)

- **Shipped (US1–US5, 75/75 tasks; on-device + dev-backend smoke verified)**: the auth **gate** — Splash (session restore) · first-launch Onboarding (Get started→Sign up / Skip→Sign in) · **Sign in** + **Sign up** (email-only, ≥8 pwd) · **Forgot password** (email **6-digit OTP** + resend cooldown) · **OAuth** Google (always) / Apple (iOS-only, FR-022) · **Profile setup** (live username availability, no avatar). Real `TokenStore`/`TokenRefresher` over `flutter_secure_storage`, `AuthRepository`/`MeRepository` (+ in-memory fakes), `SessionController` (cold-start routing, single-flight refresh reuse, **forced-logout-once + cache wipe**) replacing the #001 `AuthGuardStub`. drift schema v1→v2 (`MeProfiles` + `clearUserScoped`).
- **Tech notes**: **154 tests green**, `dart analyze` clean (2 pre-existing pubspec-sort infos), app still runs DI `environment: 'fake'` (real impls behind `env:['real']`; **`RealTokenStore` env-agnostic** so a fake-issued session persists across restart — analyze finding I1). New deps `google_sign_in ^7.2.0` (v7 singleton API) · `sign_in_with_apple ^8.1.0` · `shared_preferences ^2.5.5`. Added shared `AppTextField` + `OtpInput`. Log-redaction test locks FR-014/SC-008. Goldens regenerated after the **Flutter 3.41→3.44 / Dart 3.12** toolchain bump.
- **Follow-ups carried (8 tasks)**: native config **T002/T003** (iOS deployment target 13 + Sign in with Apple capability/entitlement + Google URL scheme; Android minSdk 24 + launch mode) and OAuth client-id/Service-ID provisioning — needed before a real-backend run; **T072** quickstart on a dev backend; **T074** on-device smoke (OAuth round-trip, real refresh, OTP) — none CI-gateable.

---

### 2026-06-30 — Spec #002 Networking, Cache & Realtime Core ✅ MERGED INTO MAIN

- **Shipped**: `ApiClient` (single `Dio`) behind idempotency → auth-token → **single-flight refresh** → redacted-logging interceptors; centralized HTTP→`AppFailure` mapping (`FailureMapper`, envelope `{error:{code,message,details}}`, contract-stable `code`s); cursor pagination (`CursorPage<T>`) + reusable 4-state `PaginatedListCubit<T>`; **drift** cache base (`AppDatabase` + `UsersDao`, reactive `.watch()` reads) + migration harness; `RealtimeClient` **Socket.IO** scaffold + typed events + fake (wired in #012/#013); repository pattern + in-memory fakes proven by the `User` reference slice. App runs DI `environment: 'fake'` — fully offline/zero-network. **No auth UI/session persistence** (that's #003).
- **Tech notes**: 50/50 tasks; **103 tests green**, `dart analyze` clean. Token seams `TokenStore`/`TokenRefresher`/`AuthEventsSink` are fakes now — real impls land in #003. Endpoints/events centralized in `core/constants/{api_endpoints,socket_events}.dart` (no inline literals).
- **Decisions resolved**: local cache engine = **drift** (over hive); realtime transport = **`socket_io_client`** (backend gateway is Socket.IO) → constitution PATCHed to v1.0.2. `drift_dev` pinned (2.34.1 needs analyzer 13).
- **Follow-ups carried**: `RealtimeClient` wiring deferred to #012/#013; `TokenStore`/refresh real impls + `flutter_secure_storage` land in #003; on-device/dev-backend socket + refresh smoke test deferred to feature specs.

---

### 2026-06-30 — Spec #001 Project Foundation, Design System & Navigation ✅ MERGED INTO MAIN

- **Shipped**: Clean Architecture shell (`core/` + `features/`), dev/prod flavors + entry points, auth-guarded `go_router` skeleton (pre-auth flow vs 5-tab `StatefulShellRoute`) with placeholder destinations on mock data, **adaptive shell** (phone bottom-nav `<700` ↔ tablet `SidebarRail` `≥700`, compact/full by width) + reusable two-pane/master-detail primitive, **fixed light/dark token system** (`AppColorsX` ThemeExtension + `AppColors`/`AppTypography`/`AppGradients`/spacing/radius/shadow/motion), full **shared component library** (`AppButton`/`AppIconButton`/`AppIcon`/`Avatar`/`PostCard`/`BottomNav`/`SidebarRail`/`StoriesRail`/`TopBar`/`Toast`/`ActionSheet`/`AppDialog`…), foundation primitives (`Result<T>`/`AppFailure`/`AppCubit` 4-state/`AppLogger`/formatters), DI, EN+VI ARB l10n. **No networking/auth/persistence** (those are #002/#003).
- **Tech notes**: 73 Dart files; 46 tests green incl. **12 goldens** (token gallery + PostCard/Avatar/BottomNav/SidebarRail, light+dark) — real brand fonts loaded in tests via `test/flutter_test_config.dart`; a hardcoded-color/`TextStyle` CI guard enforces the token discipline (T078a).
- **Follow-ups carried**: bounded `cacheWidth`/`cached_network_image` for feed thumbnails deferred to #004 (no image decode active at #001 — mock providers are null → placeholder surfaces); true on-device VoiceOver/TalkBack + physical-rotation recording deferred to the #015 release gate (automated a11y/text-scale/adaptive coverage is green).
- **Decisions still open for #002**: local cache engine (drift vs hive); dev/prod API base URL + realtime endpoint; bundle ids.

---

_Project bootstrap (constitution v1.0.0 + `.claude/claude-app/` docs) is recorded in [`project-context.md`](project-context.md), not here — this file tracks shipped feature specs only._
