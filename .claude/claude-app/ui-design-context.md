# We36 — UI Design Context

> **Vai trò file này**: single source of truth cho **giao diện** — screens, design tokens, components, navigation IA. Mọi spec có phần UI/UX phải bám file này. Khi implement một màn, đọc file này + pull bản design gốc từ claude_design MCP (xem "Design Source" bên dưới) để lấy chi tiết pixel.
>
> Last updated: 2026-06-30 (Imported from claude_design project "We36" — design system + 31 screen mockups across Auth / Feed / Reels / Compose / Explore / Profile / Messaging / Notifications / Settings / Overlays. **+ Responsive: tablet/iPad layouts** distilled from `We36 Responsive.html` + `screens/tablet.jsx` — see §Responsive — Tablet & iPad.)

## Design Source

- **claude_design MCP project**: `We36` — projectId `f031b888-4810-473d-9879-9cb3968c577c` (owner DTECH).
- **Design system id**: `we36-design-system-f909ab49-9b17-4c9a-ad59-1fe057c7c6c3`.
- **Connector**: `https://api.anthropic.com/v1/design/mcp`. Nếu chưa authorize → user chạy `/design-login` (cần scope `user:design:read/write`). Đọc bằng tool `DesignSync` (`get_project` / `list_files` / `get_file`).
- **Key files trong project**:
  - `We36 Screen Mockups.html` — board tổng hợp tất cả màn (entry point để xem toàn bộ).
  - `We36 Prototype.html` — bản prototype có điều hướng (wires nav giữa các màn).
  - `We36 Responsive.html` + `screens/tablet.jsx` — layout responsive cho tablet/desktop.
  - `screens/*.jsx` — **spec layout chi tiết nhất** (markup + mock data từng screen): `auth.jsx`, `feed.jsx`, `explore.jsx`, `profile.jsx`, `messaging.jsx`, `settings.jsx`, `overlays.jsx`, `helpers.jsx` (Frame/TopBar/Wordmark + sample data).
  - `_ds/we36-design-system-…/tokens/{colors,typography,spacing}.css` — design tokens (nguồn cho bảng token bên dưới).
  - `_ds/we36-design-system-…/readme.md` — design-system rationale (color earns its place, voice & tone, iconography).
  - `_ds/we36-design-system-…/_ds_bundle.js` — compiled React components (`Button`, `IconButton`, `Avatar`, `Badge`, `Tag`, `PostCard`, `SearchBar`, `Switch`, `BottomNav`, `Icon`).
- **Platform khung hình**: iOS-style (notch, status bar 9:41), 390pt frame, feed cột đơn max 470px. Layout responsive cho cả Android + tablet.

> ⚠️ **Lưu ý**: design này được author từ **brand brief viết tay** (không có Figma/codebase đính kèm) → component-level + screen-mockup-level, KHÔNG phải pixel-perfect Figma. Khi code lệch nhỏ so với mock, ưu tiên **token + readme rationale**; cập nhật file này (kèm lý do) khi UI thực tế tinh chỉnh một màn.

---

## Brand Principle — "color earns its place"

Surfaces, feed, và chrome giữ **neutral & sạch**. Màu brand bão hoà chỉ xuất hiện ở **điểm nhấn**: nút CTA chính, story ring (chưa xem), icon nav đang active, badge, sticker. **KHÔNG** dùng gradient làm nền cả trang — để ảnh/video người dùng là ngôi sao. Đây là luật thẩm mỹ cốt lõi (Constitution VI).

- Voice & tone: **thân thiện, ấm, hơi lowercase, ngôi thứ hai ("you/your")**. Label UI = Sentence case, ngắn ("Add to your story", "View all 86 comments", "For you"). Caption người dùng = casual, lowercase, emoji thoải mái. Emoji KHÔNG dùng cho system/error.
- Số liệu: viết tắt khi lớn (`38.4k`, `24.1k`, `1.2M`), viết đủ khi nhỏ ("1,240 likes"). Thời gian tương đối (`2h`, `1d`).
- Hashtag = chip với glyph `#` tô màu (violet), từ khoá lowercase không dấu cách.

---

## Navigation IA (QUAN TRỌNG)

Hai vùng điều hướng tách biệt bởi **auth guard** (Constitution X):

