# Quickstart — Post Detail & Comments (#006)

Validation guide for the post-detail + comments surface. Everything runs **offline** in DI `environment:'fake'` (Constitution XII) — no backend. Implementation details live in `tasks.md`; this file proves the feature end-to-end.

## Prerequisites
- Flutter 3.44.4 / Dart 3.12.2; deps fetched (`flutter pub get`); codegen run (`dart run build_runner build --delete-conflicting-outputs`) for freezed/json + injectable.
- App on the dev flavor (`main_dev.dart`), signed in (fake session from #003), Home feed populated (#004 fakes).

## Automated validation (authoritative)
```bash
dart format .
flutter analyze                 # zero warnings (dart analyze if the flutter analysis-server is unavailable)
flutter test                    # all green, incl. the #006 suites below
dart run bloc_tools:bloc lint . # zero violations (if runnable locally)
```

Key #006 test targets:
- `test/core/data/comments/fake_comments_repository_test.dart` — seed/paginate oldest-first; add is idempotent (repeat key ⇒ 1); like target-state; delete cascade returns `1+replyCount`; report no-op.
- `test/features/post/comments_cubit_test.dart` — load → loaded; scroll → paginating → loaded; optimistic add/reply insert + confirm; failure rollback; like flip + revert; delete-own cascade + count delta; `commentsDisabled` hides input.
- `test/features/post/post_detail_page_test.dart` — renders `PostCard` + first comment page; empty/error-retry states; opening from the feed. (Logic-first; synchronous fakes; fixed `pump(Duration)` — the #005/#007 lesson.)
- `test/features/post/comment_count_consistency_test.dart` — add/delete keeps feed `commentCount` == detail `commentCount` (one canonical `Post`).
- `test/features/post/comment_redaction_test.dart` — no comment text / author id / PII in logs (FR-020).
- `test/features/post/post_detail_goldens_test.dart` — comment tile (+reply indent), input row, tablet two-column split; light + dark.
- `test/features/post/post_detail_a11y_test.dart` — Semantics labels, text-scaling, phone (pushed) + tablet (two-column) adaptive.

> Use the synchronous `FakeCommentsRepository` + a fake `FeedRepository` seam; test logic-first via `CommentsCubit`; avoid real image `pumpAndSettle`.

## Manual scenarios (fake mode)

1. **Open + read (US1/MVP)** — Home → tap a post (or "View all N comments") → full-screen Post detail (no bottom nav) shows the post + first comments (oldest-first). Scroll → more load. A comment with replies shows them indented one level.
2. **Add a comment (US2)** — type → Post → appears immediately at the end, input clears, the post's comment count increments (also in the feed) with no refresh. Force a failure → it rolls back + Toast; Retry → exactly one comment.
3. **Reply (US3)** — tap Reply on a comment → reply-to banner → Post → reply appears indented under that comment. Reply to a reply → still lands under the same top-level parent (never a second level). Cancel banner → back to top-level compose.
4. **Like a comment (US4)** — tap the small like glyph → liked + count up instantly; force failure → reverts + Toast; rapid toggle settles to the last intent.
5. **Delete own / report other (US5)** — own comment → action sheet → Delete → confirm → removed, count decrements (a parent removes its replies too, count −(1+replies)); other's comment → action sheet → Report → acknowledged Toast (no change).
6. **Comments off (US2/FR-012)** — a post with commenting turned off → input row hidden; existing comments still render read-only.
7. **Tablet (US6)** — on iPad/tablet width, opening a post shows a two-column split (media left on `#0E0E1A`, comments + input right); on phone it is the pushed full-screen detail. Behavior identical.
8. **Offline / empty / error** — offline → cached post + "comments unavailable" + retry (no crash). Zero-comment post → friendly empty state. First-load failure → error + retry.
9. **Mentions/hashtags** — a comment with `@handle` / `#tag` renders them in violet, non-tappable.

## Expected outcomes (map to Success Criteria)
- First comments visible < 1 s; post itself instant from cache (SC-001).
- Optimistic comment appears < 300 ms, zero manual refresh (SC-002).
- Retry never creates >1 comment (SC-003); failed add/like/delete fully rolls back (SC-004).
- Feed and detail `commentCount` always match (SC-005); whole journey works with no network (SC-006).
- Replies never exceed one level (SC-007); a11y/text-scale/light-dark pass on phone + tablet (SC-008).
</content>
