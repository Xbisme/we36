---
description: "Task list for Post Detail & Comments (#006)"
---

# Tasks: Post Detail & Comments

**Input**: Design documents from `/specs/006-post-comments/`
**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/comments-api.md](contracts/comments-api.md), [quickstart.md](quickstart.md)

**Tests**: Included — the constitution mandates the pre-commit gate (analyze + tests) and `quickstart.md` enumerates the authoritative #006 suites. Follow the #005/#007 widget-test lesson: logic-first cubit tests, synchronous fakes, fixed `pump(Duration)` (no `pumpAndSettle` with live images).

**Organization**: Tasks are grouped by user story. MVP = US1. No new pub dependency; no drift schema change.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: parallelizable (different files, no dependency on an incomplete task).
- **[Story]**: US1–US6 (setup/foundational/polish carry no story label).

## Path Conventions

Flutter Clean Architecture, feature-first. Comment **data** in `lib/core/data/comments/`; comment **UI + orchestration** in `lib/features/post/`; shared constants in `lib/core/constants/`; tests under `test/`.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Structure + shared constants/strings/route (no behavior yet).

- [X] T001 Create the feature structure: `lib/features/post/{domain/usecases,presentation/cubit,presentation/widgets}/` and `lib/core/data/comments/` per [plan.md](plan.md).
- [X] T002 [P] Add #006 comment endpoint constants (list `/posts/{id}/comments`, replies `/comments/{id}/replies`, add, like, delete, report) to `lib/core/constants/api_endpoints.dart` — no inline literals (Constitution X).
- [X] T003 [P] Add `AppRoutes.postDetail = '/post/:id'` (nav-less, hides bottom nav) to `lib/core/constants/app_routes.dart`.
- [X] T004 [P] Add EN + VI ARB strings for post detail + comments (screen titles "Post"/"Comments", "Add a comment…", Post, Reply, "View N replies", quick-emoji a11y labels, delete/report/confirm, comments-off, empty/loading/error-retry/offline, report-acknowledged) in `lib/l10n/arb/app_en.arb` + `app_vi.arb`.

**Checkpoint**: constants + strings + route exist; `flutter analyze` clean.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: The comment data slice + canonical-count seam + DI. MUST complete before any user story.

