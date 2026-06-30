# Contract — Shared Component Library (public API surface)

The stable widget API feature specs compose against (Constitution VI: built once in `core/presentation/`, never duplicated). Every component: consumes only tokens, themes light+dark, exposes `Semantics`, supports text-scaling, press-scale feedback. Variants/states below are the contract — golden-tested where noted.

| # | Component | Key params / variants | States | Golden |
|---|---|---|---|---|
| 1 | `AppButton` | `kind: primary\|secondary\|ghost`, `label`, `onPressed`, `size: sm\|md`, `fullWidth`, `leadingIcon?` | enabled/pressed(scale .97)/disabled | ✓ |
| 2 | `AppIconButton` | `icon`, `onPressed`, `badgeCount?` | pressed(scale .88) | |
| 3 | `AppIcon` | `name (AppIcons)`, `size=24`, `active`(solid) | outline/solid | |
| 4 | `Avatar` | `imageProvider`, `size 28–104`, `ring: none\|unseen\|seen`, `online`, `me`(create badge) | ring/online/create | ✓ |
| 5 | `Badge` | `count?` (dot if null) | — | |
| 6 | `Tag` | `label`, `active`, `hashtag`(# violet glyph) | default/active | |
| 7 | `PostCard` | `post: MockPost`, callbacks(like/comment/share/save) | like/save active(solid) | ✓ |
| 8 | `SearchBar` | `hint`, `onTap`/`onChanged`, `readOnly` | — | |
| 9 | `AppSwitch` | `value`, `onChanged` | on(accent)/off, spring knob | |
| 10 | `BottomNav` | `destinations`, `currentIndex`, `onSelect`, `badges` | active(solid+iconActive) | ✓ |
| 11 | `SidebarRail` | `destinations`+extras(Notifications/Create), `profileChip`, `compact` | compact/full, active(accentSoft pill) | ✓ |
| 12 | `StoriesRail` | `stories: List<MockStory>`, `meBadge` | unseen ring/seen | |
| 13 | `TopBar` | `title?`, `leading?`(chevronLeft), `actions?`, `large` | default/large | |
| 14 | `PaneHeader` | `title`, `back?`, `actions?` (tablet content header, h60) | — | |
| 15 | `Wordmark` | `mono`(white) vs gradient-clipped, `size` | gradient/mono | |
| 16 | `Toast` (via `ToastService`) | `message`, `tone: success\|info\|error\|neutral`, `action?` | 4 tones | |
| 17 | `ActionSheet` | `title?`, `items: [icon,label,destructive?]`, `cancel` | normal/destructive | |
| 18 | `AppDialog` | `title`, `body`, `primary`, `secondary`, `destructive?` | normal/destructive | |
| 19 | `StickerTray` | `categories`, `onPick` | — | |

## Layout primitives (`core/router/` or `core/presentation/`)
| Component | Contract |
|---|---|
| `AdaptiveShell` | wraps the tab shell; width `<700`→`Scaffold`+`BottomNav`; `≥700`→`Row(SidebarRail, Expanded(content))` compact/full by `≥980`; right rail slot `≥1100` |
| `TwoPaneScaffold<T>` | tablet→`Row(list, detail)` swap-in-place on select (no push); phone→push detail full-screen; preserves selection across resize |
| `MaxWidthBox` | centers content at a max width (feed 560 / profile 900 / notif 620) on wide layouts |

## Cross-cutting contract
- No component constructs a `Color`/`TextStyle` literal — all via `context.tokens` / `AppTypography`.
- Every interactive component: `Semantics` label/role (icon-only included), ≥44px tap target, press-scale, Reduce-Motion static.
- Components are pure presentation: no DI, no Cubit, no navigation inside (callbacks out); `ToastService`/`ActionSheet`/`AppDialog` invoked via an injected presenter service.
- Feature specs MUST compose these; re-implementing their markup is forbidden (FR-023).
