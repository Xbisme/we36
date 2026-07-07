# Feature Specification: Saved Collections

**Feature Branch**: `011-collections`

**Created**: 2026-07-07

**Status**: Draft

**Input**: User description: "Build #011 Saved Collections for the We36 Flutter client — the surface that organizes a person's saved posts into named collections, over the already-shipped backend B#011, reusing shipped seams: the optimistic save toggle (Post.viewerHasSaved/saveCount, save(postId,{save}) — #004/#006), the feed Post + grid tile (#004), the profile tab bar (#010, currently Posts/Tagged — this spec adds the Saved tab), and the PaginatedListCubit/CursorPage + drift cache base (#002). US1 Saved tab + collections grid; US2 save a post into a collection; US3 open & curate a collection; US4 manage a collection; US5 inclusive & adaptive. Out of scope: collaborative/shared collections, per-collection privacy, reordering within a collection, saving non-post/reel content, other users' Saved tab."

## Clarifications

### Session 2026-07-07

- Q: When the person taps the default Save (bookmark) action on a post/reel, what happens? → A: **Silent save to "All saved"** — the plain bookmark saves optimistically with no prompt; filing into a named collection is the separate, explicit **"Save to collection"** action (long-press / action sheet).
- Q: Must a collection name be unique per owner? → A: **No** — names need not be unique (collections are distinguished by id); create/rename does not reject a duplicate name.
- Q: When fully unsaving an item that belongs to ≥1 named collection (losing its membership everywhere), is a confirmation required? → A: **Confirm only when it is in ≥1 named collection** (guards against accidental membership loss); an item that is only in "All saved" unsaves silently/optimistically.

## User Scenarios & Testing *(mandatory)*