**1. Pre-auth (KHÔNG có bottom nav)** — Splash → Onboarding → Sign in / Sign up → Forgot password → Profile setup. Đăng nhập xong → `home`.

**2. Main app — Bottom NavigationBar = 5 tab**: **Home (Feed)** · **Explore** · **Reels** · **Messages** · **Profile**.

- **Create** (đăng bài / story / reel) **KHÔNG phải tab** — là **hành động ngữ cảnh**: nút `+` ở Profile header, ô "Your story" ở stories rail, camera ở Reels, camera ở chat. Mở flow full-screen (push, ẩn bottom nav).
- **Activity (Notifications)** + **DM shortcut** truy cập từ **icon góc phải header Home** (chuông + tin nhắn); Messages cũng là 1 bottom tab (badge số chưa đọc). Header Home là shortcut phụ tới cùng DM list.
- Các màn flow (story/reel viewer, create-post 3 bước, chat, comments, full-image viewer, edit profile, settings…) là **full-screen pushed routes, ẩn bottom nav**.

```
[auth flow] (no nav)  →  login  →
BottomNav (5 tabs)
├── Home (feed)        ← header: Wordmark + Activity(chuông) + Messages
│     ├── StoriesRail → Story viewer / Create story
│     ├── PostCard → Post detail → Comments
│     └── header → Notifications · DM list
├── Explore (search)   ← grid khám phá + search → results → hashtag/place
├── Reels              ← feed video dọc + camera → create
├── Messages (DM)      ← conversation list → chat → new message
└── Profile            ← my profile (+ → create, settings) · grid/saved tabs
```

`showNav = home | explore | reels | messages | profile`. Mọi màn flow khác ẩn nav. Bottom tab dùng `StatefulShellRoute.indexedStack` (giữ scroll/stack từng tab).

