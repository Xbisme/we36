# Spec #006 — Post Detail & Comments · Alignment Decisions

> **✅ Merged 2026-07-02 into `main` via PR #7** (`006-post-comments`, 46/46 tasks, 349 tests green). Clarify locked: oldest-first · 2,200-char max · count includes replies (delete cascade −(1+replies)) · quick-emoji inserts into input. Analyze F1 resolved: the `AddComment`/`DeleteComment` use cases solely own the canonical `commentCount` delta. See [`../changelog.md`](../changelog.md) §2026-07-02 #006 and [`../../specs/006-post-comments/`](../../specs/006-post-comments/).

> Pre-`/speckit.specify` alignment session (2026-07-02). Depends on #004 (feed `PostCard` + canonical `Post` in drift) ✅ and the #001 two-pane/master-detail primitive ✅. **Last sibling of the content trio** (#005 story / #007 post / #006 comments). Unlike stories, **a backend `comments` contract exists** (per [`api_endpoints.dart`](../../lib/core/constants/api_endpoints.dart): "backend has auth/posts/media/comments only") — so #006 builds a **real `CommentsRepository` seam on the actual contract + an in-memory fake**; the app still runs `environment:'fake'` (zero-network) until real cutover.

## Context
- **Design**: Screen 14 (Post detail) — TopBar "Post" + `more`; full `PostCard` (#004) + "View all N comments" affordance. Screen 15 (Comments) — TopBar "Comments"; comment list (avatar + user bold + text + time/likes/Reply + small like glyph), **one-level reply** (indent 40px, avatar 28), a **quick-emoji** row, and an input row (avatar + "Add a comment…" + sticker glyph + "Post"). Tablet = **master/detail two-pane** (Screen 14 `TabletPostDetail`: left media pane on `#0E0E1A` `contain`, right ~400 pane = author header + scrolling comments + action row + comment input). See [`ui-design-context.md`](../ui-design-context.md) Screens 14–15 + §Responsive.
- **Reuses**: #004 `Post` model (already has `commentCount` + `commentsDisabled`), `PostCard`, optimistic-mutation + rollback pattern (like/save), `PaginatedListCubit<T>` + `CursorPage<T>` (#002); #001 two-pane primitive, `AppTextField`, action sheet, Toast; `AppFailure`/`Result<T>`.

## Decisions (confirmed with user)

| # | Topic | Decision | Rationale |
|---|---|---|---|
| 1 | **Data source** | **Real `CommentsRepository` seam on the B#comments contract + in-memory fake** (`env:['real']` / `env:['fake']`). App runs `fake` (zero-network). New comment endpoint constants in `api_endpoints.dart`. | Backend already exposes `comments` (unlike stories). Matches the #002/#004 posts pattern; no provisional-contract debt. |
| 2 | **Comments cache** | **In-memory paginated (transient) via `PaginatedListCubit`** — **no drift schema bump**. The canonical `Post` (with `commentCount`) stays the drift-cached item; the comment list is a per-detail-session paginated stream. | Comments are detail-scoped and high-churn; persisting them adds a schema migration for little offline value at MVP. Keeps #006 free of a drift v4→v5 change. |
| 3 | **Mentions** | **Render `@mention` styled (violet), non-tappable for now** — defer mention/avatar → profile navigation to **#010 Profile & Follow**. | Profile isn't built yet; a placeholder route would be throwaway. Text styling is the visible MVP value. |
| 4 | **Optimistic + idempotent add** | Comment/reply **append optimistically** with a client `Idempotency-Key` (UUIDv7); rollback + Toast on failure; retry reuses the key ⇒ exactly one comment. Comment **like** is optimistic with rollback (target-state, like post like/save). | Constitution — optimistic + idempotent mutations; consistent with #004 like/save + #007 create. |
| 5 | **Delete / report** | **Delete own comment** = optimistic remove (confirm via action sheet, `commentCount` decrements on the canonical `Post`). **Report others'** = surface-only action sheet + Toast ack (no enforcement backend). | Mirrors #007's surface-only report; real moderation/blocked-state is #014. |
| 6 | **`commentsDisabled`** | When a post has `commentsDisabled`, show the list read-only-ish state (no input row) per FR; still render existing comments if any. | `Post.commentsDisabled` already modeled (#004/#007); honor it. |
| 7 | **Tablet layout** | **Screen 14 two-pane is a single-post split** (media pane + comments pane), **not** list/detail — built with the #001 primitive; phone keeps push to `/post/:id`. Same Cubits, only presentation differs. | Matches §Responsive (`TabletPostDetail`); avoids conflating with the Messages list/detail split (#012). |

## Scope (v1.0 #006)
- Post detail route `/post/:id` (phone push, nav-less full-screen per §46) rendering the #004 `PostCard` + comments entry.
- Comments list (paginated) + **one-level replies** + quick-emoji row + comment compose (optimistic add, idempotent) + like a comment (optimistic) + delete-own / report-other via action sheet.
- `@mention` + hashtag styling (non-tappable mentions for now).
- Tablet master/detail two-pane for Screen 14; phone push. Honor `commentsDisabled`.
- Empty / loading / error (retry) / offline states; Toast for all messages; a11y + light/dark + text-scaling; two-pane + phone adaptive tests.

## Deferred (NOT in #006)
- **Nested reply threads beyond one level** (roadmap defer).
- Mention/avatar → profile navigation (→ #010); comment moderation / blocked-state enforcement (→ #014); comment stickers/GIFs, pinned comments, comment translation, reactions beyond a single like.

## To confirm at `/speckit.plan`
- Exact B#comments contract shape (list cursor params, reply-of field, like endpoint) — align with the real endpoint names.
- Comment quick-emoji set (fixed list) + whether tapping one inserts into the input vs posts immediately (Screen 15 shows a quick row — likely insert-into-input).
- Whether reply compose reuses the same input row (reply-to banner) or a distinct affordance.
- Two-pane primitive reuse details (selecting from feed on tablet: push into detail vs open pane) — confirm feed→detail stays push-to-full-detail (single post), not a list/detail feed split.
</content>
</invoke>
