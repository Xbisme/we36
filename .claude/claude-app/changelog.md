# We36 — Changelog

> Append-only ship history. One entry per spec as it lands. Newest at top.
> Format: `### YYYY-MM-DD — Spec #NNN <Name> ✅ <verb>` + 1–4 bullets.
> (See [`dev-workflow.md`](dev-workflow.md) §Changelog Entry Format for the `<verb>` vocabulary.)

---

### 2026-06-30 — Spec #001 Project Foundation, Design System & Navigation ✅ MERGED INTO MAIN

- **Shipped**: Clean Architecture shell (`core/` + `features/`), dev/prod flavors + entry points, auth-guarded `go_router` skeleton (pre-auth flow vs 5-tab `StatefulShellRoute`) with placeholder destinations on mock data, **adaptive shell** (phone bottom-nav `<700` ↔ tablet `SidebarRail` `≥700`, compact/full by width) + reusable two-pane/master-detail primitive, **fixed light/dark token system** (`AppColorsX` ThemeExtension + `AppColors`/`AppTypography`/`AppGradients`/spacing/radius/shadow/motion), full **shared component library** (`AppButton`/`AppIconButton`/`AppIcon`/`Avatar`/`PostCard`/`BottomNav`/`SidebarRail`/`StoriesRail`/`TopBar`/`Toast`/`ActionSheet`/`AppDialog`…), foundation primitives (`Result<T>`/`AppFailure`/`AppCubit` 4-state/`AppLogger`/formatters), DI, EN+VI ARB l10n. **No networking/auth/persistence** (those are #002/#003).
- **Tech notes**: 73 Dart files; 46 tests green incl. **12 goldens** (token gallery + PostCard/Avatar/BottomNav/SidebarRail, light+dark) — real brand fonts loaded in tests via `test/flutter_test_config.dart`; a hardcoded-color/`TextStyle` CI guard enforces the token discipline (T078a).
- **Follow-ups carried**: bounded `cacheWidth`/`cached_network_image` for feed thumbnails deferred to #004 (no image decode active at #001 — mock providers are null → placeholder surfaces); true on-device VoiceOver/TalkBack + physical-rotation recording deferred to the #015 release gate (automated a11y/text-scale/adaptive coverage is green).
- **Decisions still open for #002**: local cache engine (drift vs hive); dev/prod API base URL + realtime endpoint; bundle ids.

---

_Project bootstrap (constitution v1.0.0 + `.claude/claude-app/` docs) is recorded in [`project-context.md`](project-context.md), not here — this file tracks shipped feature specs only._
