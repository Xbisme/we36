# Quickstart / Validation: Settings, Privacy & Safety (#014)

How to exercise and validate #014 end-to-end. The app runs DI `environment: 'fake'` (zero-network) — all scenarios pass against the fakes, no live backend needed.

## Prerequisites

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after new freezed models / DI / DTOs
```

## Run

```bash
flutter run --flavor dev            # fake DI env (default)
# open own Profile → tap the gear (top-right) → Settings
```

## Validation scenarios (map to user stories / SC)

1. **US1 — Settings hub**: Profile → gear opens Settings with groups Account / Privacy / Notifications / Language / Theme / About. About shows app name + version + build. "Log out" → confirm → lands on sign-in. *(SC-001: any control ≤3 taps from profile.)*
2. **US2 — Private + requests**: Privacy → toggle **Private account** on. In fake data a pending request appears in **Follow requests**; Approve → requester becomes a follower, follower count +1, row gone; Decline another → row gone, count unchanged. Retry an Approve → still exactly one follower. *(SC-002, SC-003, FR-011/012.)*
3. **US3 — Block**: From a user profile more-sheet → Block → confirm. Their content disappears from feed, search, and the conversation list **without reloading the app**; their profile shows blocked state. Settings → **Blocked accounts** → Unblock → content returns on next load; follow is NOT auto-restored. *(SC-004, SC-005, FR-014/015/016.)*
4. **US3 — Report**: Any post/reel/comment/profile more-sheet → Report → pick a reason (Spam … Intellectual-property violation … Other) → submit → acknowledgement toast, sheet closes. *(FR-018/019/020.)*
5. **US4 — Close friends**: Settings → **Close friends** → add accounts (only those who follow you are addable) → remove one → reopen: membership persisted, no duplicates. A Close-Friends story (from #005) reaches only them. *(FR-021/022/023.)*
6. **US5 — Language & theme**: Settings → Language → Vietnamese: UI copy switches immediately. Theme → Dark: palette switches. Kill + relaunch the app → both still applied. Set each to System → follows device. *(SC-006, FR-024–027.)*
7. **US6 — Secondary**: Toggle **Activity status** off → messaging active-now rail / green dots / typing hide, and you no longer see others' presence (reciprocal). Open **Two-factor** and **Download your data** entries → each shows its (entry-only) screen without error. *(FR-028/029.)*
8. **US7 — A11y/adaptive**: Run at 2× text scale, light + dark, phone + tablet width, with a screen reader → every row/toggle/action announces a label and state; tablet uses the sidebar/adaptive chrome; no clipped labels. *(SC-007, FR-030/031.)*
9. **Logout wipe**: after logout, account-scoped privacy state (blocked set, requests, close-friends cache) is cleared; **theme/language survive** (device-scoped). *(FR-033.)*
10. **Redaction**: no tokens/credentials/PII in logs from any privacy/safety action. *(SC-008, FR-034.)*

## Gate (must pass before PR — Constitution Pre-Commit)

```bash
dart format .
flutter analyze                  # zero warnings
flutter test                     # all pass (incl. #014 cubit/repo/widget/golden/a11y/redaction)
dart run bloc_tools:bloc lint .  # zero violations (no local CLI — note in PR)
```

## Notes

- **Real-backend cutover**: `RealBlockRepository.listBlocked()` needs the pending **`GET /me/blocks`** (contract D5) — until then the Blocked-accounts list is fake-only. All other repos bind to shipped endpoints.
- `package_info_plus` is the only new dependency (About). Confirm latest stable at T001.
