# Contract: Optimistic Engagement (like / save)

Governs post **like** (US2) and **save** (US3). Same reconcile shape; save has no collection
picker (#011). Story like reuses the optimistic pattern in-memory (no backend).

## Rules (Constitution IX)

1. **Optimistic write first** — toggle the canonical `Post` in drift immediately
   (`viewerHasLiked`/`viewerHasSaved` flip; `likeCount`/`saveCount` ±1). The reactive
   `watchHomeFeed()` stream repaints every on-screen copy at once (< 100 ms, SC-003; FR-010/FR-013).
2. **Server call** — `FeedRepository.toggleLike|toggleSave` via `ApiClient` with an **idempotency
   key** (`ApiClient.post(idempotent:true)`). Backend contract is idempotent (re-like = no-op), so a
   retry after a flaky network never double-applies (FR-012/FR-016).
3. **Reconcile on success** — adopt the returned `EngagementState` counts/flags
   (`PostsDao.applyEngagement`); never keep client-guessed numbers.
4. **Rollback on failure** — re-upsert the prior `Post` snapshot and show a `Toast`
   (FR-011/FR-015). No `error` state for the whole feed — the list stays interactive.

## Sequence

```
tap like (was unliked)
  → PostsDao: viewerHasLiked=true, likeCount+1     (instant repaint via watch)
  → POST /posts/{id}/like  (idempotent key)
       ok(EngagementState)  → applyEngagement(server counts)
       err(AppFailure)      → re-upsert prior snapshot + Toast(l10n error)
```

## Idempotency

Each mutation carries a client-generated key (reused across retries of the *same* logical action)
via the #002 idempotency interceptor. Combined with the server's idempotent endpoints → at-most-once
effect regardless of retries (FR-012/FR-016).

## Test matrix (bloc_test)

| Case | Expect |
|---|---|
| like success | optimistic flip → server counts adopted; no rollback |
| like server-failure | optimistic flip → rollback to prior → Toast; count unchanged from start |
| double-tap / retry | single net effect (idempotent); count not doubled |
| save success / failure | mirror of like on `viewerHasSaved`/`saveCount` |
| same post in 2 places | both repaint identically (one canonical `Post`) |
| story like | in-memory optimistic flip + rollback on fake failure |