> ℹ️ Chốt slot thứ-4/5 của BottomNav: design truyền `badges={{ message: N }}` vào `BottomNav` ở mọi màn tab → có **Messages tab** (badge chưa đọc). Active values quan sát được trong mock: `home`, `search`(=Explore), `reels`, `profile`, + `message`. **Create không phải tab.** Nếu khi dựng `BottomNav` (#001) phát hiện component thực tế khác (vd có nút Create giữa), cập nhật mục này.

> 📱→💻 **Trên tablet/iPad bottom nav được THAY bằng left SidebarRail** (xem §Responsive — Tablet & iPad). Cùng một `nav` model + route, chỉ khác cách render chrome theo bề rộng. Sidebar rail mở rộng nav: thêm **Notifications** + **Create** thành mục first-class (trên mobile chúng ở header/contextual).

---

## Design Tokens

### Color — fixed palette, Light mặc định, Dark là ink-tinted (không phải gray)

**Brand rose (primary/accent)**: `--rose-500 #FF4E64` (base) · ramp 50 `#FFF1F3` → 900 `#7A1828`.
**Accent violet**: `--violet-500 #8B5CF6` · ramp 50 `#F5F1FF` → 900 `#3F1E80`. (hashtag, link, "Share to Stories" toggle…)
**Accent amber (warm)**: `--amber-400 #FFB627`. **Accent mint (cool / online/presence)**: `--mint-400 #2DD4BF`.
**Neutral**: ink `#1A1A2E` (gần-đen ám violet, **không bao giờ pure black**) · gray 500 `#6B7280` · 400 `#9CA3AF` · 300 `#D1D5DB` · 200 `#E5E7EB` · 100 `#F3F4F6` · 50 `#F9FAFB` · white `#FFFFFF`.
**Status**: success `#22C55E` · warning `#F59E0B` · error `#EF4444` · info `#3B82F6` (+ soft `*-soft` ~10–16% cho nền).

**Gradients**:
- `--gradient-brand`: `linear-gradient(135deg, #FF4E64, #8B5CF6)` — CTA chính, wordmark, bubble tin nhắn của mình, nút create.
- `--gradient-brand-soft`: `linear-gradient(135deg, #FF6B82, #9D7BFA)` — hover / fill lớn.
- `--gradient-story`: `linear-gradient(135deg, #FFB627, #FF4E64 45%, #8B5CF6)` — **chỉ** story ring **chưa xem**; ring **đã xem** = viền gray phẳng.

**Semantic aliases** (dùng tên này trong code, đừng hardcode hex):

| Token | Light | Dark |
|---|---|---|
| `bg-app` (nền màn) | gray-50 | `#0E0E1A` |
| `surface` (card/header) | white | `#1A1A2E` |
| `surface-2` / `surface-sunken` | gray-100 | `#24243C` / `#131322` |
| `border` / `border-strong` | gray-200 / 300 | `#2E2E48` / `#3D3D5C` |
| `divider` | gray-100 | `#24243C` |
| `text-primary / secondary / tertiary` | ink / gray-500 / gray-400 | `#F3F4F6` / gray-400 / gray-500 |
| `text-on-brand` | white | white |
| `accent / hover / press` | rose-500 / 600 / 700 | rose-500 / 400 / 300 |
| `accent-soft` | rose-50 | rgba(255,78,100,.16) |
| `icon / icon-active` | gray-500 / rose-500 | gray-400 / rose-400 |
| `overlay` | rgba(26,26,46,.45) | rgba(0,0,0,.6) |

### Typography

- **Display + Heading + logo**: **Plus Jakarta Sans** (400/500/600/700/800) — characterful, tight tracking, extra-bold cho tiêu đề + wordmark.
- **Body + UI**: **Inter** (400/500/600/700) — dễ đọc. (cả hai load qua google_fonts.)
- Scale: Display 44/52·800 · H1 32/40·700 · H2 24/32·700 · H3 20/28·600 · Body 16/24·400 · Label 14/20·600 · Caption 13/18·400.
- Tracking: tight `-0.02em` (tiêu đề, wordmark `-0.03em`) · normal 0 · wide `0.04em` (section caption uppercase).
- Số đếm/stat (`38.4k`, "248 posts") dùng **Plus Jakarta Sans** (display) bold; body/caption dùng Inter.

### Spacing / Radius / Shadow / Motion

- **Spacing** 4px base: 4 · 8 · 12 · 16 · 24 · 32 · 48 · 64. Mobile gutter 16px · feed cột max 470px · tap target ≥ 44px.
- **Radius**: sm 8 · md 12 (input, card nhỏ) · lg 20 (post card, sheet) · full 9999 (button, avatar, chip, switch, pill). Pill là mặc định cho mọi thứ interactive + text.
- **Shadow** (ink-tinted, không pure black): xs `0 1px 2px rgba(26,26,46,.06)` · sm `0 1px 3px /.08` · md `0 4px 12px /.10` · lg `0 12px 28px /.14` · `--shadow-brand` `0 8px 24px rgba(255,78,100,.32)` (chỉ dưới CTA chính, dùng tiết kiệm).
- **Motion**: standard `cubic-bezier(0.2,0,0,1)` 200ms · emphasized `cubic-bezier(0.3,0,0,1)` · spring `cubic-bezier(0.34,1.56,0.64,1)` (press/toggle). **Press = scale down** (button 0.97, icon button 0.88). **KHÔNG có vòng lặp trang trí vô hạn.** Reduce-Motion: trạng thái tĩnh.
- **Imagery**: ảnh thật, ấm; media `object-fit: cover` đầy khung. Post media tỉ lệ **4:5**. Reels full-bleed nền tối + protection gradient (không phải scrim đặc) dưới caption.

---

## Shared Components (dựng thành shared widgets ở #001 — không lặp markup mỗi feature)

- **Button**: `primary` (gradient-brand pill, chữ trắng, bold, +shadow-brand khi hover), `secondary` (viền/`surface-2` pill, chữ primary), `ghost` (trong suốt). Sizes `sm`/default; `fullWidth`. Press = scale 0.97.
- **IconButton**: icon Lucide 24px trong vùng tap ≥44px, press scale 0.88. (vd header Activity/Messages.)
- **Icon**: bộ **Lucide** thống nhất 24×24, stroke 2px, round cap. Outline mặc định; **solid** cho active (home, like, save, reels). Tên dùng: `home, search, reels, message, profile, like, comment, share, save, notification, plus, more, settings, check, x, camera, chevronLeft`. Active nav/like → `icon-active` (rose). KHÔNG emoji-as-icon, KHÔNG trộn icon family.
- **Avatar**: tròn, sizes 28–104. `ring` = story ring (gradient-story chưa xem / gray đã xem `seen`). `online` = chấm mint góc dưới. `me` = badge `+` gradient (tạo story).
- **Badge**: chấm/đếm rose nhỏ (nav unread, notification dot).
- **Tag / hashtag chip**: pill `surface-2`, `active` = gradient/đậm; `hashtag` = có glyph `#` violet.
- **PostCard**: card `surface` viền hairline `border`, radius-lg. Header (avatar + user + location + `more`), media 4:5 cover, action row (`like`/`comment`/`share` trái + `save` phải), likes (bold), caption (user + caption, hashtag violet), "View all N comments", time caption. Like/save = solid khi active.
- **SearchBar**: pill `surface-2`, icon search trái, placeholder `text-tertiary`.
- **Switch**: track pill, knob trắng trượt theo spring; bật = `accent`/gradient.
- **BottomNav**: 5 icon (home/search/reels/message/profile), active = solid + `icon-active`; badge số trên message. Nền `surface` + viền trên `divider`.
- **StoriesRail**: hàng ngang avatar 56px (ring), ô đầu "Your story" (badge `+`), tên 11px dưới.
- **TopBar**: header 52px, `chevronLeft` back trái + tiêu đề Plus Jakarta Sans 17–20px + action phải. (`large` = 20px cho màn Activity/Settings.)
- **Wordmark**: "We36" Plus Jakarta Sans 800, gradient-clipped trên nền sáng / trắng `mono` trên gradient/ink.
- **Toast**: pill `ink`, dot icon tròn 28px màu theo tone (success=mint, error=rose, info=violet, neutral=gray), text trắng 14px, action tuỳ chọn (`rose-300`). KHÔNG dùng SnackBar mặc định.
- **ActionSheet**: bottom sheet radius-top 24, handle 38×4, list row (icon + label 16px), destructive = `error`; nút Cancel rời bên dưới.
- **Dialog**: card 300px radius-20, tiêu đề display 19px + body secondary, 2 nút ngang (secondary + primary; primary `error` khi destructive).
- **Sticker tray**: search + category pills (Recent/Smileys/Love/Gestures/Animals) + grid emoji 5 cột; glyph kích hoạt = mặt cười Lucide-style (`StickerGlyph`).

---

## Screen Specs (31 màn, nhóm A–G) — mỗi màn Light + Dark

> Mã spec dưới gắn với roadmap sẽ build nó (xem `sdd-roadmap.md`). Nguồn chi tiết: `screens/*.jsx`.

### A · Onboarding & Auth — *Spec #003 (nền tảng #001/#002)*
1. **Splash** — nền `gradient-brand`, ô logo blur + icon camera, Wordmark mono 48, "share your world", spinner.
2. **Onboarding** — slide ảnh card lớn (radius-24, shadow-lg) + badge "reels · stories · feed", H2 "Capture every moment" + phụ đề, 3 dot (active = pill gradient), "Skip" + CTA "Get started".
3. **Sign in** — Wordmark + phụ đề; field Email/phone + Password (radius-12, viền), "Forgot password?", CTA "Log in", OrDivider, OAuth row (Google/Apple pill), footer "Create account".
4. **Sign up** — H1 "Create your account"; Email / Phone(optional) / Password (≥8), terms note, CTA "Sign up", OAuth, footer "Log in".
5. **Forgot password** — icon badge `rose-50`, "Reset password", Email field, "Send code"; 4 ô OTP (ô đã nhập viền rose), "Resend code in 0:42".
6. **Profile setup** — avatar 104 + badge camera gradient, "Add a profile photo", Username / Display name / Bio, CTA "Continue".

### B · Feed & Content — *Spec #004 (feed/stories) · #007 (compose) · #006 (post/comments) · #008 (reels)*
7. **Home feed** — header (Wordmark + Activity chuông[dot] + Messages); **StoriesRail**; **PostCard** (xem component). Tab `home`.
8. **Story viewer** — full-bleed ảnh, progress segments trên, avatar+user+time+`x`, protection gradient dưới, "Send message" pill + like + share. Nền đen, edge-to-edge.
9. **Create story** — ảnh full, `x` + tools (camera/plus/more/settings) góc, sticker preview gradient, footer "Your story" / "Close friends" + nút share gradient.
10. **Reels** — video dọc full-bleed, "Reels" + camera header, action rail phải (like solid 24.1k / comment / share / save / more), thông tin tác giả + Follow + caption + hashtag, protection gradient. Tab `reels`.
11. **Create post — pick** (`createpick`) — TopBar "New post" + "Next"; preview vuông + badge "Carousel"; "Recents" + camera/reels; grid 4 cột (ô chọn outline rose + check).
12. **Create post — edit** (`createedit`) — preview vuông (filter live); hàng filter (Original/Warm/Lux/Mono/Fade, active viền rose); slider Brightness/Contrast/Warmth (fill gradient, knob trắng); "Next".
13. **Create post — caption** (`createcaption`) — TopBar "New post" + "Share"; thumb + ô caption (hashtag violet); rows Tag people / Add location / Add music; toggle "Also share to Stories", "Turn off commenting".
14. **Post detail** — TopBar "Post" + `more`; PostCard đầy đủ; "View all N comments".
15. **Comments** — TopBar "Comments"; list comment (avatar + user bold + text + time/likes/Reply + like nhỏ), reply lồng 1 cấp (thụt 40px, avatar 28); hàng emoji nhanh; input (avatar + "Add a comment…" + sticker glyph + "Post").

### C · Explore & Search — *Spec #009*
16. **Explore** — SearchBar (→ search) + tag chips (For you/travel/food/design/fitness); grid khám phá 3 cột (ô [1] span 2×2; ô reels có icon overlay). Tab `explore`.
17. **Search** — back + SearchBar; "Recent" + "Clear all"; rows recent (user avatar / tag glyph / place icon) + `x` mỗi dòng.
18. **Search results** — back + SearchBar(value); tabs Top/Accounts/Tags/Places (active gạch rose); related tag chips; account rows (avatar ring + name + sub + Follow/Following).
19. **Hashtag / location page** — TopBar "Tag" + more; header (badge `#` gradient-soft + "#goldenhour" + "1.2M posts" + Follow); tabs Top/Recent/Reels; grid 3 cột.

### D · Profile — *Spec #010 (profile/follow/edit) · #011 (collections/saved)*
20. **My profile** — header (username display + `+`(create) + settings); avatar 88 ring + stats (posts/followers/following); name + bio + link (violet); "Edit profile" + "Share profile"; ProfileTabs (grid/saved/tagged, active gạch); grid 3 cột. Tab `profile`.
21. **Other profile** — TopBar username + more; avatar + stats; name·category + bio; "Follow" (primary) + "Message" (→ chat) + more; ProfileTabs; grid.
22. **Followers / following** — TopBar username; 2 tab (N followers / N following, active rose); SearchBar; rows (avatar + name + sub + Follow/Following).
23. **Edit profile** — TopBar "Edit profile" + check(rose); avatar + "Change profile photo"; rows Name/Username/Pronouns/Website/Bio; section "Professional" (Category/Contact).
24. **Saved collections** — TopBar "Saved" + `+`; grid 2 cột, mỗi collection = 4 ảnh quilt (radius-16) + tên + "N saved".

### E · Messaging (DM) — *Spec #012*
25. **DM list** — header (back + username + `+`(new message)); SearchBar; active rail (avatar online, ô đầu = your story); rows hội thoại (avatar online + name[bold nếu unread] + preview/typing[mint] + time + unread dot / camera).
26. **Chat (1-1)** — header (back + avatar online + name + "Active now"[mint] + camera/more); bubbles (của mình = gradient-brand phải, người kia = `surface-2` trái, tail bo nhỏ); shared-post card; typing dots; input (camera gradient + "Message…" + sticker glyph + like).
27. **New message** — header (`x` + "New message"); "To:" + search; "Suggested" rows (avatar online + name + sub + radio tròn chọn).
28. **Sticker picker** (chat + tray mở) — như Chat nhưng input sticker active (glyph rose) + **StickerTray** dưới.

### F · Notifications & Settings — *Spec #013 (notifications) · #014 (settings/privacy)*
29. **Notifications (Activity)** — TopBar "Activity" large; section "New" / "This week"; item (avatar + "<b>user</b> action" + time + thumb ảnh hoặc Follow/Following button). Tap → post detail / profile.
30. **Settings** — TopBar "Settings" large; nhóm Account (Edit profile / Notifications / Language) · Who can see (Private account[toggle, tint rose] / Close friends / Activity status[toggle]) · More (Privacy & security / Blocked accounts). Mỗi row = icon-tile + label + value/chevron/Switch.
31. **Privacy & security** — nhóm Privacy (Private account / Comments / Messages / Tags) · Security (Two-factor[mint] / Login activity / Saved login) · Data (Download your data).
32. **Report / block** — header `x` + "Report"; "Why are you reporting this?" + lý do (Spam / Nudity / Hate / Bullying / False info / Scam / Violence / Something else); "Block this account" (error).

### G · System UI & Overlays — *dựng ở #001, dùng xuyên suốt*
- **Toast** (4 tone: success/with-action/info/error) — pill ink. (xem component.)
- **Dialog** (destructive confirm, vd "Delete post?") — card + overlay + dim backdrop.
- **Action sheet** (post options: Save to collection / Share to / Add to story / Turn on notifications / Report[danger] + Cancel).
- **Sticker tray** (emoji/sticker picker).

---

## Responsive — Tablet & iPad (distilled từ `We36 Responsive.html` + `screens/tablet.jsx`)

> App hỗ trợ **iPad + Android tablet** (Constitution VII). Cùng `nav` model + route + design tokens + shared components như mobile — **chỉ khác layout chrome theo bề rộng**. Đây KHÔNG phải app thứ hai; là adaptive shell.

### Breakpoints (theo bề rộng logic của cửa sổ app, không phải device cứng)

| Width | Chế độ | Chrome |
|---|---|---|
| `< 700` | **Phone** | Bottom nav 5 tab (như §Navigation IA). Layout mobile hiện có. |
| `≥ 700` | **Tablet/iPad** | **Left SidebarRail** thay bottom nav + nội dung adaptive. |
| `< 980` (vd iPad **dọc** 834w) | rail **compact** | SidebarRail **icon-only** (width ~84). |
| `≥ 980` (vd iPad **ngang** 1194w) | rail **đầy đủ** | SidebarRail có label (width ~240). |
| `≥ 1100` | + **right rail** | Home hiện thêm cột phải "Suggestions" (width ~340). |

> Device tham chiếu trong mock: Mobile 390×760 · iPad dọc 834×1112 · iPad ngang 1194×834. Dùng `MediaQuery`/`LayoutBuilder` theo **width**, không hardcode model. Phải hỗ trợ **multitasking/split-view** của iPad (app width co lại → tự rớt về phone layout khi `<700`) và xoay ngang/dọc.

### SidebarRail (thay BottomNav trên tablet)

`nav` cột trái, nền `surface`, viền phải `divider`. Trên cùng = **Wordmark**. Mục (pill, active = nền `accent-soft` + icon rose **solid** + label bold):
**Home · Explore · Reels · Messages**(badge unread)**· Notifications · Create(+)**. Dưới cùng = **profile chip** (avatar + username/displayName; ring khi active; ấn → Profile).
- Compact (`<980`): chỉ icon, căn giữa, width ~84, profile = avatar.
- Full (`≥980`): icon + label, width ~240, profile chip có 2 dòng.
- Đây là điểm khác nav duy nhất so với mobile: **Notifications + Create** lên rail (mobile: Activity/Messages ở header Home, Create ngữ cảnh).

### Adaptive layout từng surface

- **PaneHeader**: thay `TopBar` cho vùng nội dung tablet — cao 60, tiêu đề display 22px, back/action tuỳ màn.
- **Home (TabletFeed)**: 1 cột feed **căn giữa** (max ~560) + stories rail dạng **card** bo 20. Nếu `≥1100` → thêm **right rail**: SearchBar + account-switch row + "Suggestions for you" (See all) + footer links (About · Help · Privacy · Terms · © We36).
- **Explore (TabletExplore)**: grid **responsive** `repeat(auto-fill, minmax(200px,1fr))`, tile bo 12, reels marker; tag chips hàng ngang.
- **Messages (TabletMessages) — MASTER/DETAIL split**: cột trái conversation list (~360, item chọn = nền `accent-soft`) + cột phải khung chat đầy đủ. Chọn hội thoại đổi pane phải, **không push màn mới**. (Đây là thắng lợi lớn nhất của tablet.)
- **Post detail (TabletPostDetail) — MASTER/DETAIL split**: pane trái media (nền tối `#0E0E1A`, ảnh `contain`) + pane phải (~400) header tác giả + comments cuộn + action row + ô comment. Story/reel viewer vẫn full-screen.
- **Profile (TabletProfile)**: header **ngang rộng** (avatar 130 + stats + nút Edit/Share hoặc Follow/Message **inline**), nội dung căn giữa max ~900, tabs căn giữa, grid `minmax(180px,1fr)`.
- **Reels (TabletReels)**: KHÔNG full-bleed — **card 9:16 căn giữa** trên nền tối, bo 24 + shadow lớn (như cầm điện thoại giữa màn).
- **Notifications (TabletNotifications)**: list **căn giữa** max ~620 (New / This week).
- **Auth + các màn flow/secondary** (story, create 3 bước, search, results, hashtag, followers, edit profile, collections, new message, sticker, settings, privacy, report, action sheet, dialog): **CenteredMobile fallback** — render đúng khung mobile 390×760 **căn giữa** trong canvas tablet (bo 28 + shadow; nền tối cho story/create/sheet/dialog). Không cần layout tablet riêng cho nhóm này ở v1.0.
- **Toast** trên tablet: width cố định ~380, đặt đáy (offset nhỏ hơn vì không có bottom nav).

### Map sang Flutter (gợi ý, chốt ở #001)

- 1 **AdaptiveShell** quanh `StatefulShellRoute`: `width<700` → `Scaffold` + `BottomNav`; `≥700` → `Row(SidebarRail, Expanded(content))` với rail compact/full theo `≥980`.
- **Master/detail** (Messages, Post detail): widget two-pane tự dựng (hoặc `flutter_adaptive_scaffold`) — khi tablet thì list+detail cạnh nhau, khi phone thì điều hướng push như cũ. Cùng Cubit, chỉ khác cách hiển thị.
- Nội dung căn giữa qua `ConstrainedBox(maxWidth)` (feed 560 / profile 900 / notif 620); grid qua `SliverGridDelegateWithMaxCrossAxisExtent` (~200px).
- Right rail Home chỉ build khi `≥1100`.
- Nhóm flow/secondary: ở v1.0 dùng **centered constrained mobile layout** (đỡ phải thiết kế lại) — tinh chỉnh dần sau.

---

## Implementation Rules (UI)

- **Fixed palette** — chỉ Light/Dark + follow-system (Spec #014). **Không** scheme picker.
- Dùng **semantic token names** (`accent`, `surface`, `text-secondary`…) — không hardcode hex trong widget.
- **"Color earns its place"** — chrome/feed neutral; brand color chỉ ở CTA / story ring chưa xem / nav active / badge / sticker. Gradient KHÔNG làm nền cả trang.
- Media `object-fit: cover`, post 4:5, grid vuông; ảnh remote qua `cached_network_image` + `cacheWidth` (Constitution II).
- Số liệu viết tắt (`38.4k`) + thời gian tương đối (`2h`) qua shared formatter (Constitution XIV).
- Bottom nav chỉ hiện ở 5 tab; flow screens + auth ẩn nav.
- **Responsive**: `<700` = phone (bottom nav); `≥700` = tablet/iPad (SidebarRail + adaptive). Master/detail cho Messages + Post detail; centered-mobile fallback cho màn flow/auth. Layout theo **width** (`MediaQuery`/`LayoutBuilder`), hỗ trợ iPad split-view + xoay. Cùng nav model/route/tokens/components — chỉ khác chrome (xem §Responsive — Tablet & iPad).
- Press = scale-down; Reduce-Motion = tĩnh; KHÔNG vòng lặp trang trí vô hạn.
- Story ring chưa xem = `gradient-story`; đã xem = viền gray phẳng.
- Tái dựng component dùng lại (PostCard, Avatar, Tag, BottomNav, Toast, ActionSheet, Dialog…) thành shared widgets ở **#001**, không lặp markup mỗi feature.
- UI/UX gốc của We36 — pull từ claude_design, **không** sao chép app khác (Instagram chỉ là tham chiếu chức năng).
