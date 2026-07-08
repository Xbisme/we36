---
description: "Task list for #012 Direct Messages (Realtime) (We36 Flutter client)"
---

# Tasks: Direct Messages (Realtime)

**Input**: Design documents from `specs/012-direct-messages/`
**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/messaging-api.md](contracts/messaging-api.md), [contracts/realtime-events.md](contracts/realtime-events.md)

**Tests**: Included (the repo's pre-commit gate requires `flutter test` green; every prior slice ships bloc/widget/golden/fake/redaction coverage). **Realtime is tested against `FakeRealtimeClient`** — typed event in → cache/state out (Constitution XII); never a live socket. Widget tests seed **stub cubits** — never real drift/socket I/O inside `testWidgets` (the #009 gate learning). Any clock-dependent fake seam is **frozen** in tests (the post-#10 time-bomb learning).

**Organization**: Grouped by user story (US1–US6 from spec.md). Phase 2 builds the shared `core/data/messaging/` slice + the **drift v8→v9** (`Conversations` + `Messages`) cache **and wires the realtime socket live** (`RealtimeConnectionManager` + `MessagingRealtimeService`) — all stories consume these. Reuses the shipped `RealtimeClient`/`OutboundEvent`/`InboundEvent`/`SocketEvents` (#002, wired live here), `UserSummary` (#002/#010), `ExploreItem`/`PostRef` + `DiscoveryGridTile` deep-links (#009/#006/#008), `MediaUploadService`/`PhotoLibraryService` (#007), the sticker tray + `TwoPaneScaffold` (#001), `CursorPage`/`PaginatedListCubit` (#002), profile people search (#009/#010). **drift schema v8→v9 (additive); no new pub dependency.**

## Format: `[ID] [P?] [Story] Description with file path`

- **[P]**: parallelizable (different files, no dependency on an incomplete task).
- **[Story]**: US1–US6 (Setup/Foundational/Polish carry no story label).

---

## Phase 1: Setup (Shared Infrastructure)

- [x] T001 Add messaging endpoints to `lib/core/constants/api_endpoints.dart` — `meConversations` (GET `/me/conversations`), `conversation(id)` (GET `/conversations/{id}`), `conversations` (POST `/conversations` — open-or-start), `conversationMessages(id)` (GET history / POST send `/conversations/{id}/messages`), `conversationRead(id)` (POST `/conversations/{id}/read`); reuse the shipped `/users/search` + `/me/following` for compose. No inline literals elsewhere. (Socket event names already in `socket_events.dart` — reused as-is.)
- [x] T002 [P] Add messaging routes to `lib/core/constants/app_routes.dart` — `messages = '/messages'` (tab) + `messageThread = '/messages/:id'` + `messageThreadPath(id)` helper + `newMessage = '/messages/new'`, and the `we36://messages/:id` deep-link mapping (validated).
- [x] T003 [P] Add EN+VI ARB keys in `lib/l10n/arb/app_en.arb` + `app_vi.arb` — "Messages", "New message", "Active now", "typing…", "Message…" (composer hint), "To:", "Suggested", send/failed/retry toasts, "Sending"/"Sent"/"Delivered"/"Seen" (delivery states), "Photo"/"Sticker"/"Shared a post" (previews), unavailable-shared-post label, empty states (no conversations / new empty thread / no search results), offline/connecting affordance, mark-read + block-forbidden failure toasts.
- [x] T004 [P] Scaffold folders per [plan.md](plan.md): `lib/core/services/realtime/`, `lib/core/data/messaging/`, `lib/core/data/cache/tables/` + `daos/` (new files), and `lib/features/messaging/{domain/usecases,presentation/cubit,presentation/widgets}` with file placeholders.

---

## Phase 2: Foundational (data slice + realtime wiring + drift v9 — BLOCKS all user stories)

### Models

- [x] T005 [P] `Message` + `MessageKind` (`text|photo|sharedPost|sticker`) + `DeliveryState` (`sending|sent|delivered|read|failed`) + sealed `MessageContent` (`TextContent`/`PhotoContent`/`SharedPostContent`(+`PostRef`)/`StickerContent`) freezed+json in `lib/core/data/messaging/message.dart` per [data-model.md](data-model.md); derivations `isPending`/`isFailed`/`previewLabel`; validation (text non-empty ≤2,000; photo needs mediaId or localPath; sharedPost needs PostRef; sticker needs glyphId).
- [x] T006 [P] `Conversation` freezed+json in `lib/core/data/messaging/conversation.dart` (`id`, `participant: UserSummary`, `lastMessagePreview?`, `lastActivityAt`, `unreadCount`, transient `isTyping`/`participantOnline` defaulting false) + derivations `hasUnread`/`previewOrTyping`.

### drift v8 → v9

- [x] T007 [P] `Conversations` drift table in `lib/core/data/cache/tables/conversations_table.dart` (id PK text, participantJson text, lastMessagePreview text nullable, lastActivityAt datetime, unreadCount int default 0).
- [x] T008 [P] `Messages` drift table (also the outbox) in `lib/core/data/cache/tables/messages_table.dart` (clientKey PK text, serverId text nullable, conversationId text indexed, authorId text, isMine bool, kind text, contentJson text, createdAt datetime, deliveryState text).
- [x] T009 `MessagingDao` in `lib/core/data/cache/daos/messaging_dao.dart` — `watchConversations()` (order by `lastActivityAt` desc), `watchThread(conversationId)` (order by `createdAt` asc), `upsertConversation(s)`, `upsertMessage(s)`, `advanceDelivery(key, state)`, `pendingOutbox()` (rows in `sending`/`failed`), `markConversationRead(id)`, `clearUserScoped()` (both tables); map rows ↔ `Conversation`/`Message` (decode JSON), dedupe by `clientKey`/`serverId`.
- [x] T010 Bump `lib/core/data/cache/app_database.dart` — register `Conversations` + `Messages` tables + `MessagingDao`; `schemaVersion` **8→9**; additive migration (`m.createTable(conversations); m.createTable(messages)`), no backfill; add `MessagingDao.clearUserScoped()` to `AppDatabase.clearUserScoped()`.

### Repository + remote source + fakes

- [x] T011 `MessagingRepository` interface in `lib/core/data/messaging/messaging_repository.dart` — `Stream<List<Conversation>> watchConversations()`; `Result<void> refreshConversations()`; `Stream<List<Message>> watchThread(id)`; `Result<CursorPage<Message>> loadHistory(id, cursor?)`; `Result<Message> sendText/sendPhoto/sendSharedPost/sendSticker(...)` (optimistic + `clientKey`); `Result<void> retrySend(clientKey)`; `Result<void> markRead(id, upToMessageId)`; `void emitTyping(id, {bool started})`; `Result<Conversation> openOrStartConversation(userId)`; `Result<CursorPage<UserSummary>> searchPeople(query)`.
- [x] T012 `MessagingRemoteDataSource` in `lib/core/data/messaging/messaging_remote_data_source.dart` — `ApiClient` calls per [contracts/messaging-api.md](contracts/messaging-api.md) (Idempotency-Key=`clientKey` on send; open-or-start on POST `/conversations`); returns typed DTOs.
- [x] T013 `MessagingRepositoryImpl` `@LazySingleton(as: MessagingRepository, env: ['real'])` in `lib/core/data/messaging/messaging_repository_impl.dart` — send via REST (R1) writing the optimistic outbox row first then reconciling to `sent`(+serverId)/`failed`; history upserts into `MessagingDao`; thread/list are reactive `.watch()` reads; `emitTyping`/`markRead` emit `TypingStart/Stop`/`ConversationRead` over `RealtimeClient`; `Result`/`FailureMapper`; photo send uses `MediaUploadService` (#007) then sends `{mediaId}`.
- [x] T014 `FakeMessagingRepository` `@LazySingleton(as: MessagingRepository, env: ['fake'])` in `lib/core/data/messaging/fake_messaging_repository.dart` — in-memory graph: several seeded conversations (one unread, one with an online participant, one empty) + threads; optimistic send with `clientKey`; drives `FakeRealtimeClient` to script inbound `message.new`/`delivered`/`read`/`typing`/`presence`; fail-next + offline-queue seams for rollback/flush tests; **no fixed wall-clock** (inject a clock / pass timestamps).

### Realtime wiring (the socket goes live)

- [x] T015 `RealtimeConnectionManager` `@LazySingleton` in `lib/core/services/realtime/realtime_connection_manager.dart` — `connect()` (reads the access token from `TokenStore` → `RealtimeClient.connect`), `disconnect()`; re-attach token + trigger outbox flush on reconnect; expose the `connectionState` stream for the quiet offline affordance (R2).
- [x] T016 `MessagingRealtimeService` `@LazySingleton` in `lib/core/services/realtime/messaging_realtime_service.dart` — single subscriber to `RealtimeClient.events`: `message.new` → upsert `Messages` + bump `Conversations` (dedupe by `serverId`/`clientKey`; skip malformed with redacted warn); `message.delivered`/`message.read` → `advanceDelivery`; `typing` → transient typing stream (auto-expire ~4 s); `presence.update` → transient presence map/stream; expose `typingFor(conversationId)` + `presenceFor(userId)` streams for the Cubits (R3).
- [x] T016a [P] `MessagingBadge` core seam `@LazySingleton` in `lib/core/services/messaging/messaging_badge.dart` — watches `MessagingDao.watchConversations()` and exposes an `unreadConversationCount` stream (count of conversations with `unreadCount>0`) consumed by `BottomNav`/`SidebarRail` `badges:{message:N}`. Keeps the Messages-tab badge a **`core→core`** read so `core` never imports `features/messaging` (Constitution XI; mirrors the #011 `SavedTabSlot` seam pattern). Depends on T009.
- [x] T017 Wire lifecycle in `lib/core/services/session/session_controller.dart` — on session authenticated → `RealtimeConnectionManager.connect()`; on logout/forced-logout → `disconnect()` (the existing `clearUserScoped()` now also wipes messaging via T010). No feature import.

### Build + foundational tests

- [x] T018 Run `dart run build_runner build --delete-conflicting-outputs`; verify DI resolves `MessagingRepository` (`env:['fake']` for the app; `['real']` annotated), `RealtimeConnectionManager`, `MessagingRealtimeService`, and the drift **v9** schema compiles.
- [x] T019 [P] `MessagingDao` test in `test/core/data/cache/messaging_dao_test.dart` (`test()`, real in-memory `AppDatabase`) — upsert/watch emits (conversations desc, thread asc), `advanceDelivery`, `pendingOutbox` filters `sending`/`failed`, `markConversationRead`, dedupe by `clientKey`/`serverId`, `clearUserScoped` wipes both tables; **v8→v9 migration** `createTable` succeeds.
- [x] T020 [P] `MessagingRealtimeService` test in `test/core/services/realtime/messaging_realtime_service_test.dart` — `FakeRealtimeClient` emits `message.new` → message upserted + conversation bumped; **same event twice → exactly one message (SC-004)**; `delivered`/`read` advance state; `typing`/`presence` decorate the transient streams + auto-expire; malformed `message.new` skipped (no crash).
- [x] T021 [P] `FakeMessagingRepository` test in `test/core/data/messaging/fake_messaging_repository_test.dart` — seeded list/threads; optimistic send → `sent`; **retried failed send = one message (SC-003)**; offline-queue flush on reconnect (SC-006); `openOrStartConversation` returns existing (no dup, SC-007); `searchPeople`.

**Checkpoint**: data slice + drift v9 + live realtime wiring build + fakes green → user stories can proceed.

---

## Phase 3: US1 — Conversation list (P1) 🎯 MVP

**Goal**: The **Messages** tab opens Screen 25 — a list of 1-1 conversations (newest-activity first) with avatar+online dot, name (bold unread), last-message/typing preview, timestamp, unread marker, an active-now rail, in-list search, and a `+` new-message entry; the Messages tab shows an unread badge; renders offline-from-cache.

**Independent test**: Seed conversations (one unread, one "typing", one online); open the tab; verify ordering, unread emphasis + tab badge, preview/typing cue, active-now rail, in-list search, `+` entry, and offline-from-cache + reconcile.

- [x] T022 [US1] `conversations_usecases.dart` in `lib/features/messaging/domain/usecases/` — `WatchConversations` (drift v9 `watchConversations` decorated with typing/presence streams), `LoadConversations` (background `refreshConversations`), `SearchConversations(query)` (in-list filter).
- [x] T023 [US1] `ConversationsCubit` + `ConversationsState` (freezed 4-state: `loaded(List<Conversation>, isOffline, query)`) in `lib/features/messaging/presentation/cubit/` — cache-first watch, background reconcile, typing/presence decoration, unread-badge derivation, in-list search, offline flag, error-retry.
- [x] T024 [P] [US1] `ConversationTile` widget in `lib/features/messaging/presentation/widgets/conversation_tile.dart` — `Avatar` + online dot (mint), name (bold when unread), `previewOrTyping` (typing in mint), relative time, unread dot; Semantics label.
- [x] T025 [P] [US1] `ActiveNowRail` widget in `lib/features/messaging/presentation/widgets/active_now_rail.dart` — horizontal online-contacts rail (avatars + online dot); Semantics.
- [x] T026 [US1] `ConversationsPage` in `lib/features/messaging/presentation/conversations_page.dart` — Screen 25 (TopBar with `+` → new message, `SearchBar`, `ActiveNowRail`, list of `ConversationTile`); empty/offline/error-retry states; tap a row → **push** the thread (`/messages/:id`) on phone. (Tablet select-in-pane is layered on in US5 T048 — no US1→US5 dependency.)
- [x] T027 [US1] Swap the Messages tab body from the #001 placeholder to host **`ConversationsPage` directly** (phone push flow) in `lib/core/router/app_router.dart` — US5 T048 later wraps it in `MessagingShell` for the tablet two-pane, so US1 stands alone. Wire the unread badge into `BottomNav`/`SidebarRail` `badges: {message: N}` from the **core `MessagingBadge` seam (T016a)** — a `core→core` read, so `core` never imports `features/messaging`.
- [x] T028 [P] [US1] `ConversationsCubit` tests in `test/features/messaging/conversations_cubit_test.dart` (`test()`/`blocTest`) — cache-first load, reconcile, typing/presence decoration, unread badge count, in-list search, offline flag, empty vs error.
- [x] T029 [P] [US1] `ConversationsPage` widget test in `test/features/messaging/conversations_page_test.dart` — **stub cubit** seeded `loaded`; rows render (unread bold + dot), active-now rail, `+` present, empty state (no real drift/socket).

**Checkpoint**: MVP — the conversation list is viewable end-to-end.

---

## Phase 4: US2 — 1-1 chat with realtime send & receive (P1)

**Goal**: Open a conversation → grouped bubbles (own gradient right / other surface-2 left); send text optimistically with delivery state `sending→sent→delivered→read`; inbound appends live; typing + presence; mark-read on view; offline queue flush + idempotent retry; history back-paging.

**Independent test**: Open a seeded thread; send text → optimistic + delivery advance; script an inbound reply → appends live; script typing/presence → indicator/header update; view → mark-read clears badge; drop connection → cache reads + queued send flush; retry → one message.

- [x] T030 [US2] `chat_usecases.dart` in `lib/features/messaging/domain/usecases/` — `WatchThread(id)`, `LoadHistory(id, cursor?)` (cursor `Message`), `SendText(id, body)` / `SendSticker` / `SendPhoto` / `SendSharedPost` (optimistic + `clientKey` + rollback→`failed`), `RetrySend(clientKey)`, `MarkRead(id, upToMessageId)`, `EmitTyping(id, {started})` (debounced).
- [x] T031 [US2] `ChatCubit` + `ChatState` (freezed 4-state over `PaginatedListCubit<Message>`; extended `loadedSending`/`loadedPaginating`) in `lib/features/messaging/presentation/cubit/` — watch thread + typing/presence streams; optimistic send + delivery advance; mark-read on view; history back-paging (no dupes/reorder); offline queue surfaced; error-retry.
- [x] T032 [P] [US2] `MessageBubble` widget in `lib/features/messaging/presentation/widgets/message_bubble.dart` — own = `gradient-brand` right / other = `surface-2` left, grouped by author/time; text + (photo/sticker slots wired in US3); Semantics.
- [x] T033 [P] [US2] `DeliveryStatus` widget in `lib/features/messaging/presentation/widgets/delivery_status.dart` — per-message `sending/sent/delivered/read/failed` indicator (icon/label via ARB), failed → tap-to-retry affordance; Semantics.
- [x] T034 [P] [US2] `TypingIndicator` widget in `lib/features/messaging/presentation/widgets/typing_indicator.dart` — animated dots; **Reduce-Motion → static**; Semantics "typing".
- [x] T035 [US2] `ChatComposer` widget in `lib/features/messaging/presentation/widgets/chat_composer.dart` — text field + send (emits typing debounced) + camera (photo, US3) + sticker glyph (US3) slots; `Message…` hint; Semantics on send/attach.
- [x] T036 [US2] `ChatPage` in `lib/features/messaging/presentation/chat_page.dart` — Screen 26 (TopBar: back + avatar + name + "Active now"[mint] + more; grouped `MessageBubble` list with `DeliveryStatus`; `TypingIndicator`; `ChatComposer`); mark-read on view; empty/loading/error-retry; nav-less push on phone (`/messages/:id`).
- [x] T037 [US2] Add `/messages/:id` route in `lib/core/router/app_router.dart` (nav-less push, validated) → `ChatPage`; `we36://messages/:id` deep-link.
- [x] T038 [P] [US2] `ChatCubit` tests in `test/features/messaging/chat_cubit_test.dart` — optimistic send → `sent`→`delivered`→`read` as receipts arrive (SC-002); **retried failed send = one message (SC-003)**; inbound append; mark-read clears unread (SC-005); **offline queue flush on reconnect (SC-006)**; history paging no dupes/reorder ≥5 pages; a malformed inbound renders no blank bubble.
- [x] T038a [P] [US2] Block/forbidden-enforcement test in `test/features/messaging/forbidden_send_test.dart` — a fake `forbidden` send to a blocked participant → `AppFailure.forbidden` → Toast + the outbox message marked `failed` (no retry loop); opening/continuing a conversation the backend forbids surfaces the block gracefully (not a crash). Asserts the client **invents no visibility rule** — it only reflects the backend verdict (FR-027). Seed the block via the `FakeMessagingRepository` fail-next seam.
- [x] T039 [P] [US2] `ChatPage` widget test in `test/features/messaging/chat_page_test.dart` — **stub cubit**; own/other bubbles align + group, delivery indicator, typing indicator, composer send enabled; empty state (no real drift/socket).

---

## Phase 5: US3 — Rich content: photo, shared post, stickers (P2)

**Goal**: Send a photo (pick→upload→send, no editor), a shared post/reel card (deep-links to #006/#008), and stickers (sticker tray); inbound rich messages render as their bubble type.

**Independent test**: Send a photo → uploads + photo bubble with progress/failure; share a post/reel → card deep-links, deleted target → unavailable; send a sticker → sticker bubble; inbound rich renders.

- [x] T040 [US3] Wire **photo** send in `ChatComposer`/`chat_usecases` — camera action → `PhotoLibraryService` single-pick → `MediaUploadService` compress+upload (#007) → `SendPhoto({mediaId})`; optimistic bubble shows local bytes + `uploadProgress`, then server media; failure → retry. Render photo in `MessageBubble` (bounded `cacheWidth`).
- [x] T041 [US3] Wire **shared post/reel** + **sticker**: `SharedPostCard` widget in `lib/features/messaging/presentation/widgets/shared_post_card.dart` (thumb + author from `PostRef`, tap → `AppRoutes.postDetail` (#006) / reel (#008); **unavailable** state on 404) rendered in `MessageBubble`; host the shipped **sticker tray** in `ChatComposer` (Screen 28) → `SendSticker(glyphId)` → sticker-glyph bubble. Add the **"share to DM"** entry from post/reel + the **"Message"** entry from profile (#010) via a `core/router`/DI seam (no cross-feature internals import).
- [x] T042 [P] [US3] Rich-content tests in `test/features/messaging/rich_content_test.dart` — `SendPhoto` optimistic+upload+failure; `SharedPostCard` deep-link + unavailable; `SendSticker` bubble; inbound photo/shared-post/sticker render (`chat_cubit` + widget, stub where UI).

---

## Phase 6: US4 — New message / start a conversation (P2)

**Goal**: `+` → compose (To: people search, suggested = follows/recents), single-select → open existing-or-new thread (no duplicate).

**Independent test**: `+` → search + suggestions; select new person → new thread; select existing → existing thread (no dup).

- [x] T043 [US4] `new_message_usecases.dart` in `lib/features/messaging/domain/usecases/` — `SearchPeople(query)` (reuse profile/discovery search; suggestions = follows + recents from the `Conversations` cache), `OpenOrStartConversation(userId)` (idempotent → existing-or-new, SC-007).
- [x] T044 [US4] `NewMessageCubit` + `NewMessageState` (freezed 4-state: `loaded(suggestions/results, query)`) in `lib/features/messaging/presentation/cubit/`.
- [x] T045 [US4] `NewMessagePage` in `lib/features/messaging/presentation/new_message_page.dart` — Screen 27 (`x` + "New message", "To:" + `SearchBar`, "Suggested" rows with `Avatar` + select) → on select `OpenOrStartConversation` → open the thread; `/messages/new` route (centered-mobile on tablet).
- [x] T046 [P] [US4] `NewMessageCubit` tests in `test/features/messaging/new_message_cubit_test.dart` — search + suggestions, open-existing vs start-new (no duplicate, SC-007).

---

## Phase 7: US5 — Tablet / iPad two-pane (P2)

**Goal**: At `≥700` render Messages as master/detail (list + chat); selecting a row swaps the detail pane **without a push**, sharing the phone Cubits; `<700` keeps push; new-message/sticker = centered-mobile.

**Independent test**: Wide layout → list + chat side by side, select swaps pane (no push), selected row highlighted, shared state; narrow → push.

- [x] T047 [US5] `MessagingShellCubit` + state in `lib/features/messaging/presentation/cubit/` — holds the selected conversation id for the two-pane (shared list↔detail selection).
- [x] T048 [US5] `MessagingShell` in `lib/features/messaging/presentation/messaging_shell.dart` — **replaces the direct `ConversationsPage` host from T027** as the Messages-tab body; `AppBreakpoints`/`LayoutBuilder`: `<700` phone push (`ConversationsPage` → pushed `ChatPage`, unchanged from US1); `≥700` `TwoPaneScaffold(master: ConversationsPage, detail: ChatPage)` driven by `MessagingShellCubit` (selection swaps the pane in place, selected row = `accent-soft`); both bind the same `ConversationsCubit`/`ChatCubit` (FR-022). New-message/sticker centered-mobile fallback.
- [x] T049 [P] [US5] `MessagingShell` widget test in `test/features/messaging/messaging_shell_test.dart` — **stub cubits**; wide surfaceSize → two panes + selection swaps detail (no push) + row highlight (SC-008); narrow → single pane push.

---

## Phase 8: US6 — Inclusive & adaptive (P2)

**Goal**: Harden US1–US5 — a11y labels, 2× text scale, light/dark, phone↔tablet reflow.

**Independent test**: Screen-reader labels on rows/bubbles/send/attach/presence; 2× scale no clip (light+dark); tablet two-pane vs phone push reflow.

- [x] T050 [P] [US6] a11y + text-scale + adaptive widget test in `test/features/messaging/a11y_adaptive_test.dart` — labels on `ConversationTile`/`MessageBubble`/`DeliveryStatus`/send/camera/sticker/presence; 2× scale no overflow (list + chat); phone push vs tablet two-pane reflow.
- [x] T051 [P] [US6] Goldens in `test/features/messaging/goldens/` — `ConversationTile` (unread + online), `MessageBubble` (own + other + photo + sticker), `SharedPostCard`, `TypingIndicator`, two-pane (light + dark).
- [x] T052 [US6] Verify relative-time + `CountFormatter`/unread badge abbreviate without overflow at 2× scale on the tile + chat header + tab badge.

---

## Phase 9: Polish & Cross-Cutting

- [x] T053 [P] Log-redaction test in `test/features/messaging/log_redaction_test.dart` — no `print`/`debugPrint`; no message bodies / tokens / media refs / participant handles logged (FR-026); realtime service logs are redacted.
- [x] T054 [P] Confirm all user messages route through `ToastService` (send/upload/mark-read/retry success + failure, block-forbidden ack, realtime-disconnected) — no `ScaffoldMessenger` (FR-025).
- [x] T055 [P] Quiet **offline/connecting affordance** — surface `RealtimeConnectionManager.connectionState` (`RtReconnecting`/`RtDisconnected`) as a thin non-blocking banner/label in the list + chat (read-only-usable degrade, Constitution VIII); `realtimeDisconnected` never a blocking error.
- [x] T056 [US2] Haptic on message sent (Constitution VII) via the shared haptic seam.
- [x] T057 Run pre-commit gate (`dart format .`, `flutter analyze` zero warnings, `flutter test` all pass, `dart run bloc_tools:bloc lint .`) + walk [quickstart.md](quickstart.md) US1–US6. **SC-003/004/005/006/007** automated coverage authoritative; on-device VoiceOver/TalkBack + rotation + long-thread memory profiling + real-socket smoke deferred to the **#015** release gate + dev-backend cutover (matches #004/#008/#009/#010/#011).

---

## Dependencies & Execution Order

- **Phase 1 (Setup)** → **Phase 2 (Foundational: models + drift v9 + realtime wiring + fakes)** block everything. Within Phase 2: T017 (session wiring) depends on T015; T016 depends on T009 (cache) + the shipped `RealtimeClient`; **T016a (badge seam) depends on T009** (core→core, parallel to T017); T018 (build) after T005–T017 (incl. T016a); tests T019–T021 after T018.
- **US1 (P1)** is the MVP (reads the conversations cache); depends only on Phase 2.
- **US2 (P1)** depends on Phase 2 (thread cache + realtime service + send path); independent of US1's widgets.
- **US3 (P2)** depends on US2 (`MessageBubble`/`ChatComposer` slots) + the #007 pipeline / sticker tray / deep-link targets.
- **US4 (P2)** depends on Phase 2 (`openOrStartConversation`/`searchPeople`) + US2 (opens into `ChatPage`).
- **US5 (P2)** depends on US1 + US2 (composes both pages into the two-pane).
- **US6 (P2)** hardens US1–US5 (do after they exist).
- **Polish** last.

## Parallel Opportunities

- Setup: T002/T003/T004 in parallel after T001.
- Foundational: T005/T006 parallel; T007/T008 parallel; T016a parallel to T017 (both after T009); T019/T020/T021 in parallel after the slice builds (T018).
- Within each story, `[P]` widget/test tasks run parallel to sibling widgets (different files).
- US1 and US2 can be built in parallel by two developers (disjoint files) once Phase 2 is done; US3→US4 chain after US2; US5 after US1+US2.

## Implementation Strategy

- **MVP = Phase 1 + Phase 2 + US1** (conversation list viewable, offline-capable) — but note US2 is also P1 and is the core value; ship US1+US2 together as the usable MVP, then layer US3 (rich content) → US4 (new message) → US5 (two-pane) → US6 (hardening) → Polish.
- Keep the app on DI `environment: 'fake'` (`FakeRealtimeClient` scripts inbound); reconcile `contracts/messaging-api.md` + `contracts/realtime-events.md` with the shipped B#012 before wiring `MessagingRepositoryImpl` (`env:['real']`) — in particular the 5 open questions (own-send echo? *delivered* real? conversations paginated? send field names? open-or-create route?).
