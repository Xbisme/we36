# Implementation Plan: Post Detail & Comments

**Branch**: `006-post-comments` | **Date**: 2026-07-02 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/006-post-comments/spec.md`

## Summary

Add a full-screen **Post detail** reachable from the feed and a **Comments** surface on top of the existing #004 canonical `Post`. Comments are a **cursor-paginated, oldest-first** list with **one-level replies**, a **quick-emoji** input row, **optimistic + idempotent** add/reply, optimistic **comment like**, and **delete-own / report-other** via an action sheet. Everything runs offline in DI `environment:'fake'`: a **real `CommentsRepository` seam on the B#comments contract** plus an **in-memory fake** (the one that runs), mirroring the #002/#004 posts pattern. The post's `commentCount` stays canonical (one cached `Post`) so feed and detail never diverge. On tablet/iPad the detail renders as a **single-post two-column split** (media | comments); on phone it is a pushed nav-less route. No new pub dependency and **no drift schema bump** (comments are transient/paginated; only the `Post` stays cached).

## Technical Context

**Language/Version**: Dart 3.12.2 / Flutter 3.44.4 (canonical toolchain, pinned floor `^3.11.5`).

**Primary Dependencies**: `flutter_bloc`, `get_it`+`injectable`, `go_router`, `freezed`+`json_serializable`, `dio` (via the #002 `ApiClient`), `uuid` (idempotency keys), `lucide_icons_flutter`; reuse #002 `PaginatedListCubit`/`CursorPage`/`ApiClient`/`FailureMapper`/`Result`, #004 `Post`/`PostCard`/posts drift cache, #001 `AppTextField`/`ActionSheet`/`AppDialog`/`Toast`/`AppIcon`/`AppBreakpoints`/`CenteredMobile`.

**Storage**: existing drift `AppDatabase` — **read/update only the canonical `Post`** (posts DAO from #004). Comment list is **not persisted** (transient pagination). **No schema migration.**

**Testing**: `flutter_test`, `bloc_test`, `mocktail`, golden tests. Follow the #005/#007 widget-test lesson (fixed `pump(Duration)`, logic-first cubit tests, synchronous fakes; avoid real image `pumpAndSettle`).

**Target Platform**: iOS + Android phones + iPad/Android tablets (adaptive by width).

**Project Type**: Mobile app (Flutter), Clean Architecture feature-first.

**Performance Goals**: first comment page visible < 1 s (SC-001); optimistic comment appears < 300 ms (SC-002); 60 fps lazy list, bounded memory (Constitution II).

**Constraints**: offline-capable (fake mode, SC-006); optimistic + idempotent mutations with rollback; no PII/comment text in logs (FR-020); Toast for all messages; tokens-only styling; a11y + text-scaling + light/dark on phone & tablet.

**Scale/Scope**: 2 screens (Post detail 14, Comments 15) + tablet two-column variant; ~1 new core data slice (`core/data/comments/`) + 1 feature slice (`features/post/`); comment count reconciled on the shared canonical `Post`.

## Constitution Check

*GATE: must pass before Phase 0; re-checked after Phase 1.*

- **I. Privacy, Safety & Trust** — PASS. **Report** is reachable from every comment (action sheet, FR-011); no comment text / author identity in logs (FR-020). Delete-own gated by viewer ownership. Real moderation/blocked-state enforcement is explicitly deferred to #014 (surface-only report here — consistent with #007).
- **II. Media-Centric Performance** — PASS. Comments use **cursor pagination** via the shared `PaginatedListCubit` (lazy, no offset); the detail reuses `PostCard` (already cached-image-bounded). No new media path.
- **III. BLoC-Driven State** — PASS. New screen-scoped `@injectable` `CommentsCubit` (freezed 4-state, extended variants prefix the base name); list via `PaginatedListCubit<Comment>`; side effects (toast/haptic/nav/action sheet) via `BlocListener`; Use Cases injected into the Cubit (not repos); all Cubits closed.
- **IV. Code Quality** — PASS. `very_good_analysis` zero-warning; freezed immutables; explicit types; actionable non-technical messages via l10n.
- **V. Result\<T\>** — PASS. Repository returns `Result<T>`; failures mapped by `FailureMapper` into `AppFailure`.
- **VI. Design Discipline** — PASS. Tokens/`AppColorsX` only; brand violet on `@mention`/hashtag + like-active per "color earns its place"; shared widgets built once in the feature; Lucide via `AppIcon`; press scale + reduce-motion honored.
- **VIII/IX. Backend-agnostic + one canonical representation** — PASS. Real + fake `CommentsRepository` behind one interface; app runs `fake`. The **single canonical `Post`** (drift) carries `commentCount`; both feed and detail read it — no per-cubit copies.
- **X. Centralized constants** — PASS. New comment endpoints added to `core/constants/api_endpoints.dart` (no inline literals).
- **XII. Runs without a server** — PASS. `FakeCommentsRepository` seeds an in-memory conversation; whole flow is zero-network.

**No violations** → Complexity Tracking not required.

## Project Structure

### Documentation (this feature)

```text
specs/006-post-comments/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output (comments API contract)
│   └── comments-api.md
└── tasks.md             # Phase 2 output (/speckit.tasks — NOT created here)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── constants/
│   │   └── api_endpoints.dart            # + comment endpoints (list/add/like/delete/report)
│   └── data/
│       ├── comments/                     # NEW comment data slice (core, backend-agnostic)
│       │   ├── comment.dart              # Comment + CommentAuthor projections (freezed + json)
│       │   ├── comments_repository.dart  # interface (Result<T>, CursorPage<Comment>)
│       │   ├── comments_remote_data_source.dart
│       │   ├── comments_repository_impl.dart   # @LazySingleton(as:..., env:['real'])
│       │   └── fake_comments_repository.dart    # @LazySingleton(as:..., env:['fake'])
│       └── feed/
│           └── feed_repository.dart      # + watchPost(id) + applyCommentCountDelta(id, delta) seam
├── features/
│   └── post/                             # NEW feature slice (Screens 14–15)
│       ├── domain/
│       │   └── usecases/                 # LoadComments, AddComment, ToggleCommentLike, DeleteComment, ReportComment
│       └── presentation/
│           ├── cubit/
│           │   ├── comments_cubit.dart   # @injectable, freezed 4-state (+ optimistic reconcile)
│           │   └── comments_state.dart
│           ├── post_detail_page.dart     # phone push + tablet two-column split (media | comments)
│           └── widgets/
│               ├── comment_tile.dart      # avatar + name + text + time + like + Reply (+ reply indent)
│               ├── comment_text.dart      # @mention (violet) / #hashtag spans, non-tappable
│               ├── comment_input.dart      # avatar + field + quick-emoji + Post + reply-to banner
│               └── quick_emoji_row.dart
└── core/router/app_router.dart           # + /post/:id nav-less route; AppRoutes.postDetail

test/
├── core/data/comments/                   # fake repo: seed/paginate/add-idempotent/like/delete-cascade
└── features/post/                        # cubit optimistic/rollback/reply/like/delete + widget + goldens + a11y/adaptive
```

**Structure Decision**: Comment **data** lives in `core/data/comments/` (backend-agnostic, reusable, `core` MUST NOT import `features`), matching how feed/stories data slices sit in `core/data/`. Comment **UI + orchestration** lives in the new `features/post/` slice. The canonical `Post` and its `commentCount` remain owned by the #004 feed cache; `FeedRepository` gains a `watchPost(id)` read and a `applyCommentCountDelta` writer so the detail and comments reconcile the one cached copy (Constitution IX).

## Complexity Tracking

No constitution violations — section intentionally empty.
</content>
