# Quickstart: Saved Collections (#011)

Validation guide — how to prove the feature works end-to-end in **fake mode** (zero-network) and where the automated coverage lives. Not implementation code; see `tasks.md` for the build steps.

## Prerequisites

- Repo on branch `011-collections`, toolchain Flutter 3.44.4 / Dart 3.12.2.
- App runs DI `environment: 'fake'` (default) — the `FakeCollectionsRepository` seeds a small graph: several saved posts/reels (the canonical `viewerHasSaved` set), 2–3 named collections (one with a set cover, one empty), and the synthetic "All saved" default, all over the shipped fake `Posts`.

## Run

```bash
flutter run                      # fake mode (default); launches to the auth-gated shell
# or drive the hermetic suite:
flutter test
```

## Manual walkthrough (maps to user stories)

1. **US1 — Saved tab + collections grid**: open the **Profile** tab → tap the **Saved** tab (owner-only). The Saved screen (Screen 24) renders: a "Saved" header + create (`+`), and a 2-column grid where each card shows a 4-image quilt cover + name + "N saved", with **"All saved"** always first. Confirm the empty case (no named collections → only "All saved"), the fully-empty case (nothing saved → explicit empty state), and offline (kill the network seam, cold-start → the grid renders from the drift v8 cache with an offline hint).
2. **US2 — Save into a collection**: on a feed/detail/reel post, tap the default **Save** (bookmark) → it saves silently and appears in **"All saved"** (no picker). Then use **"Save to collection"** (long-press / action sheet) → the sheet lists collections with a checkmark for those containing the post; toggle one on, or **create a new collection inline** → the post is filed and shows in that collection (and still in "All saved"). Force a failure → the change rolls back with a Toast. Retry a file after a transient failure → exactly one membership (no duplicate).
3. **US3 — Open & curate**: tap a collection → its cursor item grid renders (reels marked) and paginates without duplicates on scroll; tap a tile → **post detail** (#006) opens. Remove an item from the collection → it drops from that grid but stays in "All saved" and any other collection. Fully **unsave** a post that is in ≥1 named collection → a **confirm dialog** appears first; confirm → it's removed from every collection and "All saved", and the bookmark flips off on the feed/detail too (canonical `Post.viewerHasSaved`). Unsave a post only in "All saved" → no confirm.
4. **US4 — Manage a collection**: open a named collection's **more** action sheet → **rename** (name updates on the card), **set cover** (pick a saved item → the card's cover changes), **delete** (confirm) → the collection is gone but its posts are **still saved** in "All saved". Confirm the **"All saved"** default exposes no rename/delete/set-cover.
5. **US5 — Inclusive & adaptive**: run with a screen reader (labels + roles on cards, tiles, create/save-to-collection/remove/rename/delete/set-cover); set 2× text scale (names/counts don't clip) in light + dark; widen to tablet (≥700) → Screen 24 renders the centered-mobile fallback (no bespoke tablet layout).

## Success-criteria checkpoints

| SC | How to verify |
|---|---|
| SC-001 | Save a post and file it into a new collection in one uninterrupted flow (< 15 s). |
| SC-002 | A saved post appears in "All saved" immediately, no manual refresh. |
| SC-003 | Save/file/remove/rename/delete reflect optimistically; a forced failure restores the exact prior state + count with a Toast. |
| SC-004 | Retry a file/create after a transient failure → exactly one membership/collection (no duplicate). |
| SC-005 | Removing an item from one collection keeps it in "All saved" + every other collection; a full unsave removes it from all. |
| SC-006 | Deleting a collection leaves 100% of its posts still saved and visible in "All saved". |
| SC-007 | Unsaving from the Saved surface flips the bookmark on feed/detail/reels (and vice-versa) — one canonical `Post.viewerHasSaved`. |
| SC-008 | a11y labels; 2× text scale in light+dark; phone/tablet reflow. |

## Automated coverage (authoritative)

- **DAO (`test()`, real in-memory `AppDatabase`)**: `SavedCollectionsDao` upsert/watch/order/`clearUserScoped`; the v7→v8 migration (additive `createTable`).
- **Cubit/logic (`test()` / `blocTest`, real fake repo)**: collections load + offline-cache render, save→All-saved, file/remove membership optimistic + rollback + idempotency, full-unsave-confirm gating (in-named-collection vs All-saved-only), rename/delete (posts stay saved)/set-cover, count-consistency (SC-005/006), cross-surface save consistency (SC-007), item-grid pagination.
- **Widget (`testWidgets`, stub cubits — no real drift I/O)**: collections grid + collection card, save-to-collection sheet (pick/create/toggle), collection detail grid, empty/offline/error states, unsave confirm dialog, adaptive phone↔tablet, a11y + 2× text scale, goldens (collection card, collections grid, save-to-collection sheet, empty state, light+dark).
- **Redaction**: no `print`/`debugPrint`; no tokens leaked. Any clock-dependent fake seam is frozen in tests (no fixed wall-clock — the post-#10 time-bomb learning).

> On-device VoiceOver/TalkBack + physical rotation + long-list memory profiling are deferred to the **#015** release gate (automated coverage is authoritative here), matching #004/#008/#009/#010.

## Notes

- The `contracts/collections-api.md` paths are **derived** from repo conventions — reconcile with the shipped B#011 before wiring `CollectionsRepositoryImpl` (`env:['real']`). The fake (`env:['fake']`) is authoritative for all tests.
- **drift schema v7→v8** (new `SavedCollections` table, additive migration); **no new pub dependency**.
- The canonical **saved flag** is the shipped `Post.viewerHasSaved` (#004); "All saved" is a **virtual view** over it (no membership rows).
