# Quickstart: Direct Messages (Realtime) (#012)

A run/validation guide proving DM works end-to-end in the hermetic **fake** environment (zero network, `FakeRealtimeClient` scripts inbound events). Implementation detail lives in `tasks.md`; models/contracts in `data-model.md` / `contracts/`.

## Prerequisites

- Repo baseline Flutter 3.44.4 / Dart 3.12.2; deps already resolved (no new package).
- App runs DI `environment: 'fake'` by default (`--dart-define=DI_ENV=fake` is implicit for tests).
- After adding models/tables/events: `dart run build_runner build --delete-conflicting-outputs` (freezed/json/drift/injectable codegen), then verify drift **v9** compiles and DI resolves `MessagingRepository` (`env:['fake']`), `RealtimeConnectionManager`, and `MessagingRealtimeService`.

## Automated validation (authoritative)

Run the full gate:

```bash
dart format .
flutter analyze                 # zero warnings (bar the 2 pre-existing pubspec-sort infos)
flutter test                    # all pass, incl. the new messaging suite
dart run bloc_tools:bloc lint . # (no local CLI — skipped, per prior specs)
```

The messaging suite (fake mode) covers each user story + success criterion:

| Scenario | Proves | Where |
|---|---|---|
| Conversation list loads from cache, ordered newest-first, unread emphasis + tab badge | US1 · FR-001/002/003 · SC-001 | `conversations_cubit_test` + `conversations_page_test` (stub cubit) |
| `typing` inbound decorates a row; `presence.update` toggles the online dot | US1 · FR-004/005 · R3 | `messaging_realtime_service_test` + `conversations_cubit_test` |
| Offline: list renders from cache; reconciles when the fake backend responds | US1 · FR-007 · SC-001 | `conversations_cubit_test` |
| Send text: optimistic append → `sent` → (`delivered`) → `read` as receipts arrive | US2 · FR-009/010 · SC-002 | `chat_cubit_test` |
| Inbound `message.new` appends live; same event twice → exactly one message | US2 · FR-011 · SC-004 | `messaging_realtime_service_test` |
| Mark-read on view clears the unread marker + tab badge, emits `conversation.read` | US2 · FR-013 · SC-005 | `chat_cubit_test` |
| Offline send queues (`sending`) and flushes once on reconnect; retry = exactly one | US2 · FR-014 · SC-003/006 | `chat_cubit_test` + `messaging_dao_test` |
| History back-pages without dupes/reorder over ≥5 pages | US2 · FR-015 | `chat_cubit_test` |
| Send photo (pick→upload→send) renders a photo bubble with progress/failure | US3 · FR-016 | `chat_cubit_test` + `chat_composer_test` |
| Share a post/reel → card bubble deep-links; deleted target → unavailable state | US3 · FR-017 | `shared_post_card_test` |
| Send a sticker → sticker bubble | US3 · FR-018 | `chat_composer_test` |
| New message: search → select existing-conversation person opens the thread (no dup) | US4 · FR-020/021 · SC-007 | `new_message_cubit_test` |
| Tablet two-pane: selecting a row swaps the detail pane (no push), shares state | US5 · FR-022 · SC-008 | `messaging_shell_test` (wide surfaceSize) |
| a11y labels on rows/bubbles/send/attach/presence; 2× text scale no clip; light/dark | US6 · FR-024 · SC-009 | `a11y_adaptive_test` + goldens |
| No message body/token/media ref in logs | US6 · FR-026 · SC-009 | `log_redaction_test` |
| drift v8→v9 migration creates both tables; `clearUserScoped` wipes them | FR-028 · IX | `messaging_dao_test` (real in-memory `AppDatabase`) |

> **Test discipline** (prior-gate learnings): drive the real `MessagingRepository`/drift only in plain `test()` (real async); `testWidgets` seed **stub cubits** with a fixed 4-state (never real drift/socket I/O — deadlocks in faked-async). Freeze any injected clock in `setUp`. `FakeRealtimeClient` scripts all inbound events — no live socket.

## Manual smoke (fake mode, on-device/simulator)

1. `flutter run --dart-define=DI_ENV=fake` → sign in (fake session).
2. Open **Messages** → seeded conversations appear (one unread, one showing "typing…", one with an online dot); tab badge shows the unread count.
3. Open a conversation → messages grouped; type + **send** → bubble appears instantly, advances `sending→sent→…`; a scripted inbound reply appends live; header shows "Active now".
4. Tap the **camera** → pick a photo → it uploads + sends as a photo bubble. Open the **sticker** tray → send a sticker.
5. From a **profile** (#010) tap **Message** → the thread opens (existing) or a new one starts; from a **post/reel** share → a shared-post card lands in the chosen conversation and deep-links back on tap.
6. Tap **+** → search a person → start → thread opens; picking someone you already message opens the existing thread (no duplicate).
7. Rotate to a wide layout / run on iPad → the list + chat show **side by side**; tapping a row swaps the right pane without a push.
8. Toggle airplane mode → the list + open thread still read from cache; send a message (queues) → restore connectivity → it flushes and delivers once.

## Out of scope to validate here

Group chats, calls, reactions beyond stickers, edit/unsend, voice notes, a message-requests inbox, and out-of-app push (that's #013) — none are built. On-device VoiceOver/TalkBack + long-thread memory profiling are deferred to the **#015** release gate (automated fake-mode coverage is authoritative).
