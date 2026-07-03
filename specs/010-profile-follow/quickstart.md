# Quickstart: Profile & Follow (#010)

Validation guide — how to prove the feature works end-to-end in **fake mode** (zero-network) and where the automated coverage lives. Not implementation code; see `tasks.md` for the build steps.

## Prerequisites

- Repo on branch `010-profile-follow`, toolchain Flutter 3.44.4 / Dart 3.12.2.
- App runs DI `environment: 'fake'` (default) — the `FakeProfileRepository` + `RelationshipStore` seed a small graph (public, private, verified, blocked, follows-you accounts) with posts/tagged/followers/following.

## Run

```bash
flutter run                      # fake mode (default); launches to the auth-gated shell
# or drive the hermetic suite:
flutter test
```

## Manual walkthrough (maps to user stories)

1. **US1 — My profile**: open the **Profile** tab → header shows avatar/name/@handle/bio/website + posts/followers/following counts; **Posts** grid renders (reels marked) and paginates; switch to **Tagged** → tagged grid (or empty state); tap **followers**/**following** count → the lists open; **Edit / Share / Settings / Create** entry points route.
2. **US2 — Other profile + follow**: from a post author / search row / a followers row, open `/user/:username` → header + stats + bio + **Follow**. Tap **Follow** → flips to **Following** instantly, follower count +1; kill the network seam (fake failure toggle) and tap Follow → it rolls back with a Toast. Tap **Following** → a **confirm dialog** appears → confirm → reverts. Verify a "Follows you" chip on the seeded mutual account, and that **Message/Report/Block** only toast.
3. **US3 — Lists**: open Followers/Following → two tabs with counts; type in **search** → rows filter; toggle a row's Follow control → same optimistic behavior; the same change is reflected back on that account's profile (canonical `RelationshipStore`); confirm a blocked account never appears.
4. **US4 — Private (viewer-side)**: open the seeded **private** account → header + counts show but the grid is replaced by **"This account is private"**, and tapping followers/following toasts "private"; tap **Follow** → **Requested** (not Following); tap **Requested** → confirm → withdrawn. Open the seeded **approved** private account → its grid renders.
5. **US5 — Edit profile**: Profile → **Edit profile** → change display name/pronouns/website/bio; edit **username** → live availability feedback (Save blocked while taken/checking); **Change profile photo** → pick → crop → the new avatar previews; **Save** → header updates with no manual refresh; force a save failure → edits roll back with a Toast; back out with unsaved edits → discard confirm.
6. **US6 — Inclusive & adaptive**: run with a screen reader (labels on stats/tiles/follow controls, e.g. "Following, button"); set 2× text scale (no overflow) in light + dark; widen to tablet (≥700) → the header reflows wide (avatar 130 + inline stats/actions, centered content, more grid columns).

## Success-criteria checkpoints

| SC | How to verify |
|---|---|
| SC-001 | Every entry point (own profile, other profile, edit, lists) is one tap from its source. |
| SC-002 | Follow/unfollow reflects instantly; a forced failure restores the exact prior control + count with a Toast. |
| SC-003 | Retry a follow after a transient failure (fake retry) → exactly one net relationship, no double-count. |
| SC-004 | Follow on the profile is reflected in the followers/following row (and vice-versa) with no manual refresh (shared `RelationshipStore`); own following count updates. |
| SC-005 | Private account leaks no gated content; blocked account never appears in any list/profile/route (test matrix). |
| SC-006 | Empty/loading/error-retry/offline states present; a11y labels; 2× text scale in light+dark; tablet reflow. |
| SC-007 | Edit (incl. photo) persists + repaints the header without refresh; a failed save leaves the prior profile intact. |

## Automated coverage (authoritative)

- **Cubit/logic (`test()` / `blocTest`, real fake repo + `RelationshipStore`)**: profile load + gating, follow optimistic + rollback + idempotency, count-consistency (SC-004), follow-list pagination + search, username-check states, avatar-save + rollback.
- **Widget (`testWidgets`, stub cubits — no real drift I/O)**: header/stats/follow-button/private-gate/account-row rendering, unfollow confirm dialog, adaptive phone↔tablet, a11y + 2× text scale, goldens (header + follow-button states + private gate + account row, light+dark).
- **Redaction**: no `print`/`debugPrint`; no tokens leaked.

> On-device VoiceOver/TalkBack + physical rotation + long-list memory profiling are deferred to the **#015** release gate (automated coverage is authoritative here), matching #004/#008/#009.

## Notes

- The `contracts/profile-api.md` paths are **derived** from repo conventions — reconcile with the shipped B#010 before wiring `ProfileRepositoryImpl` (`env:['real']`). The fake (`env:['fake']`) is authoritative for all tests.
- No drift schema change (stays v7); no new pub dependency.
