# Contract — Navigation (routes, shell, deep links)

The stable navigation surface every later spec routes against. Defined in `core/router/` + `core/constants/app_routes.dart`.

## Route table (`AppRoutes`)

> Paths are the contract; constants are referenced via `AppRoutes.x` — never literal strings (Constitution X). Flow/auth routes are **top-level** (outside the shell) → render nav-less full-screen. `#001` ships these as placeholders unless noted.

### Pre-auth zone (no nav chrome)
| Name | Path | #001 state |
|---|---|---|
| splash | `/splash` | placeholder |
| onboarding | `/onboarding` | placeholder |
| signIn | `/sign-in` | placeholder |
| signUp | `/sign-up` | placeholder |
| forgotPassword | `/forgot-password` | placeholder |
| profileSetup | `/profile-setup` | placeholder |

### Main app — `StatefulShellRoute.indexedStack` (5 branches, nav chrome shown)
| Destination | Path (branch root) | #001 state |
|---|---|---|
| home | `/home` | real-fidelity placeholder (StoriesRail + PostCards) |
| explore | `/explore` | placeholder |
| reels | `/reels` | placeholder |
| messages | `/messages` | placeholder (two-pane on tablet) |
| profile | `/profile` | placeholder |

### Flow / full-screen routes (nav-less, pushed) — placeholders this spec
`/story/:id` · `/reel/:id` · `/create` (post/story/reel entry) · `/post/:id` · `/post/:id/comments` · `/chat/:id` · `/notifications` · `/settings` · `/profile/edit` · `/search`
- Rule: any route NOT one of the 5 branch roots hides the bottom nav / shows inside the tablet content pane per its surface.

### Dev harness (dev flavor only)
`/dev/gallery` (component gallery) · `/dev/states` (4-state demo) · `/dev/two-pane` (master/detail demo)

## Auth guard (stubbed)

- `redirect` reads `AuthGuardStub.isSignedIn` (toggleable, dev-only).
- Signed-out → any main/flow route redirects to `/splash` (pre-auth zone).
- Signed-in → pre-auth routes redirect to `/home`.
- Contract is final; #003 swaps `AuthGuardStub` for the real session source with no route changes.

## Adaptive chrome rules

| Width | Chrome | Content |
|---|---|---|
| `<700` | bottom nav (5 dest, Messages badge) | single column; flow routes push full-screen |
| `700–979` | sidebar rail **compact** (icon-only) + Notifications/Create/profile chip | centered content; two-pane where applicable |
| `980–1099` | sidebar rail **full** (icon+label) | centered content (feed ≤560, profile ≤900, notif ≤620) |
| `≥1100` | sidebar rail full | Home adds right "Suggestions" rail |

- Navigation MUST use `context.go/push/pop` only. Tab switches preserve per-branch stack + scroll (stable keys).

## Deep-link contract (`DeepLinkParser`)

- Scheme `we36://` + universal/app links.
- MUST validate scheme + known path + param shape **before** routing; reject malformed/unknown → safe fallback (no crash, no open).
- #001 wires the parser + validation + rejection; per-feature targets (post/profile/hashtag/chat) are added by their specs.