- [X] T005 [P] `Comment` + `CommentAuthor` freezed models (json, `optimistic` factory, `isReply`/`isOwn`, `pending`/`clientKey` client-only fields) in `lib/core/data/comments/comment.dart` per [data-model.md](data-model.md).
- [X] T006 [P] `CommentEngagement` freezed model (`likeCount`, `viewerHasLiked`) in `lib/core/data/comments/comment_engagement.dart`.
- [X] T007 `CommentsRepository` interface (`loadComments`/`loadReplies` → `Result<CursorPage<Comment>>`; `addComment`/`toggleCommentLike`/`deleteComment`/`reportComment`) in `lib/core/data/comments/comments_repository.dart`.
- [X] T008 `CommentsRemoteDataSource` (dio via the #002 `ApiClient`, endpoints from T002, decode + `Idempotency-Key`) in `lib/core/data/comments/comments_remote_data_source.dart`.
- [X] T009 `CommentsRepositoryImpl` `@LazySingleton(as: CommentsRepository, env: ['real'])` in `lib/core/data/comments/comments_repository_impl.dart`.
- [X] T010 `FakeCommentsRepository` `@LazySingleton(as: CommentsRepository, env: ['fake'])` in `lib/core/data/comments/fake_comments_repository.dart` — seed deterministic conversation (top-level + 1–3 replies, ascending `createdAt`, some `isOwn`/`viewerHasLiked`, one high-volume post for pagination, one zero-comment post), oldest-first paging, idempotent add by `clientKey`, like target-state, cascade delete returning `1+replyCount`, report no-op, and an injectable **failure-simulation** hook (first attempt fails, same-key retry succeeds ⇒ one comment) per [contracts/comments-api.md](contracts/comments-api.md).
- [X] T011 Extend `FeedRepository` with `watchPost(String id)` (reactive canonical read) + `applyCommentCountDelta(String id, int delta)` (upsert count) — update the interface `lib/core/data/feed/feed_repository.dart`, real `feed_repository_impl.dart`, and `fake_feed_repository.dart` (Constitution IX; SC-005).
- [X] T012 [P] Use cases (inject `CommentsRepository`; `AddComment`/`DeleteComment` also inject the count-delta seam): `LoadComments`, `LoadReplies`, `AddComment`, `ToggleCommentLike`, `DeleteComment`, `ReportComment` — one file each in `lib/features/post/domain/usecases/`.
- [X] T013 Run codegen (`dart run build_runner build --delete-conflicting-outputs`) for freezed/json + injectable; verify the DI graph resolves `CommentsRepository` under `env:'fake'`.
- [X] T014 [P] Unit-test `FakeCommentsRepository` (seed, oldest-first pagination, idempotent add, like target-state, cascade delete count, report no-op, failure-then-retry ⇒ 1) in `test/core/data/comments/fake_comments_repository_test.dart`.

**Checkpoint**: data slice + count seam compile, DI resolves, fake repo proven — user stories can start.

---

## Phase 3: User Story 1 — Open a post and read its comments (Priority: P1) 🎯 MVP

**Goal**: From the feed, open a full-screen post detail rendering the post + a paginated oldest-first comment list with one-level replies; empty/loading/error-retry states.

**Independent test**: Tap a feed post → detail shows `PostCard` + first comment page → scroll loads more → replies show indented one level; zero-comment post shows empty state; first-load failure shows retry.

- [X] T015 [P] [US1] `CommentsState` freezed 4-state (`initial/loading/loaded/loadedPaginating/error`; `loaded` holds `comments`, `nextCursor`, `hasMore`, `replyContext`, `commentsDisabled`) in `lib/features/post/presentation/cubit/comments_state.dart`.
- [X] T016 [US1] `CommentsCubit` `@injectable` — `load(postId)` + `loadMore()` (reuse `PaginatedListCubit<Comment>` semantics / `LoadComments`), soft-fail on load-more keeps items; reads `commentsDisabled` from the post — in `lib/features/post/presentation/cubit/comments_cubit.dart`.
- [X] T017 [P] [US1] `CommentText` widget — `@mention`/`#hashtag` styled violet via tokens, non-tappable (FR-014), reusing the caption-styling convention — in `lib/features/post/presentation/widgets/comment_text.dart`.
- [X] T018 [P] [US1] `CommentTile` widget — avatar + name (+ verified) + `CommentText` + relative time + like count/glyph + Reply affordance; reply variant indented 40px / avatar 28 — in `lib/features/post/presentation/widgets/comment_tile.dart`.
- [X] T019 [US1] `PostDetailPage` (phone layout) — TopBar "Post" + `more`; renders `PostCard` from `FeedRepository.watchPost(id)`; comments list (lazy, scroll→`loadMore`), empty/loading/error-with-retry/offline states — in `lib/features/post/presentation/post_detail_page.dart`.
- [X] T020 [US1] Wire navigation: add the `/post/:id` route (page-scoped `BlocProvider<CommentsCubit>`) to `lib/core/router/app_router.dart`, and make the feed `PostCard` tap + "View all N comments" push it (`AppRoutes.postDetail`).
- [X] T021 [P] [US1] `bloc_test` `CommentsCubit` load/paginate/empty/error-retry in `test/features/post/comments_cubit_test.dart`.
- [X] T022 [P] [US1] Widget test `PostDetailPage` renders post + first page, empty + error-retry states (logic-first, synchronous fakes, fixed `pump`) in `test/features/post/post_detail_page_test.dart`.

**Checkpoint**: a post opens and its comments read/paginate offline — MVP demoable.

---

## Phase 4: User Story 2 — Add a comment (Priority: P2)

**Goal**: Optimistic, idempotent top-level comment; count increments on the canonical post; rollback + retry; commenting-off hides input; length/empty validation.

**Independent test**: Type → Post → appears at end + count +1 (feed too); failure rolls back; same-key retry ⇒ 1 comment; commenting-off post hides input.

- [X] T023 [P] [US2] `QuickEmojiRow` widget — fixed 8-emoji set `❤️ 🙌 🔥 👏 😢 😍 😮 😂`; tap inserts the emoji into the input (does not post — clarify Q4); each has a Semantics label — in `lib/features/post/presentation/widgets/quick_emoji_row.dart`.
- [X] T024 [US2] `CommentInput` widget — avatar + `AppTextField` "Add a comment…" + `QuickEmojiRow` + Post; disabled on empty/whitespace; enforce ≤2,200 chars (FR-013); hidden when `commentsDisabled` (FR-012) — in `lib/features/post/presentation/widgets/comment_input.dart`.
- [X] T025 [US2] `CommentsCubit.addComment(text)` — generate UUIDv7 `clientKey`, insert `pending` optimistic `Comment` at end + optimistic count `+1` in state; call the `AddComment` use case (which owns the canonical `applyCommentCountDelta(+1)` on confirm — F1/plan R3); on confirm replace pending (real id), on failure remove + revert count + emit error-effect (Toast) — in `comments_cubit.dart`.
- [X] T026 [US2] Mount `CommentInput` in `PostDetailPage`; `BlocListener` shows success/failure Toast + light haptic; clears input on success — in `post_detail_page.dart`.
- [X] T027 [P] [US2] `bloc_test` add: optimistic insert + count delta, failure rollback, idempotent same-key retry ⇒ 1, empty/too-long rejected, `commentsDisabled` hides input in `test/features/post/comments_cubit_add_test.dart`.
- [X] T028 [P] [US2] Comment-count consistency test — add/delete keeps feed `commentCount` == detail (one canonical `Post`) in `test/features/post/comment_count_consistency_test.dart`.

**Checkpoint**: comments can be posted optimistically with exactly-once + count consistency.

---

## Phase 5: User Story 3 — Reply to a comment (Priority: P2)

**Goal**: One-level replies; reply-to-a-reply attaches to the same top-level parent; load a parent's replies on demand.

**Independent test**: Reply on a comment → indented reply appears under it; reply on a reply → still under the same top-level parent; cancel returns to top-level compose.

- [X] T029 [US3] Add `ReplyContext` handling to `CommentsState`/`CommentsCubit`: `startReply(comment)` (normalize `parentId` to the top-level ancestor — R4), `cancelReply()`, and `addComment` uses the active `parentId` — in `comments_cubit.dart` + `comments_state.dart`.
- [X] T030 [US3] Reply-to banner in `CommentInput` (shows "Replying to @handle" + dismiss) driven by `ReplyContext`; Reply action on `CommentTile` triggers `startReply` — in `comment_input.dart` + `comment_tile.dart`.
- [X] T031 [US3] `CommentsCubit.loadReplies(parentId)` ("View N replies") — append fetched replies indented under the parent, preserving order — in `comments_cubit.dart`.
- [X] T032 [P] [US3] `bloc_test` reply: optimistic reply under parent, reply-to-reply normalizes to top-level parent (never depth 2 — SC-007), cancel resets, loadReplies appends in `test/features/post/comments_cubit_reply_test.dart`.

**Checkpoint**: one-level threaded conversation works.

---

## Phase 6: User Story 4 — Like a comment (Priority: P3)

**Goal**: Optimistic comment like/unlike with revert and last-intent settling.

**Independent test**: Tap like → liked + count up instantly; failure reverts; rapid toggle settles to last intent.

- [X] T033 [US4] `CommentsCubit.toggleCommentLike(commentId)` — optimistic flip of `viewerHasLiked`/`likeCount`, reconcile to returned `CommentEngagement`, revert + Toast on failure, drop stale in-flight results (last-intent) — in `comments_cubit.dart`.
- [X] T034 [US4] Wire the `CommentTile` like glyph (solid when liked, token color; press scale + reduce-motion) to `toggleCommentLike` — in `comment_tile.dart`.
- [X] T035 [P] [US4] `bloc_test` like: optimistic flip, revert on failure, rapid-toggle last-intent in `test/features/post/comments_cubit_like_test.dart`.

**Checkpoint**: comment likes behave like post like/save.

---

## Phase 7: User Story 5 — Delete own / report other (Priority: P3)

**Goal**: Action sheet per comment — delete own (confirm, cascade, count −(1+replies)); report other (surface-only ack).

**Independent test**: Own comment → Delete → confirm → removed + count decrement (parent removes replies); other's → Report → ack Toast; delete failure reverts.

- [X] T036 [US5] Comment `more` → `ActionSheet`: Delete (own, `isOwn`) via `AppDialog` confirm, or Report (other) — wired from `CommentTile` — in `comment_tile.dart` + `post_detail_page.dart`.
- [X] T037 [US5] `CommentsCubit.deleteComment(commentId)` — optimistic cascade remove (top-level removes its replies) + optimistic count revert in state; call the `DeleteComment` use case (which owns the canonical `applyCommentCountDelta(-(1+replyCount))` on confirm — F1/plan R3); revert on failure; `reportComment(commentId)` → ack Toast, no state change — in `comments_cubit.dart`.
- [X] T038 [P] [US5] `bloc_test` delete/report: delete-own cascade + count delta, revert on failure, report no-op ack in `test/features/post/comments_cubit_manage_test.dart`.

**Checkpoint**: comment moderation affordances (surface-level) complete.

---

## Phase 8: User Story 6 — Comments on a tablet (Priority: P3)

**Goal**: Single-post two-column split (media | comments) on tablet width; pushed full-screen on phone; identical behavior.

**Independent test**: Tablet width → two-column split; phone width → pushed detail; read/add/like/delete identical across both.

- [X] T039 [US6] Make `PostDetailPage` adaptive by `AppBreakpoints` — tablet (≥700): `Row` two-column (left media pane on `#0E0E1A`, image `contain`; right ~400 pane = author header + comments + input); phone: existing pushed layout; same `CommentsCubit` (R5, FR-018) — in `post_detail_page.dart`.
- [X] T040 [P] [US6] Adaptive widget test — two-column at tablet width, pushed at phone width, behavior parity in `test/features/post/post_detail_adaptive_test.dart`.

**Checkpoint**: adaptive parity phone ↔ tablet.

---

## Phase 9: Polish & Cross-Cutting Concerns

- [X] T041 [P] Log-redaction test — no comment text / author id / PII in logs during load/add/like/delete (FR-020) in `test/features/post/comment_redaction_test.dart`.
- [X] T042 [P] a11y + text-scaling test (Semantics labels for comment/like/Reply/input; large text; light/dark) on phone + tablet in `test/features/post/post_detail_a11y_test.dart`.
- [X] T043 [P] Golden tests — `CommentTile` (top-level + reply indent), `CommentInput` (with reply banner + quick-emoji), tablet two-column split; light + dark — in `test/features/post/post_detail_goldens_test.dart` (+ `goldens/`).
- [X] T044 Run the pre-commit gate. **Result (2026-07-02, Flutter 3.44.4 / Dart 3.12.2)**: `dart format` clean; `dart analyze lib test` = **No issues found!**; `flutter test` = **349 green** (+45 #006, incl. 4 comment goldens); `bloc_tools:bloc lint` not runnable (`bloc_lint` ships no CLI, as #005/#007).
- [X] T045 Execute [quickstart.md](quickstart.md) scenarios 1–9 — validated via the **authoritative automated suites** (all #006 `comments`/`post` suites green). Interactive on-device walkthrough carried to the #015 release gate (per #003/#005 precedent).
- [X] T046 Added the #006 changelog entry + updated `project-context.md` / `sdd-roadmap.md` spec status (🟡 → ✅) + `.claude/claude-app/decisions/spec-006-post-comments.md` cross-links.

---

## Dependencies & Execution Order

- **Setup (P1)** → **Foundational (P2)** block everything. Within Foundational: T005/T006 → T007 → T008/T009/T010; T011 independent [P after models]; T012 needs T007; T013 needs T005–T012; T014 needs T010.
- **User stories**: US1 (P1) is the MVP and must land first (defines `CommentsState`/`Cubit`/`PostDetailPage`). US2 depends on US1 (input + list). US3/US4/US5 depend on US2/US1 (extend the same cubit + tile) and are otherwise independent of each other. US6 depends on US1 (adaptive shell of the same page). 
- **Polish (P9)** last; T044–T046 are the closeout gate.

## Parallel Execution Examples

- **Setup**: T002, T003, T004 in parallel (different files).
- **Foundational models**: T005, T006 in parallel; then T014 [P] once T010 lands.
- **US1 widgets/tests**: T017, T018 in parallel; T021, T022 in parallel after the cubit/page exist.
- **Per-story tests**: T027/T028, T032, T035, T038 each [P] within their story.
- **Polish**: T041, T042, T043 in parallel.

## Implementation Strategy

### MVP first (US1 only)
1. Phase 1 Setup → Phase 2 Foundational (blocks all).
2. Phase 3 US1 → **STOP & validate**: open a post, read + paginate comments offline; empty/error states.
3. Demo the MVP.

### Incremental delivery
US1 (read) → US2 (add) → US3 (reply) → US4 (like) → US5 (delete/report) → US6 (tablet) → Polish. Each adds value without breaking prior stories.

## Notes
- `[P]` = different files, no incomplete-task dependency.
- **Reuse over rebuild**: #002 `PaginatedListCubit`/`CursorPage`/`ApiClient`/`FailureMapper`/`Result`; #004 `Post`/`PostCard`/posts cache + optimistic like/save pattern; #001 `AppTextField`/`ActionSheet`/`AppDialog`/`Toast`/`AppIcon`/`AppBreakpoints`. The canonical `Post` stays the single source of `commentCount`.
- **No drift schema change, no new pub dependency, no new native config.**
- **Test gotcha (from #005/#007)**: real `MemoryImage` + go_router hangs `pumpAndSettle`. Inject synchronous fakes, test logic-first via the cubit, use fixed `pump(Duration)`.
- Commit after each task or logical group; stop at any checkpoint to validate a story independently.
</content>
