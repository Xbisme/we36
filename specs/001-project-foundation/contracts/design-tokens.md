# Contract — Design Tokens (semantic aliases → light/dark)

The token interface every screen/component depends on. Values from `ui-design-context.md` §Design Tokens (source of truth). Call sites use **alias names**, never hex (Constitution VI, FR-018).

## Brand & accent (raw ramps — referenced only by token definitions, not call sites)
- rose-500 `#FF4E64` (base) · violet-500 `#8B5CF6` · amber-400 `#FFB627` · mint-400 `#2DD4BF`
- ink `#1A1A2E` (never pure black) · grays 50→500 · white

## Semantic color aliases (`AppColorsX` ThemeExtension)
| Alias | Light | Dark |
|---|---|---|
| `bgApp` | gray-50 | `#0E0E1A` |
| `surface` | white | `#1A1A2E` |
| `surface2` | gray-100 | `#24243C` |
| `surfaceSunken` | gray-100 | `#131322` |
| `border` | gray-200 | `#2E2E48` |
| `borderStrong` | gray-300 | `#3D3D5C` |
| `divider` | gray-100 | `#24243C` |
| `textPrimary` | ink | `#F3F4F6` |
| `textSecondary` | gray-500 | gray-400 |
| `textTertiary` | gray-400 | gray-500 |
| `textOnBrand` | white | white |
| `accent` / `accentHover` / `accentPress` | rose-500/600/700 | rose-500/400/300 |
| `accentSoft` | rose-50 | rgba(255,78,100,.16) |
| `icon` / `iconActive` | gray-500 / rose-500 | gray-400 / rose-400 |
| `overlay` | rgba(26,26,46,.45) | rgba(0,0,0,.6) |
| `success`/`warning`/`error`/`info` | `#22C55E`/`#F59E0B`/`#EF4444`/`#3B82F6` | same (+ `*-soft` ~12%) |

## Gradients (`AppGradients`)
- `brand` = 135° `#FF4E64`→`#8B5CF6` — primary CTA, wordmark, own message bubble, create.
- `brandSoft` = 135° `#FF6B82`→`#9D7BFA` — hover / large fills.
- `story` = 135° `#FFB627`→`#FF4E64 45%`→`#8B5CF6` — **unseen** story ring only (seen = flat gray border).
- **Rule**: gradient NEVER a full-page background (FR-020).

## Typography (`AppTypography`)
- Display/Heading/wordmark = **Plus Jakarta Sans** (400–800); Body/UI = **Inter** (400–700). Counts/stats = Plus Jakarta Sans bold.
- Scale: Display 44/52·800 · H1 32/40·700 · H2 24/32·700 · H3 20/28·600 · Body 16/24·400 · Label 14/20·600 · Caption 13/18·400. Tracking tight `-0.02em` headings (wordmark `-0.03em`).
- Fonts **bundled** (no runtime fetch); must scale with OS text-scaler without clipping (SC-012).

## Spacing / Radius / Shadow / Motion
- Spacing (`AppSpacing`): 4·8·12·16·24·32·48·64. Gutter 16. Feed column ≤470 (phone). Tap target ≥44.
- Radius (`AppRadius`): sm 8 · md 12 · lg 20 · full 9999 (pill = default for interactive).
- Shadow (`AppShadow`): xs/sm/md/lg + `brand` (`0 8px 24px rgba(255,78,100,.32)`, under primary CTA only). Ink-tinted, never pure black.
- Motion (`AppMotion`): standard `cubic-bezier(0.2,0,0,1)` 200ms · emphasized · spring (press/toggle). Press = scale-down (button 0.97, icon 0.88). Reduce-Motion → static; no infinite decorative loops (FR-021).

## Enforcement
- "Color earns its place": chrome/feed/surfaces neutral; brand color/gradient ONLY on primary CTA, unseen story ring, active nav item, badge, sticker (FR-020).
- A lint/review check: no raw `Color(0x…)` / `Colors.*` at feature/component call sites; all via `context.tokens`.