Saved Collections is the **personal organization** surface: the place where a signed-in person's already-saved posts and reels are grouped into named collections they control. It hangs off the **Saved** tab on their own profile (added here; #010 shipped only Posts/Tagged) and off the existing **save** action anywhere a post appears (feed, post detail, reels). Saving is already a shipped, optimistic, idempotent toggle on the canonical `Post` (#004/#006); this feature adds the layer that files saved items into collections and lets a person browse, curate, and manage them. Saved content is **private to the owner** — it is never exposed on another person's profile. The client renders exactly what the backend (B#011) returns and enforces no rule the backend hasn't.

### User Story 1 - See my Saved tab and collections grid (Priority: P1)

A signed-in person opens the **Saved** tab on their own profile and lands on the **Saved** screen: a header titled "Saved" with a create (`+`) action and a 2-column grid of their collections, where each collection card shows a 4-image quilt cover, its name, and an "N saved" count. A default **"All saved"** collection is always present and lists every post/reel they have saved, regardless of any named collection.

**Why this priority**: The Saved surface is the anchor of the feature and the entry point every other story extends. It is independently valuable — a person can review everything they've saved in one place — and requires only the shipped save state to populate, so it is the minimum shippable slice.

**Independent Test**: With the current user's saved posts and some collections seeded, open the Saved tab from the profile; verify the header + create action render, that a 2-column grid of collection cards shows each collection's quilt cover / name / count, that a persistent "All saved" collection lists every saved item, and that empty (no collections yet → only "All saved"), loading, error-with-retry, and offline-from-cache states render correctly.

**Acceptance Scenarios**:

1. **Given** the signed-in person has saved posts and named collections, **When** they open the Saved tab, **Then** a "Saved" header with a create action and a 2-column grid of collection cards (cover + name + "N saved") render, with "All saved" always present.
2. **Given** the person has saved posts but created no named collection, **When** the Saved screen renders, **Then** only the "All saved" collection appears (no empty-grid dead end).
3. **Given** the person has saved nothing at all, **When** the Saved screen renders, **Then** an explicit empty state explains how saving works.
4. **Given** the Saved data is cached and the network is unreachable, **When** the person opens Saved, **Then** the cached collections render with an unobtrusive offline indication; **and Given** no cache exists, **Then** an error state with retry is shown.

---

### User Story 2 - Save a post into a collection (Priority: P1)

A signed-in person saves a post or reel (via the existing bookmark action or the post action-sheet "Save to collection") and files it into a collection — choosing an existing one or creating a new named collection inline. The saved item always appears in "All saved" and in every collection it is filed under. The action is optimistic and idempotent.

**Why this priority**: Filing a saved item into a collection is the core write path of the feature — without it the collections grid (US1) has no way to gain content beyond the default. It builds directly on the shipped optimistic save toggle and is independently shippable on top of US1.

**Independent Test**: With a post visible in the feed/detail, tap Save (or "Save to collection"); verify the item is saved optimistically (the canonical `Post.viewerHasSaved` flips instantly and the count updates), that a picker lets the person choose an existing collection or create a new one, that the item then appears in "All saved" and the chosen collection, that a failed request rolls back with a toast, and that a retried save produces no duplicate.

**Acceptance Scenarios**:

1. **Given** an unsaved post, **When** the person taps the default Save (bookmark), **Then** the post is saved optimistically (`viewerHasSaved` true, count updated) **silently into "All saved"** with no collection prompt.
2. **Given** the person opens the explicit "Save to collection" action, **When** they pick an existing collection or create a new one and confirm, **Then** the post is filed into that collection and shows in it (and still in "All saved").
3. **Given** a save/file request fails, **When** the failure returns, **Then** the optimistic change rolls back and a toast explains it.
4. **Given** a transient failure causes a retry, **When** the save is retried, **Then** exactly one saved relationship / collection membership results (idempotent — no duplicate).
5. **Given** the person creates a new collection inline, **When** they enter a name and confirm, **Then** the new collection is created and the post is filed into it in one flow.

---

### User Story 3 - Open and curate a collection (Priority: P2)

A signed-in person opens a collection and browses its saved posts and reels in a grid, then curates it by removing an item from the collection. Unsaving a post entirely removes it from every collection and from "All saved".

**Why this priority**: Browsing and pruning a collection is what makes the organization useful over time, but it layers on top of a populated collection (US1/US2). It is a natural second slice.

**Independent Test**: With a collection of saved items seeded, open it; verify a cursor-paginated grid of its posts and reels renders (reels marked), that the grid appends the next page without duplicates on scroll, that tapping a tile opens post detail (#006), that removing an item from the collection drops it from that collection's grid (but keeps it in "All saved"), and that fully unsaving an item removes it from all collections and "All saved".

**Acceptance Scenarios**:

1. **Given** a collection with saved items, **When** the person opens it, **Then** a grid of its posts and reels renders (reels carry a marker) and paginates on scroll without duplicates.
2. **Given** an item in a collection, **When** the person taps it, **Then** the post detail (#006) opens.
3. **Given** an item in a named collection, **When** the person removes it from that collection, **Then** it disappears from that collection's grid but remains in "All saved" and any other collection it belongs to.
4. **Given** a saved item that belongs to ≥1 named collection, **When** the person fully unsaves it, **Then** a confirmation is shown first, and on confirm it is removed from every collection and from "All saved" and the canonical `Post.viewerHasSaved` flips to false everywhere; **and Given** an item only in "All saved", **When** they unsave it, **Then** it unsaves silently/optimistically with no confirmation.
5. **Given** a collection with no items, **When** it is opened, **Then** an explicit empty state renders.

---

### User Story 4 - Manage a collection (Priority: P2)

A signed-in person manages a collection: renaming it, deleting it (with confirmation), and setting which saved item is its cover — all via an action sheet. Deleting a collection does not unsave its posts; they remain in "All saved".

**Why this priority**: Management rounds out ownership of the surface but is not required to derive value from saving and browsing (US1–US3), so it is a P2 refinement.

**Independent Test**: With a named collection seeded, open its management action sheet; verify rename applies and persists, that delete prompts for confirmation and then removes the collection while its posts remain in "All saved", that setting a cover updates the collection card's quilt/cover, and that the default "All saved" collection cannot be renamed or deleted.

**Acceptance Scenarios**:

1. **Given** a named collection, **When** the person renames it and confirms, **Then** the new name shows on its card and screen.
2. **Given** a named collection, **When** the person deletes it and confirms, **Then** the collection is removed but every post it contained stays saved and visible in "All saved".
3. **Given** a delete request, **When** the person is asked to confirm, **Then** the deletion only proceeds on confirmation (guards against accidental loss).
4. **Given** a collection, **When** the person sets its cover to a chosen saved item, **Then** the card reflects the new cover.
5. **Given** the default "All saved" collection, **When** the person opens management, **Then** rename and delete are unavailable (it is system-managed).

---

### User Story 5 - Inclusive and adaptive (Priority: P2)

Every Saved surface is usable with a screen reader, honors large text, renders correctly in light and dark, and reflows across phone and tablet widths.

**Why this priority**: Accessibility and adaptivity are non-negotiable per the constitution and must ship with the feature, but they harden the US1–US4 surfaces rather than adding a new user-facing capability.

**Independent Test**: With a screen reader active, verify collection cards, grid tiles, and every action (create / save-to-collection / remove / rename / delete / set-cover) expose meaningful labels and selected state; verify large-text scaling does not clip cards or counts; verify light and dark render correctly; verify the Saved screen and collection grids reflow between phone and tablet widths.

**Acceptance Scenarios**:

1. **Given** a screen reader, **When** the person navigates the Saved screen, **Then** each collection card and action announces a meaningful label and role.
2. **Given** the largest supported text size, **When** any Saved surface renders, **Then** names, counts, and controls remain legible and untruncated.
3. **Given** light and dark themes, **When** any Saved surface renders, **Then** it matches the design tokens in both.
4. **Given** a tablet width, **When** the Saved screen renders, **Then** it reflows per the responsive rules (Screen 24 uses the centered-mobile fallback — no dedicated tablet layout in v1.0).

---

### Edge Cases

- **A post is deleted or becomes unavailable** while it is in a collection → the collection grid skips the missing item gracefully (no blank tile), and counts reconcile on refresh.
- **A saved item is in multiple collections** → removing it from one collection leaves it in the others and in "All saved"; only a full unsave removes it everywhere.
- **Duplicate collection name** → allowed; names need not be unique per owner (collections are distinguished by id), so create/rename never rejects a matching name.
- **Very long collection name** → names are length-capped and truncated with an accessible full-name label.
- **A collection cover item is removed/unsaved** → the cover falls back to the next available saved item (or an empty-cover placeholder when the collection is empty).
- **Concurrent edits across surfaces** → saving/unsaving from the feed, post detail, or reels stays consistent with the Saved surface because save-state is the one canonical `Post.viewerHasSaved` (no divergent copy).
- **Offline curate** → save/file/remove/rename/delete attempted with no network roll back with a toast; nothing is partially applied.
- **Logout** → saved/collection state does not leak to the next account on the device.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST add a **Saved** tab to the signed-in person's own profile that opens the Saved screen; Saved is **private to the owner** and MUST NOT appear on any other person's profile.
- **FR-002**: The Saved screen MUST show a header titled "Saved" with a **create-collection** action and a **2-column grid** of the person's collections, each card showing a multi-image quilt cover, the collection name, and an "N saved" count.
- **FR-003**: The system MUST always present a default **"All saved"** collection that lists every post/reel the person has saved, independent of named collections; it MUST NOT be renamable or deletable.
- **FR-004**: Users MUST be able to **save** a post or reel via the existing bookmark action; the plain bookmark MUST save **silently into "All saved"** (no collection prompt), updating the one canonical saved state (`Post.viewerHasSaved` + count) optimistically with rollback on failure. Filing into a named collection is the separate **"Save to collection"** action (FR-005), not the default tap.
- **FR-005**: Users MUST be able to **file a saved item into a collection** via an explicit "Save to collection" action, choosing an existing collection or **creating a new named collection inline** in the same flow; a saved item MUST appear in "All saved" and in every collection it is filed under. Collection **names need not be unique** per owner — create/rename MUST NOT reject a name that matches an existing collection (collections are distinguished by id).
- **FR-006**: All save / file / remove / create / rename / delete mutations MUST be **idempotent** (a retried request produces exactly one resulting state — no duplicate saves or memberships).
- **FR-007**: Users MUST be able to **open a collection** and browse its saved posts/reels in a **cursor-paginated grid** (reels marked), appending the next page on scroll without duplicates.
- **FR-008**: Users MUST be able to **remove an item from a collection** (no confirmation); removal MUST keep the item in "All saved" and any other collection it belongs to. **Fully unsaving** an item MUST remove it from every collection and from "All saved" and flip the canonical saved state to false everywhere it is shown; when the item belongs to **≥1 named collection** the full unsave MUST require a **confirmation** first (guarding against accidental membership loss), while an item only in "All saved" unsaves silently/optimistically.
- **FR-009**: Users MUST be able to **rename** and **delete** a named collection (delete behind a confirmation); deleting a collection MUST NOT unsave its posts (they remain in "All saved").
- **FR-010**: Users MUST be able to **set a collection's cover**; when a cover item is removed/unsaved the cover MUST fall back to another saved item or an empty placeholder.
- **FR-011**: Tapping a saved tile MUST open the **post detail** surface (#006).
- **FR-012**: The system MUST render **empty, loading, error-with-retry, and offline-from-cache** states on the Saved screen and every collection grid.
- **FR-013**: The Saved surfaces MUST be **accessible** (screen-reader labels + selected state on cards, tiles, and actions), honor **large text**, render in **light and dark**, and **reflow across phone and tablet** widths (Screen 24 uses the centered-mobile fallback).
- **FR-014**: The client MUST enforce **no visibility rule the backend has not** — it renders what B#011 returns; saved content is never shown for a profile other than the owner's.
- **FR-015**: Saved/collection state MUST NOT leak across accounts — it is cleared on **logout**.
- **FR-016**: The system MUST keep **one canonical cached representation** of saved state and collection membership (no per-screen copy that can drift).

### Key Entities *(include if feature involves data)*

- **Collection**: a named, owner-private grouping of saved items. Attributes: id, name, saved-item count, cover reference, created/updated time, and a flag distinguishing the system-managed default ("All saved") from user collections. Belongs to exactly one owner (the current user in v1.0).
- **Saved item (collection membership)**: the relationship between a saved post/reel and a collection — an item may belong to "All saved" plus zero or more named collections. Keyed by the post/reel id; carries the reference used to render its grid tile.
- **Post / Reel (existing)**: the shipped canonical `Post` (#004, `viewerHasSaved`/`saveCount`) that a saved item points at; this feature adds no new copy of it and reuses the feed grid tile for rendering.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A person can save a post and file it into a new collection in **under 15 seconds** from the post, in one uninterrupted flow.
- **SC-002**: 100% of saved posts appear in **"All saved"** immediately after saving, with no manual refresh.
- **SC-003**: Saving, filing, removing, renaming, and deleting all reflect **optimistically (perceived instant)**, and any server failure visibly rolls back with a message — a person never sees a "stuck" intermediate state.
- **SC-004**: A retried mutation (save / file / remove / create / rename / delete) never produces a **duplicate** saved item, membership, or collection.
- **SC-005**: Removing an item from one collection leaves it present in **"All saved" and every other collection** it belongs to in **100%** of cases; a full unsave removes it from **all** of them.
- **SC-006**: Deleting a collection leaves **100%** of its posts still saved and visible in "All saved".
- **SC-007**: Save-state stays **consistent across surfaces** — saving/unsaving from feed, post detail, or reels is reflected on the Saved surface (and vice-versa) with no divergence.
- **SC-008**: Every Saved surface passes a screen-reader label audit, remains legible at the largest supported text size, and renders correctly in light and dark and across phone/tablet widths.

## Assumptions

- **Backend B#011 is shipped** and contract-driven (matching #009/#010): the real repository can land alongside an in-memory fake, and the app still runs the fake DI environment for hermetic tests. Exact endpoint shapes are pinned at `/speckit.plan`.
- **Saving already exists** (#004/#006) as an optimistic, idempotent toggle on the canonical `Post`; this feature reuses it and adds the collection layer — it does not reimplement saving.
- **"All saved" is a system-managed default** collection (implicit view of all saved items), always present, not renamable/deletable. Whether the backend models it as a real collection or a virtual view is an implementation detail resolved at planning.
- **Collection names need not be unique** per owner (Instagram-like); create/rename never rejects a duplicate name (clarified 2026-07-07).
- **Collection names** are length-capped at **50 characters** (truncated with an accessible full-name label); non-empty required on create/rename.
- **The default Save (bookmark) tap saves silently to "All saved"** (clarified 2026-07-07); filing into a named collection is the explicit "Save to collection" action.
- **Full unsave requires confirmation only when the item is in ≥1 named collection** (clarified 2026-07-07); an item only in "All saved" unsaves silently.
- **Collection covers** default to a recent-saved-items quilt unless the owner sets an explicit cover.
- **Saved is private to the owner** — v1.0 has no shared/collaborative collections and no per-collection privacy toggle (a collection is only ever visible to its owner).
- **Only posts and reels are savable** in v1.0 (no saving of stories, comments, profiles, or hashtags).
- **Reordering** items within a collection is out of scope for v1.0 (default order is backend-provided, newest-first).
- **Screen 24** (Saved collections) uses the responsive **centered-mobile fallback** per `ui-design-context.md` §Responsive — no dedicated tablet layout in v1.0.
- **Dependencies**: #002 (cursor pagination + drift cache base), #004 (canonical `Post` + save toggle + feed grid tile), #006 (post detail + save action surface), #010 (profile tab bar to host the Saved tab). Requires access to the B#011 collections contract.
