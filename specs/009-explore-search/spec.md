# Feature Specification: Explore & Search

**Feature Branch**: `009-explore-search`

**Created**: 2026-07-03

**Status**: Draft

**Input**: User description: "Build #009 Explore & Search for the We36 Flutter client — the content-discovery surface (Explore grid + full-text search for accounts/hashtags/places + tappable hashtag/place pages + recent-search history) over the already-shipped backend B#009, reusing the #004 Post and #008 Reel models. MVP: non-personalized, no recommendation engine; all discovery respects server-side visibility/block rules."

## Clarifications

### Session 2026-07-03

- Q: When does a search fire (invocation model + minimum length)? → A: **Live as-you-type**, debounced (~300 ms), fires at **≥2 characters**; pressing Enter also submits the term (and records a recent). Below 2 characters, results are not requested and recents remain shown.
- Q: Is the Explore grid cached on-device (survives restart) or session-only for offline? → A: **Persist on-device** (like the #004 feed) — Explore opens to cached tiles on a cold offline start; a background refresh reconciles. Search results and hashtag/place grids remain live-query (no cold-start cache).

## User Scenarios & Testing *(mandatory)*

Explore & Search is the app's **discovery** surface: the fourth tab entry point where a person browses content they don't already follow and searches for a specific person, topic, or place. It sits on top of the shipped backend discovery contract (B#009) and reuses the feed/reel content models. It is **non-personalized** (no recommendation or ranking) and the backend already enforces every visibility and block rule — the client only renders what the API returns.

### User Story 1 - Search for accounts, hashtags, and places (Priority: P1)

A signed-in person types a term into the search field and gets back matching **accounts, hashtags, and places** so they can jump to a profile, a hashtag feed, or a place feed. A default **Top** view blends a few of each; they can narrow to a single result type via **Accounts / Tags / Places** tabs. Results never expose content or relationships the person isn't allowed to see.

**Why this priority**: Search is the primary, highest-value way a person finds a specific person, topic, or place. It is the most-used entry point of the discovery surface and is independently shippable without the Explore grid.

**Independent Test**: With the search source seeded (public + private accounts, hashtags, places), open Search, type terms, switch tabs; verify each type matches, blocked users never appear, private accounts are findable by handle while their content stays gated, each account row shows the viewer's relationship state, and tapping a result navigates to the correct destination.

**Acceptance Scenarios**:

1. **Given** a public account "alice_travel" exists, **When** the person searches "alice" on the **Accounts** tab, **Then** alice appears with her relationship state (Follow/Following label) and the list paginates as they scroll.
2. **Given** the term "sunset" matches hashtags and places, **When** the person is on the **Tags** tab, **Then** only hashtag results (each with its post count) are shown; **and When** they switch to **Places**, **Then** only place results are shown.
3. **Given** any term, **When** the person is on the **Top** tab, **Then** a small blended set of a few accounts, tags, and places is shown as a fixed snapshot (no infinite scroll), each type section offering a "see more" that switches to that single-type tab.
4. **Given** a private account "bob_private", **When** the person (not an approved follower) searches "bob_private", **Then** bob is returned as a discoverable account, but none of his gated content is exposed by search.
5. **Given** the person and "carol" have a block between them (either direction), **When** the person searches for carol by any term, **Then** carol never appears in results.
6. **Given** a search result, **When** the person taps an account row → their profile opens; a tag row → its hashtag page; a place row → its place page.
7. **Given** a term returns nothing on the active tab, **When** the request completes, **Then** an explicit empty state is shown (not a spinner or a blank screen).

---

### User Story 2 - Explore discovery grid (Priority: P2)

A signed-in person opens the **Explore** tab and browses a grid of content they don't already follow — a mix of photo posts and reels — to discover something new, and taps any tile to open it. A row of **category shortcut chips** (e.g. travel, food, design, fitness) lets them jump straight to a topic's hashtag page.

**Why this priority**: Explore is the passive-discovery counterpart to active search — valuable but secondary to letting a person find what they're specifically looking for. It is independently shippable on top of the same content models.

**Independent Test**: With the explore source seeded, open the Explore tab; verify the grid renders a mix of post and reel tiles (reels visibly marked), scrolls to load more, pull-to-refresh works, tapping a tile opens the item, and tapping a category chip opens the matching hashtag page. Confirm empty/loading/error-retry/offline-from-cache states.

**Acceptance Scenarios**:

1. **Given** the explore source has content, **When** the person opens the Explore tab, **Then** a grid of mixed post/reel tiles renders, with reel tiles carrying a reels marker, and a hero tile emphasized in the quilted layout.
2. **Given** the person scrolls to near the end of the grid, **When** more content is available, **Then** the next page loads and appends without a jump or duplicate.
3. **Given** the person pulls to refresh, **When** the refresh completes, **Then** the grid reflects the latest discovery content and any items that are gone drop out.
4. **Given** the category chip "travel", **When** the person taps it, **Then** the "#travel" hashtag page opens.
5. **Given** the discovery source is unreachable and a cached grid exists, **When** the person opens Explore, **Then** the cached grid is shown with an unobtrusive offline indication; **and When** no cache exists, **Then** an error state with retry is shown.

---

### User Story 3 - Recent searches (Priority: P3)

A signed-in person opens Search and sees their **recent searches** so they can quickly return to a person, topic, or place they looked at before. Repeated entries are promoted to the top rather than duplicated, and they can remove one row or clear the whole list.

**Why this priority**: Recents is a convenience that accelerates repeat search but is not required for search itself to deliver value. It layers cleanly on top of US1.

**Independent Test**: With the recents source seeded, open Search with an empty field; verify recent rows render (account avatar / tag glyph / place icon), that tapping a result or submitting a term records it (promoted to top, never duplicated), that the per-row delete removes one entry, and that "Clear all" empties the list.

**Acceptance Scenarios**:

1. **Given** the search field is empty, **When** the person opens Search, **Then** their recent searches are listed newest-first, each row typed by kind (account / hashtag / place / free-text term).
2. **Given** the person taps a search result or submits a free-text term, **When** the action completes, **Then** that entry is recorded at the top of recents; **and Given** it already existed, **Then** it is moved to the top without creating a duplicate.
3. **Given** a recent row, **When** the person taps its delete control, **Then** that entry is removed and the rest remain in order.
4. **Given** recents exist, **When** the person taps "Clear all", **Then** the list is emptied.
5. **Given** recents are empty, **When** the person opens Search, **Then** an empty-recents state is shown.

---

### User Story 4 - Hashtag & place pages (Priority: P3)

A signed-in person opens a **hashtag** or **place** page (from a search result, a category chip, or a tapped tag/location elsewhere) and sees a header with the topic's identity and a grid of the visible content for it, so they can explore everything under that tag or location.

**Why this priority**: Hashtag/place pages are the destination that gives search and the category chips their payoff, but they depend on those entry points and so land after them.

**Independent Test**: Open a hashtag page and a place page directly; verify the header (hashtag + post count, or place name + details), a cursor-paginated grid of permitted posts+reels (reels marked), that the grid loads more and shows empty/loading/error states, and that the header's "Follow" control is a surface-only stub that acknowledges via a toast.

**Acceptance Scenarios**:

1. **Given** a hashtag "#goldenhour", **When** the person opens its page, **Then** the header shows the tag and its total post count and a grid of permitted posts+reels renders.
2. **Given** a place, **When** the person opens its page, **Then** the header shows the place name/details and a grid of the content visible to the viewer renders.
3. **Given** either page, **When** the person scrolls to the end, **Then** the next page appends; **and When** there is no content, **Then** an explicit empty state is shown.
4. **Given** the header "Follow" control, **When** the person taps it, **Then** a toast acknowledges it ("coming soon") and no follow relationship is created (deferred to a later spec).

---

### User Story 5 - Inclusive & adaptive discovery (Priority: P4)

Any person, on any supported device, gets an inclusive, adaptive discovery experience: all messages are toasts; empty / loading / error-with-retry / offline-from-cache states are explicit; the interface supports larger text, works in light and dark, is screen-reader labeled, and adapts its layout between phone and tablet/iPad.

**Why this priority**: A cross-cutting quality bar that hardens US1–US4 for release; it assumes the earlier stories exist to harden.

**Independent Test**: Across Explore, Search, Results, and the hashtag/place pages, verify screen-reader labels on tiles/rows/controls, correct rendering at large text scale in light and dark, that all feedback appears as toasts, and that the grids reflow to a wider layout at tablet width.

**Acceptance Scenarios**:

1. **Given** a screen reader, **When** the person traverses a grid tile / account row / recent row, **Then** each announces meaningful content and its type (e.g. reel vs photo).
2. **Given** a large system text scale, **When** any discovery screen is shown, **Then** text scales without clipping or overflow.
3. **Given** tablet/iPad width, **When** the person views Explore or a hashtag/place page, **Then** the grid reflows to more columns (responsive) rather than stretching the phone layout; the results tabs remain usable.
4. **Given** any recoverable error, **When** it occurs, **Then** it is surfaced as a toast and (for a whole-screen failure) an inline retry.

### Edge Cases

- **Empty query**: opening Search with no term shows recents (not results); an all-whitespace query is treated as empty.
- **No results on a tab**: each tab (Top/Accounts/Tags/Places) shows its own empty state independently — e.g. accounts match but places don't.
- **Rapidly changing query**: typing quickly must not show stale results for a previous term (the latest term wins); superseded in-flight requests are ignored.
- **Blocked / private mid-session**: a result that becomes blocked or a page that becomes unavailable surfaces as an empty/error state, never as a crash or leaked content.
- **Deep-link to a hashtag/place**: opening a hashtag or place page directly (not via search) works and does not require a prior search.
- **Offline**: Explore falls back to its persisted on-device grid (with an offline indication) even on a cold start; Search/Results and hashtag/place pages are live-query and show an offline/error-retry state instead.
- **Recents referencing removed entities**: a recent row whose account/hashtag/place no longer exists degrades gracefully (navigates to an empty/error destination or is skipped), never crashes.
- **Duplicate recent**: submitting the same term or tapping the same result promotes the existing entry instead of adding a duplicate.
- **Reel vs post tile**: a reel tile is visually distinguishable from a photo tile in every grid (explore, hashtag, place).

## Requirements *(mandatory)*

### Functional Requirements

**Search (US1)**

- **FR-001**: The system MUST let a person search by free-text term and return matching accounts, hashtags, and places. Search executes **live as-you-type** (debounced ~300 ms) once the term reaches **≥2 characters**; pressing Enter also submits the term. Below 2 characters, no query is issued and recents remain shown.
- **FR-002**: The system MUST present results under four views — **Top**, **Accounts**, **Tags**, **Places** — with the active view visually indicated.
- **FR-003**: The **Top** view MUST be a fixed small blended snapshot (a few of each type, not paginated); each type section MUST offer a "see more" affordance that switches to the corresponding single-type view.
- **FR-004**: Each single-type view (Accounts/Tags/Places) MUST load additional results on demand as the person scrolls (cursor pagination).
- **FR-005**: Account matching MUST behave as autocomplete-style prefix + substring matching on username and display name, insensitive to letter case and accents.
- **FR-006**: Each account result MUST display the viewer's relationship state (e.g. Follow / Following) as a **read-only** indicator; the system MUST NOT perform a follow/unfollow action from Search results (that action is out of scope — see #010).
- **FR-007**: Each hashtag result MUST display its post count; each place result MUST display enough identity (name and any available detail) to disambiguate it.
- **FR-008**: Tapping an account result MUST open that profile; tapping a hashtag result MUST open its hashtag page; tapping a place result MUST open its place page.
- **FR-009**: The system MUST NOT show any account the viewer has blocked or been blocked by, in either direction.
- **FR-010**: The system MUST allow a private account to be found by handle, while never exposing that account's gated content through search.
- **FR-011**: When the query changes, the system MUST show results for the latest term only and ignore superseded in-flight requests.

**Explore grid (US2)**

- **FR-012**: The system MUST present a non-personalized discovery grid of content the person does not necessarily follow, where each item is either a photo post or a reel.
- **FR-013**: Reel items in any grid MUST be visually marked as reels, distinct from photo posts.
- **FR-014**: The Explore grid MUST use a quilted layout with an emphasized hero tile and MUST load additional content as the person scrolls (cursor pagination).
- **FR-015**: The Explore surface MUST offer a row of static category shortcut chips that deep-link to their corresponding hashtag pages; it MUST NOT present a personalized ("For you") category.
- **FR-016**: The Explore grid MUST support pull-to-refresh, replacing the shown content with the latest and dropping items that are gone.
- **FR-017**: Tapping any grid tile MUST open the corresponding item (post or reel).

**Recent searches (US3)**

- **FR-018**: When Search is opened with an empty query, the system MUST show the person's recent searches, newest first, each typed by kind (account / hashtag / place / free-text term).
- **FR-019**: The system MUST record a recent entry when the person taps a result (account/hashtag/place) or submits a free-text term.
- **FR-020**: Recording a recent entry MUST de-duplicate and promote: a repeated entry moves to the top and is never stored twice.
- **FR-021**: The system MUST let the person remove a single recent entry and clear all recent entries.

**Hashtag / place pages (US4)**

- **FR-022**: A hashtag page MUST show a header (the tag and its total post count) and a single cursor-paginated grid of the posts+reels visible to the viewer for that tag.
- **FR-023**: A place page MUST show a header (the place name and any available detail) and a single cursor-paginated grid of the content visible to the viewer for that place.
- **FR-024**: The hashtag/place page header MUST include a **surface-only** "Follow" control that only acknowledges via a toast; the system MUST NOT create a real follow-tag relationship (deferred to a later backend spec).
- **FR-025**: A hashtag or place page MUST be openable directly (deep-link) without requiring a prior search.

**Cross-cutting (US5 + all)**

- **FR-026**: The system MUST render only the content and relationships the backend returns as visible; it MUST NOT attempt to compute or bypass visibility/block rules client-side.
- **FR-027**: Every discovery surface MUST show explicit empty, loading, and error-with-retry states. The Explore grid MUST additionally be **persisted on-device** (like the #004 feed) so it opens to cached tiles — with an offline indication — on a cold start while the source is unreachable, reconciling via a background refresh. Search results and hashtag/place pages are live-query surfaces (they show an offline/error-retry state rather than a cold-start cache).
- **FR-028**: All user-facing messages MUST be shown as toasts (never a system snackbar).
- **FR-029**: Every discovery data source MUST have an in-memory fake so the app builds and runs without a live backend.
- **FR-030**: The system MUST be usable with a screen reader (meaningful labels on grid tiles, result rows, recent rows, tabs, and controls), support enlarged text, and render correctly in light and dark themes.
- **FR-031**: The system MUST adapt its layout between phone and tablet/iPad widths — a denser responsive grid at tablet width rather than a stretched phone layout — using the same routes and design tokens.
- **FR-032**: All discovery UI copy MUST be provided in English (primary) and Vietnamese.

### Key Entities *(include if feature involves data)*

- **Explore item**: one discovery-grid entry — either a photo post or a reel (reusing the existing feed post / reel content models); carries enough to render a tile (media thumbnail, a reel marker when applicable) and open the full item. The Explore grid is persisted on-device as the canonical cached copy so it survives restart offline.
- **Search result set**: the response to a query, organized by type — a blended **Top** snapshot plus paginated **accounts**, **hashtags**, and **places** lists.
- **Account result**: a discoverable account (avatar, username, display name, verified flag) with the viewer's read-only relationship state.
- **Hashtag**: a tag identity (name) with a total post count and, on its page, a grid of visible content.
- **Place**: a location identity (name and available details) with, on its page, a grid of visible content.
- **Recent search entry**: a previously used search — a free-text term or a tapped account/hashtag/place — with a type and an ordering position (most-recent first, unique per entry).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A person can find a specific known account, hashtag, or place and open it in **3 taps or fewer** from the discovery tab (open search → pick result → land).
- **SC-002**: Search results for a typed term appear within **1 second** under normal conditions, and switching between the Top/Accounts/Tags/Places tabs shows the correct result type every time.
- **SC-003**: In **100%** of cases, blocked accounts (either direction) never appear in any discovery surface, and no gated content of a private account is exposed through search.
- **SC-004**: The Explore grid, hashtag page, and place page each scroll through **at least 5 pages** of content without duplicated tiles, dropped tiles, or a memory-driven slowdown.
- **SC-005**: A repeated search (same term or same tapped result) results in exactly **one** recent entry, promoted to the top — never a duplicate.
- **SC-006**: Every recoverable failure across the discovery surfaces is communicated to the person (toast and/or inline retry) rather than a blank screen or crash, in **100%** of tested error paths.
- **SC-007**: Every discovery screen passes the project's accessibility, large-text, light/dark, and phone-vs-tablet adaptive checks with automated coverage green.
- **SC-008**: The entire feature builds and its automated tests run with **zero network access** (every source has a working fake).

## Assumptions

- **Backend contract is fixed and shipped**: the client consumes the existing B#009 discovery endpoints (explore grid, search by type with the Top blended snapshot, hashtag page, place page, recent-search history). No backend changes are in scope.
- **Server-side authority**: all visibility, block, and privacy filtering is performed by the backend; the client renders exactly what is returned and never re-derives these rules.
- **Non-personalized MVP**: Explore is a simple, non-personalized grid; there is no recommendation engine, ranking, or "For you" personalization in this feature.
- **Content models reused**: discovery tiles reuse the existing feed post (#004) and reel (#008) representations and the shared cursor-pagination controller; no new canonical content model is introduced.
- **Follow is display-only here**: account results and hashtag/place pages show relationship state or a stub follow control, but the actual follow/unfollow action (accounts) and real follow-hashtag (topics) are **out of scope** — accounts land in #010, follow-hashtag in a future backend spec.
- **Category chips are static**: the Explore category shortcut chips are a fixed client-side set that deep-link to hashtag pages; they are not driven by a backend category/personalization source.
- **Recents semantics**: recent-search history is dedupe-and-promote and is recorded on tapping a result or submitting a free-text term (matching the backend behavior).
- **Authenticated context**: the person is signed in (discovery sits behind the auth gate from #003); an unauthenticated person never reaches these screens.
- **Navigation targets may be partial**: tapping an account result opens the profile surface; where the full profile feature (#010) is not yet built, the destination is the available profile placeholder — this feature owns only the discovery surfaces and their navigation intents, not the destinations it hands off to.
