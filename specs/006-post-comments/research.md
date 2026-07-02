# Research — Post Detail & Comments (#006)

Phase 0. Resolves the design unknowns before Phase 1. No open `NEEDS CLARIFICATION` remain (the four spec Assumptions were locked in `/speckit.clarify` 2026-07-02). Each decision below is what the tasks will build against.

## R1 — Comment model & B#comments contract shape

- **Decision**: A flat `Comment` with an optional `parentId` (the top-level comment a reply belongs to; `null` for a top-level comment). Fields: `id`, `postId`, `author` (`CommentAuthor` = the #004 `UserSummary` projection), `text`, `createdAt`, `likeCount`, `viewerHasLiked`, `parentId?`, `isOwn` (viewer owns it → delete vs report), `replyCount` (top-level only, for "View replies"). Optimistic entries additionally carry a client-side `pending` flag + `clientKey` (UUIDv7) that the confirmed server entry reconciles against. Endpoints (added to `api_endpoints.dart`): `GET /posts/{id}/comments?cursor=&limit=` (top-level, oldest-first), `GET /comments/{id}/replies?cursor=&limit=` (one level), `POST /posts/{id}/comments` (body `{text, parentId?}`, `Idempotency-Key`), `POST/DELETE /comments/{id}/like`, `DELETE /comments/{id}`, `POST /comments/{id}/report`.
- **Rationale**: A flat list with `parentId` cleanly caps nesting at one level (a reply-to-a-reply reuses the reply's `parentId`, never creating depth 2 — FR-004/FR-006/SC-007). Mirrors the B#004 `Post`/`UserSummary` JSON conventions (camelCase, UUIDv7). Like uses the same `POST/DELETE` idempotent target-state shape as post like/save (returns the reconciled `likeCount`+`viewerHasLiked`).
- **Alternatives**: nested `replies: []` embedded in each comment (harder to paginate replies, tempts multi-level); a `depth` integer (over-general for a one-level cap).

## R2 — Comment list pagination & optimistic reconciliation

- **Decision**: Reuse the #002 `PaginatedListCubit<Comment>` for the top-level list (`idSelector: c.id`, oldest-first order preserved by the server/fake). The screen-scoped `CommentsCubit` wraps it and owns the mutation overlay: on add/reply it inserts a `pending` optimistic `Comment` (append to end of its group), then on success **replaces** the pending entry (matched by `clientKey`) with the confirmed one, or **removes** it on failure (rollback) + Toast. Replies for a given parent are loaded on demand ("View N replies") via a second fetch, and appended indented under the parent. Rapid like toggles resolve to the **last intended** target-state (drop stale in-flight results by comparing the desired flag).
- **Rationale**: `PaginatedListCubit` is explicitly documented as "reused by feed/search/comments"; its soft-failure-on-load-more (keep loaded items) matches SC/UX. Client-key reconciliation gives exactly-once semantics with idempotent retry (FR-007/SC-003) without duplicates.
- **Alternatives**: a bespoke pagination cubit (re-invents #002); persisting comments to drift (rejected — see R3/Assumptions, adds a migration for little offline value).

## R3 — Canonical `commentCount` update (Constitution IX)

- **Decision**: The **one cached `Post`** (drift, owned by #004) remains the single source of `commentCount`. `FeedRepository` gains `watchPost(String id)` (reactive read of the cached row) and `applyCommentCountDelta(String id, int delta)` (upsert the row with an adjusted count). `PostDetailPage` renders the post from `watchPost(id)`. The **`AddComment` / `DeleteComment` use cases are the single owner** of the count delta (they inject `FeedRepository`): `applyCommentCountDelta(+1)` on a confirmed add/reply and `applyCommentCountDelta(-(1 + replyCount))` on a confirmed cascade delete (clarified 2026-07-02). The `CommentsRepository` never touches the post cache (no repo→repo dependency). The Cubit adjusts the count optimistically for instant paint and rolls back with the comment on failure; the use case reconciles the confirmed delta.
- **Rationale**: Guarantees SC-005 (feed and detail counts never diverge) with no second copy of the post. Reuses the existing posts DAO/cache; the feed already repaints from the same canonical row.
- **Alternatives**: a separate count field in `CommentsCubit` state (would drift from the feed); recomputing count from the loaded page (wrong — page is partial).

## R4 — Reply model (one level, hard cap)

- **Decision**: Replying to a top-level comment sets `parentId = comment.id`; replying to a **reply** sets `parentId = reply.parentId` (the same top-level ancestor). The UI indents replies exactly one level (40px, avatar 28 per Screen 15) and never renders a deeper indent. A `ReplyContext` (target top-level comment + display @handle prefix) is held in `CommentsCubit` state while composing; cancel clears it back to top-level compose.
- **Rationale**: Structurally impossible to exceed one level (SC-007); matches the mockup indentation.
- **Alternatives**: allowing true depth with a render cap (data model then permits illegal states).

## R5 — Tablet layout: single-post two-column split (NOT list/detail)

- **Decision**: On tablet/iPad width (`AppBreakpoints` ≥700), `PostDetailPage` renders a **two-column split of one post** — left media pane on `#0E0E1A` (image `contain`), right ~400 pane = author header + scrolling comments + input — built directly with `LayoutBuilder`/`AppBreakpoints` (a `Row` of two panes), **not** the `TwoPaneScaffold<T>` primitive. On phone width it is the pushed nav-less full-screen route. Feed → detail is always a navigation (push to `/post/:id`), on both phone and tablet — the feed is **not** turned into a master/detail list.
- **Rationale**: `TwoPaneScaffold<T>` is a **list/detail** primitive (items + selectable list, swaps detail in place) — the right tool for Messages (#012), where a conversation list sits beside the active chat. Screen 14's tablet layout has **no list**; it is one post split into media|comments. Forcing `TwoPaneScaffold` would require a synthetic single-item list. A direct two-column split is simpler and matches `TabletPostDetail` in the design (§Responsive). Confirms the decisions-doc open question: feed→detail stays push-to-full-detail.
- **Alternatives**: `TwoPaneScaffold` with a 1-item list (awkward, semantically wrong); a feed master/detail split (contradicts FR-018 + spec — deferred, not this feature).

## R6 — Optimistic + idempotent mutation mechanics

- **Decision**: Each add/reply generates a UUIDv7 `clientKey` reused as the `Idempotency-Key` header (via the #002 idempotency interceptor). The `FakeCommentsRepository` records seen keys → a retry with the same key returns the already-created comment (exactly one). Comment like reuses the post like/save target-state pattern (send desired `like` bool; reconcile from the returned engagement). Delete/report are also idempotent (deleting an already-deleted comment succeeds no-op).
- **Rationale**: Constitution (optimistic + idempotent); identical to #004 like/save and #007 create — proven pattern, minimal new surface.
- **Alternatives**: server-generated temp ids (needs a round trip before optimistic paint — breaks SC-002).

## R7 — `@mention` / `#hashtag` styling (non-interactive)

- **Decision**: A small `commentTextSpans(text, tokens)` builder emits `TextSpan`s that style `@handles` and `#hashtags` in brand violet, everything else in body color; **no gesture recognizers** (non-tappable, FR-014). Reuse the caption/hashtag styling approach already in `post_card.dart` / `app_tag.dart` (extract or mirror the token usage) so comment and caption styling stay consistent.
- **Rationale**: Delivers the visible value (styled mentions/tags) without wiring profile/tag routes that don't exist yet (deferred to #009/#010). Keeps one styling convention.
- **Alternatives**: full linkify with tap→placeholder route (throwaway before #010); plain text (loses the design's violet accent).

## R8 — DI, routing, l10n, testing conventions

- **Decision**: `CommentsRepository` real (`env:['real']`) + `FakeCommentsRepository` (`env:['fake']`) behind one interface (matches feed/stories). `CommentsCubit` `@injectable` (screen-scoped), Use Cases `@injectable`, page-scoped `BlocProvider`. New route `AppRoutes.postDetail = '/post/:id'` as a **nav-less top-level** `go_router` route (hides bottom nav, per §46). All copy in EN + VI ARB. Tests: fake-repo unit tests (seed/paginate/idempotent-add/like/cascade-delete), `CommentsCubit` bloc_tests (optimistic add/reply/rollback/like/delete + count delta), widget tests (logic-first, synchronous fakes, fixed `pump`), goldens (comment tile + input + tablet split, light/dark), a11y/text-scale/adaptive.
- **Rationale**: Mirrors the established #004/#005/#007 conventions exactly; zero new dependencies.
- **Alternatives**: none material.

## Resolved unknowns (from spec Assumptions / clarify)

| Topic | Resolution |
|---|---|
| Comment ordering | Oldest-first; new entries append to end of group (clarify Q1). |
| Max comment length | 2,200 chars (clarify Q2). |
| Count semantics on parent delete | Count = comments + replies; cascade delete decrements by (1 + replyCount) (clarify Q3). |
| Quick-emoji behavior | Insert into input; still tap Post (clarify Q4). |
| Comment caching | Transient pagination; no drift bump; only `Post` stays cached (Assumptions/R2). |
| Tablet layout | Single-post two-column split, not `TwoPaneScaffold` list/detail (R5). |
| Mention/tag nav | Styled, non-tappable; nav deferred to #009/#010 (R7). |
</content>
