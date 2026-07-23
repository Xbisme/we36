# We36 — Design System

A design system for **We36**, a modern social-media app for sharing photos and video — feed, stories, reels, and messaging. The look is youthful, colorful but clean, friendly and community-driven. Its signature is a **warm rose → violet gradient**.

> **Sources:** This system was authored from a written brand brief (no codebase or Figma was attached). The color palette, type direction, and component list were specified by the product owner. If a codebase or Figma file exists, attach it via the Import menu so components and screens can be made pixel-accurate.

---

## Core principle — color earns its place

Surfaces, feed, and chrome stay **clean and neutral**. Saturated brand color appears **only on highlights**: the primary action button, story rings, the active nav icon, badges, and stickers. Never use the gradient as a full-page wash. This keeps user photos and video the star of every screen.

---

## Visual foundations

- **Color.** Primary rose `#FF4E64`; accent violet `#8B5CF6`; secondary accents amber `#FFB627` (warm) and mint `#2DD4BF` (cool, also presence/online). Each ships a 50→900 tonal scale. Neutrals run from ink `#1A1A2E` (a slightly violet-tinted near-black, never pure black) through a gray ramp to white. Full **light and dark** themes via `[data-theme]`; dark surfaces are ink-tinted (`#0E0E1A` app bg, `#1A1A2E` surface), not gray.
- **Gradients.** `--gradient-brand` (rose→violet, 135°) for primary buttons and the wordmark; `--gradient-brand-soft` for hover/large fills; `--gradient-story` (amber→rose→violet) reserved for unseen story rings. Seen story rings desaturate to a flat gray border.
- **Type.** Display/logo in **Plus Jakarta Sans** (extra-bold, tight tracking, lots of character); body/UI in **Inter** (highly legible). Scale: Display 44/52·800, H1 32/40·700, H2 24/32·700, H3 20/28·600, Body 16/24·400, Label 14/20·600, Caption 13/18·400.
- **Spacing.** 4px base scale: 4, 8, 12, 16, 24, 32, 48, 64. Feed column maxes at 470px; mobile gutter 16px. Minimum tap target 44px.
- **Radius.** sm 8 · md 12 (inputs, small cards) · lg 20 (post cards, sheets) · full (buttons, avatars, chips, switches). Pills are the default for anything interactive and text-based.
- **Elevation.** Soft, low-spread neutral shadows (`xs`→`lg`) tinted with the ink color, never pure black. A dedicated `--shadow-brand` rose glow is used sparingly under primary CTAs on hover.
- **Cards.** White (or dark `surface`) fill, 1px `--border` hairline, `radius-lg`, `shadow-sm`. Post media uses a 4:5 aspect ratio.
- **Motion.** Standard ease `cubic-bezier(0.2,0,0,1)` at 200ms; a springy `cubic-bezier(0.34,1.56,0.64,1)` for press/toggle feedback. Hover = soft tint or gradient-soft swap + brand glow; **press = scale down** (buttons 0.97, icon buttons 0.88). Toggles slide the knob with the spring curve. No infinite decorative loops.
- **Imagery.** Real user photography, warm and vivid. Media fills its frame (`object-fit: cover`). Reels use a full-bleed dark frame with a bottom protection gradient under captions.
- **Transparency & blur.** Overlays use `--overlay` (ink at ~45% light / black 60% dark). Protection gradients (not solid scrims) sit under text on imagery.

---

## Content fundamentals — voice & tone

- **Friendly, warm, lowercase-leaning.** UI labels are Sentence case and short ("Add to your story", "View all 86 comments", "For you"). Captions and user copy are casual and lowercase, emoji welcome ("golden hour never misses ☀️").
- **Second person, encouraging.** Speak to the user as "you" / "your" ("Your story", "Share your world"). Never corporate or formal.
- **Emoji.** Used naturally in user content and occasionally in playful UI moments — never decorating system/error messaging.
- **Numbers.** Abbreviated for scale (`38.4k`, `24.1k`, `1.2k`), spelled in full for small counts ("1,240 likes").
- **Hashtags.** Rendered as chips with a tinted `#` glyph; topic words are lowercase, no spaces.

---

## Iconography

- **One unified set** — `Icon` component using **Lucide** geometry (ISC-licensed): 24×24 grid, 2px stroke, round caps/joins. Outline by default; a **solid** variant fills the glyph for active states (home, like, save, reels). Names: `home, search, reels, message, profile, like, comment, share, save, notification, plus, more, settings, check, x, camera, chevronLeft`.
- Icons inherit `currentColor`; active feed/nav icons switch to `--icon-active` (rose). No emoji-as-icon, no mixed icon families. Reuse `Icon` everywhere rather than inlining SVG.
- The brand mark is the **We36 wordmark** set in Plus Jakarta Sans 800 — gradient-clipped on light surfaces, solid white on the gradient or ink. See `guidelines/brand-logo.html`.

---

## Index / manifest

**Foundations** (`styles.css` → `tokens/`)
- `tokens/colors.css` — palette, tonal scales, gradients, status, light/dark semantic aliases
- `tokens/typography.css` — font families, weights, type scale (loads Plus Jakarta Sans + Inter from Google Fonts)
- `tokens/spacing.css` — spacing, layout, radius, shadow, motion tokens

**Components** (`components/`) — React, consume tokens via CSS variables
- `buttons/` — `Button` (primary/secondary/ghost), `IconButton`
- `forms/` — `Input`, `SearchBar`, `Switch`
- `display/` — `Avatar` (+story ring), `Badge`, `Tag`, `PostCard`
- `navigation/` — `BottomNav`
- `icons/` — `Icon` (unified Lucide-based set)

**Specimen cards** (`guidelines/`) — populate the Design System tab (Colors, Type, Spacing, Brand groups).

**UI kit** (`ui_kits/we36-app/`) — interactive mobile app: Feed, Explore, Reels, Profile, tied together with the bottom tab bar. Entry: `index.html`.

**`SKILL.md`** — makes this system usable as a downloadable Agent Skill.

---

## Using the system

Consuming projects link the single `styles.css` and read components from the compiled bundle:

```html
<link rel="stylesheet" href="styles.css">
<script src="_ds_bundle.js"></script>
<script>const { Button, PostCard } = window.We36DesignSystem_f909ab;</script>
```

> **Font note:** Plus Jakarta Sans and Inter are loaded from Google Fonts (the brief's suggested fonts). If you need self-hosted webfont binaries shipped with the system, provide the licensed font files and they'll be wired up as `@font-face`.
