# Implementation Plan: Direct Messages (Realtime)

**Branch**: `012-direct-messages` | **Date**: 2026-07-07 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/012-direct-messages/spec.md`

## Summary

Build the We36 client **private 1-1 messaging** surface — the **Messages** tab (Screens 25–28) — as a new `features/messaging/` presentation layer over a new `core/data/messaging/` data slice, and **wire the live realtime channel for the first time**: the `RealtimeClient` / typed `OutboundEvent`/`InboundEvent` catalog + `SocketEvents` shipped inert in #002 now drive real conversation/typing/presence/read flow. Users get a **conversation list** (Screen 25 — newest-activity-first rows with online dot, unread emphasis, last-message/typing preview, active-now rail, in-list search, `+` new-message, Messages-tab unread badge), a **1-1 chat** (Screen 26 — grouped bubbles, **optimistic + idempotent** send with per-message delivery state `sending→sent→delivered→read`, live inbound append, live typing + coarse presence, mark-read on view, cursor history paging), **rich content** (Screen 28 — a quick pick→upload→send **photo** reusing the #007 pipeline, a **shared post/reel card** that deep-links to #006/#008, **stickers** via the shipped sticker tray), **new message** compose (Screen 27 — people search over follows/recents, single-select → opens existing-or-new thread, no duplicate), the **tablet/iPad two-pane** master/detail (list + chat side-by-side, selection swaps the detail pane without a push, sharing the phone Cubits), and inclusive/adaptive hardening.

**Realtime wiring**: a new `@lazySingleton` **`RealtimeConnectionManager`** connects the shipped `SocketIoRealtimeClient` on session-authenticated / disconnects on logout (driven by `SessionController`), and a `@lazySingleton` **`MessagingRealtimeService`** subscribes to `RealtimeClient.events` and folds inbound socket events (`message.new` / `message.delivered` / `message.read` / `typing` / `presence.update`) into the canonical drift cache + transient presence/typing streams — so **Cubits/widgets never touch the socket** (Constitution VIII). **Send goes over REST** (`POST …/messages`, returning the persisted message → `sent` + server id, idempotency via the shipped interceptor); the socket is **inbound-authoritative** (echoes + receipts) — see [research.md](research.md) R1. Conversations **and** message threads are persisted (**drift schema v8→v9**, two new tables) so the list and open threads render offline-from-cache (FR-007/FR-014); the `Messages` table doubles as the **outbox** (a `sending`/`failed` row with a `clientKey` is flushed on reconnect). Every source has an in-memory fake and a **`FakeRealtimeClient`** scripts inbound events for hermetic tests. **No new pub dependency** (`socket_io_client` already shipped at #002).

## Technical Context

**Language/Version**: Dart 3.12.2 / Flutter 3.44.4 (repo baseline).

**Primary Dependencies**: `flutter_bloc` (4-state freezed Cubits), `get_it`+`injectable` (DI, `env:['real'|'fake']`), `go_router` (Messages tab + nav-less `/messages/:id` chat push on phone; two-pane on tablet), `dio` via the shared `ApiClient` + idempotency/auth interceptors + `FailureMapper`, **`socket_io_client`** via the shipped `RealtimeClient` (wired live here), `freezed`+`json_serializable`, `drift` (two new tables + DAOs, reactive `.watch()`), `cached_network_image` (bounded photo/avatar decode), `lucide_icons_flutter` via `AppIcon`, `intl` via relative-time/count formatters. Reuses `core/services` #007 media pipeline (`MediaUploadService`/`PhotoLibraryService`) for photo messages, `core/data/discovery.ExploreItem` + `core/data/reels`/`core/data/feed` refs for shared-post/reel cards + deep-links (#006/#008), `core/data/profile.UserSummary`/`ProfileRepository` search + the `Message` profile entry (#010), the shipped **sticker tray** + `TwoPaneScaffold` (#001), `CursorPage<T>` + `PaginatedListCubit<T>` (#002). **No new pub dependency.**

**Storage**: **drift schema v8→v9** — two new tables: **`Conversations`** (id, participant `UserSummary` json, last-message preview, lastActivityAt, unreadCount, ordering) and **`Messages`** (localId=`clientKey`, nullable serverId, conversationId, authorId, isMine, kind, payload json, createdAt, deliveryState) — the latter also the **outbox** (unsent rows carry `sending`/`failed`). Both are user-scoped and **wiped on logout** via `clearUserScoped()` (wired into `SessionController._db.clearUserScoped()`). **Presence + typing are transient** (in-memory streams from `MessagingRealtimeService`, never persisted). Message history is a live cursor page **backed by** the `Messages` cache (one canonical copy per message; dedupe by `clientKey`/serverId).

**Testing**: `flutter_test` + `bloc_test` + `mocktail` (fakes) + golden tests. Cubit/logic: conversation-list load + offline cache + unread badge + typing/presence decoration; chat load + history paging; **optimistic send + idempotent retry (exactly one message, SC-003) + delivery-state advance**; **inbound dedupe (exactly once, SC-004)**; mark-read clears badge (SC-005); offline queue flush on reconnect (SC-006); new-message open-existing-vs-new (no dup, SC-007); rich-message render (photo/shared-post/sticker). **Realtime is tested against `FakeRealtimeClient`** (typed event in → cache/state out — Constitution XII), never a live socket. Widget tests seed **stub cubits** with a fixed 4-state — never real drift/socket I/O inside `testWidgets` (the #009 gate learning); any clock-dependent fake seam is frozen (the post-#10 time-bomb learning). Log-redaction (no message bodies/tokens/media refs) + a11y/text-scale/adaptive + goldens (conversation row, chat bubbles own/other, shared-post card, two-pane, light+dark).

**Target Platform**: iOS + Android phones + iPad/Android tablets. Phone (`<700`) = push nav (list → chat); tablet/iPad (`≥700`) = **two-pane master/detail** (list + chat, selection swaps the pane, no push); new-message + sticker tray = centered-mobile fallback.

**Project Type**: Mobile app (Flutter client) over a custom REST + Socket.IO backend; client-only feature (backend B#012 assumed; app runs `env:['fake']` for hermetic tests).

**Performance Goals**: conversation list + thread render from cache in < 1 s on open (SC-001); optimistic send appears in < 16 ms (local state); 60 fps thread scroll with bounded memory over ≥5 history pages; photo decode at a bounded `cacheWidth`; one realtime connection (no per-screen sockets).

**Constraints**: Cubits/widgets never touch `dio`/the socket (repositories + `MessagingRealtimeService` only); one canonical cached copy per conversation + message (dedupe by `clientKey`/serverId — no per-Cubit drift); sends idempotent (client `clientKey`) + optimistic with a `failed`→retry path; realtime degrades to read-only (`realtimeDisconnected` surfaced quietly); the client enforces no block/visibility rule the backend has not (FR-027); all messages via Toast; `AppLogger` redacted (no bodies/tokens/media refs); semantic tokens only; `lib/core/` must not import `lib/features/`; blocked-user send is a server verdict reflected client-side.

**Scale/Scope**: 4 designed screens (25–28); ~4–5 Cubits (`conversations`, `chat`, `new_message`, `messaging_shell` for two-pane selection; presence/typing via a service not a Cubit); 1 new repository (+ real + fake) + 1 remote data source; 2 new drift tables/DAOs (v9); 2 new `@lazySingleton` core services (`RealtimeConnectionManager`, `MessagingRealtimeService`); ~4 new client models (`Conversation`, `Message`(+`MessageKind` payloads), reuse `UserSummary`/`ExploreItem`); reuses the #007 upload pipeline, sticker tray, two-pane primitive, and profile search verbatim.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **I Privacy/Safety & Trust**: No message body/token/media ref in logs (log-redaction test, FR-026). Blocking is a **server verdict reflected client-side** — the client starts/continues no conversation the backend forbids (FR-027); no requests-inbox gating in v1.0 (clarified). Photo permission requested contextually via the shipped #007 pipeline. ✅
- **II Media discipline**: Photo messages reuse the #007 client-compress + upload pipeline (progress/cancel); inbound photos decode at a bounded `cacheWidth`; no video in v1.0 DM. Threads paginate (cursor), the list never holds every decoded image. ✅
- **III BLoC 4-state**: Events plain / states freezed `initial/loading/loaded/error`; extended variants prefix the base (`loadedSending`, `loadedPaginating`). Use Cases injected into Cubits, not repos. Page-scoped `BlocProvider`; `@injectable` screen cubits; `@lazySingleton` repo/DAO/services (`RealtimeConnectionManager`, `MessagingRealtimeService`). Cubit↔Cubit only via shared repo/service/streams. ✅
- **IV/VIII One API client + one realtime socket behind repos**: All HTTP via the shared `ApiClient`; **one** realtime connection via the shipped `RealtimeClient`, owned by `RealtimeConnectionManager`, fanned out by `MessagingRealtimeService`. Widgets/Cubits touch neither `dio` nor the socket. New REST endpoints + all socket event names live in `core/constants/{api_endpoints,socket_events}.dart` — no inline literals. Single-flight refresh + centralized `FailureMapper` reused. ✅
- **V Result/AppFailure**: Repo returns `Result<T>`; `realtimeDisconnected`/`messageFailed`/`uploadFailed`/`forbidden` map centrally → Toast. try/catch forbidden in Cubits. ✅
- **VI Design discipline**: Reuse `TopBar`, `Avatar`(+online dot), `SearchBar`, `ActionSheet`, `AppDialog`, the sticker tray, `TwoPaneScaffold`, `CountFormatter`/relative-time; semantic tokens only; brand `gradient-brand` reserved for **own** message bubbles + send CTA (design §Component), neutral chrome elsewhere; presence dot = `mint`. Reduce-Motion: typing dots degrade to static. ✅
- **VII Adaptive & native**: Two-pane master/detail on `≥700` (selection swaps pane, no push) via the #001 primitive; phone push on `<700`; centered-mobile fallback for new-message/sticker; iPad split-view reflow + rotation. Haptic on message sent. ✅
- **IX Data integrity / optimistic / one canonical copy**: Optimistic send with a client `clientKey` → idempotent (retry = exactly one, SC-003); inbound deduped by `clientKey`/serverId (exactly once, SC-004). **One canonical copy** per conversation + message in the reactive drift cache — list, chat, badge, and two-pane all read it. Non-destructive additive v8→v9 migration; migration test covers v8→v9. Malformed inbound payloads skipped gracefully (one bad message MUST NOT crash the thread). ✅
- **X go_router**: New `AppRoutes.messages`/`messageThread(id)` + `we36://messages/:id` deep-link, validated. Chat is a nav-less pushed route on phone; the Messages tab is a `StatefulShellRoute` destination. ✅
- **XI Feature-first**: New `features/messaging/` + `core/data/messaging/` + two `core/services/` singletons + two `core/data/cache/` tables. `core/` never imports `features/`. Cross-feature reuse (media pipeline, profile search, shared-post/reel refs, sticker tray, two-pane) via **core types + DI + router** — no `features/<other>` internals import (the "Message" entry from a profile and the "share to DM" from post/reel route through `core/router` + DI seams). ✅
- **XII Testing**: Every repository + the realtime client have fakes; `FakeRealtimeClient` scripts inbound events (typed event in → state out); no live socket in CI. Widget tests seed stub cubits (no real drift/socket in `testWidgets`). ✅
- **XIII/XV Simplicity / deps**: **No new pub dependency** (`socket_io_client` shipped #002; media pipeline #007). Out-of-scope items (group chat, calls, reactions beyond stickers, edit/unsend, voice, requests-inbox, message push) are NOT built. ✅
- **XIV i18n**: All copy in EN+VI ARB; relative-time/count via shared `intl` helpers. ✅

**Result: PASS** — two deliberate choices justified in Complexity Tracking (two new drift tables incl. the message-outbox; REST-send with an inbound-authoritative socket).

## Project Structure

### Documentation (this feature)

```text
specs/012-direct-messages/
├── plan.md              # This file
├── research.md          # Phase 0 output (send-path, realtime wiring, presence, persistence, two-pane)
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/
│   ├── messaging-api.md      # Client-consumed B#012 REST subset (derived — reconcile w/ backend at cutover)
│   └── realtime-events.md     # Socket.IO event usage (the shipped SocketEvents catalog + payload shapes)
└── tasks.md             # /speckit.tasks output (later)
```

### Source Code (repository root)

```text
lib/core/constants/
├── api_endpoints.dart                    # EXTEND: conversations list/get/create, messages history/send, mark-read
└── socket_events.dart                     # (already has the DM catalog — reused as-is)

lib/core/services/realtime/               # NEW realtime wiring (the socket goes live here)
├── realtime_connection_manager.dart      # @LazySingleton — connect(token) on auth / disconnect on logout (SessionController-driven)
└── messaging_realtime_service.dart        # @LazySingleton — subscribes RealtimeClient.events → folds into cache + presence/typing streams

lib/core/data/messaging/                   # NEW data slice
├── conversation.dart                      # Conversation freezed (+ transient typing/online) + json DTO
├── message.dart                           # Message + MessageKind (text|photo|sharedPost|sticker) + DeliveryState + json DTO
├── messaging_repository.dart              # interface (Result<T>): watchConversations/refresh, watchThread/history, send(text|photo|sharedPost|sticker), markRead, startConversation, searchPeople
├── messaging_repository_impl.dart         # @LazySingleton(as:…, env:['real'])  → ApiClient(send/history) + MessagingDao(cache) + RealtimeClient(typing/read out)
├── fake_messaging_repository.dart         # @LazySingleton(as:…, env:['fake'])  → in-memory graph; drives FakeRealtimeClient inbound
└── messaging_remote_data_source.dart      # ApiClient calls → Result

lib/core/data/cache/
├── tables/conversations_table.dart        # NEW drift table (v9)
├── tables/messages_table.dart              # NEW drift table (v9) — also the outbox (clientKey PK, deliveryState)
└── daos/messaging_dao.dart                 # NEW DAO: watchConversations(), watchThread(id), upsert*, pendingOutbox(), markRead*, clearUserScoped()
   (app_database.dart: schemaVersion 8→9 + additive migration; register 2 tables + DAO; add DAO to clearUserScoped())

lib/features/messaging/
├── domain/usecases/
│   ├── conversations_usecases.dart        # WatchConversations / LoadConversations (refresh + unread) / SearchConversations
│   ├── chat_usecases.dart                 # WatchThread / LoadHistory (cursor) / SendText / SendPhoto / SendSharedPost / SendSticker / MarkRead / RetrySend / EmitTyping
│   └── new_message_usecases.dart          # SearchPeople (follows/recents) / OpenOrStartConversation
├── presentation/
│   ├── cubit/
│   │   ├── conversations_cubit(.dart/_state)     # list: watch drift + service streams (typing/presence/unread) — loaded(List<Conversation>, isOffline)
│   │   ├── chat_cubit(.dart/_state)              # one thread: watch drift + streams; optimistic send + delivery + typing + mark-read + history paging
│   │   ├── new_message_cubit(.dart/_state)       # compose people search + open/start
│   │   └── messaging_shell_cubit(.dart/_state)   # tablet two-pane: selected conversation id (shared list↔detail state)
│   ├── conversations_page.dart            # Screen 25 (list) — phone tab body
│   ├── chat_page.dart                     # Screen 26 (thread) — nav-less push (phone) / detail pane (tablet)
│   ├── new_message_page.dart              # Screen 27 (compose) — centered-mobile on tablet
│   ├── messaging_shell.dart               # adaptive: phone push vs tablet TwoPaneScaffold(list, chat)
│   └── widgets/
│       ├── conversation_tile.dart         # avatar+online, name(bold unread), preview/typing(mint), time, unread dot
│       ├── active_now_rail.dart           # horizontal online-contacts rail
│       ├── message_bubble.dart            # own(gradient right) / other(surface-2 left); text/photo/sticker
│       ├── shared_post_card.dart          # shared post/reel card bubble → deep-link (#006/#008); unavailable state
│       ├── delivery_status.dart           # sending/sent/delivered/read per-message indicator
│       ├── typing_indicator.dart          # animated dots (Reduce-Motion static)
│       └── chat_composer.dart             # text field + camera(photo) + sticker glyph + send; sticker tray host
└── (routes added to core/router/app_router.dart + AppRoutes; Messages tab body swapped from placeholder to conversations)

lib/core/services/session/session_controller.dart   # EXTEND: on authenticated → RealtimeConnectionManager.connect; on logout → disconnect (+ existing clearUserScoped now clears messaging)
```

**Structure Decision**: Feature-first (matches #004–#011). A new `features/messaging/` presentation layer over a thin `core/data/messaging/` slice, plus the **realtime wiring in `core/services/realtime/`** (the socket is a `core/` concern — Constitution VIII/XI — not a feature's). The Messages tab body (currently a placeholder from #001) is swapped to `MessagingShell`, which renders the phone push flow (`ConversationsPage` → pushed `ChatPage`) or the tablet `TwoPaneScaffold(ConversationsPage, ChatPage)` driven by `MessagingShellCubit`'s selected id — both binding the same `ConversationsCubit`/`ChatCubit`. Inbound realtime is folded into the canonical drift cache by `MessagingRealtimeService` so every surface (list, chat, badge, two-pane) reacts to one source; presence/typing ride transient streams. The "Message" entry from a profile (#010) and "share to DM" from a post/reel (#006/#008) route through `core/router` + DI seams — no cross-feature internals import.

## Complexity Tracking

| Choice | Why Needed | Simpler Alternative Rejected Because |
|--------|------------|-------------------------------------|
| **Two new drift tables** (`Conversations` + `Messages`), v8→v9 — vs #010's in-memory store | FR-007 + FR-014 require **both** the conversation list **and** open threads to render offline-from-cache, and the `Messages` table doubles as the **offline outbox** (a `sending`/`failed` row flushed on reconnect, SC-006). One canonical copy per conversation/message watched reactively by list + chat + badge + two-pane. | An in-memory store (like #010's `RelationshipStore`) cannot satisfy offline cold-start of threads or survive an app-kill with unsent messages (the outbox). Persisting is the #004/#009 precedent for canonical content. |
| **REST-send + inbound-authoritative socket** — send via `POST …/messages` (returns the persisted message), socket carries only inbound `message.new`/receipts/typing/presence | The shipped `RealtimeClient.send()` is fire-and-forget (no ack), so a socket-only send cannot return the server message id needed to reconcile the optimistic temp row and advance delivery state; REST reuses the shipped idempotency interceptor + `FailureMapper` and yields the persisted message = `sent`. See [research.md](research.md) R1. | Pure socket-send (using the shipped `MessageSend` outbound event) was rejected: without an ack it cannot reconcile the optimistic row or dedupe the echoed `message.new`, and it bypasses the centralized idempotency/error mapping. The `MessageSend` outbound event stays available for a future ack-based backend. |
| **Wiring the realtime socket live** (`RealtimeConnectionManager` + `MessagingRealtimeService`) — first feature to do so | #002 shipped the socket scaffold inert; DM is the first consumer and must own connect-on-auth/disconnect-on-logout + fan inbound events into the cache **without** letting Cubits touch the socket (Constitution VIII). | Letting the `ChatCubit` subscribe to `RealtimeClient` directly was rejected: it violates VIII (Cubits touching the socket) and would duplicate connection lifecycle across screens. One manager + one service centralizes it. |
