# Contract — Realtime `notification.new` (client usage)

**SOURCE-VERIFIED** against `backend/src/jobs/notification-fanout.processor.ts` + `backend/src/modules/notifications/notifications.service.ts` (`buildLivePayload`) + `notifications.constants.ts` (`WS_NOTIFICATION_NEW = 'notification.new'`). This is the **second** live use of the #002 `RealtimeClient` (after #012 DM). The connection lifecycle is already owned by `RealtimeConnectionManager` / `SessionController` — #013 adds only a new inbound subscriber.

## Event name
`notification.new` — already declared client-side as `SocketEvents.notificationNew` (#002). Reused as-is, no new constant.

## Direction & delivery
Server → client only (no outbound counterpart). Emitted `emitToUsers([recipientId], 'notification.new', payload)` **after** the durable feed row is persisted (persist-before-deliver), for feed kinds only (DM kinds are push-only, never emit this). Suppressed server-side by self/block/preference checks — the client renders whatever arrives.

## Payload (the fix)
```jsonc
{
  "entry": { /* full NotificationEntryDto — see notifications-api.md */ },
  "unreadCount": 7
}
```

⚠ **#002 scaffold mismatch (correct in #013)**: `realtime_event.dart` currently parses `notification.new` as `NotificationNew(data['notification'] ?? {})` — there is **no `notification` key**, so it always yields `{}`. Change to:
```dart
case SocketEvents.notificationNew:
  return NotificationNew(
    entry: (data['entry'] as Map?)?.cast<String, dynamic>() ?? const {},
    unreadCount: data['unreadCount'] as int? ?? 0,
  );
```
and widen the event: `class NotificationNew extends InboundEvent { const NotificationNew({required this.entry, required this.unreadCount}); final Map<String,dynamic> entry; final int unreadCount; }`. `MessagingRealtimeService` already ignores `NotificationNew` (`case UnknownInbound() || NotificationNew(): break;`) — leave that untouched; the new `NotificationsRealtimeService` handles it.

## Client handling (`NotificationsRealtimeService`, `@lazySingleton`)
Sole subscriber to `RealtimeClient.events` for `NotificationNew`:
1. Parse `entry` → `NotificationEntry` (tolerant DTO decode; malformed → skip with a redacted warn, one bad event never crashes — Constitution IX).
2. `NotificationsDao.upsertEntry(entry)` — **dedupe by `entry.id`** (a reconnect replay / an already-seen group updates in place → exactly once, SC-004 / FR-013).
3. Push `unreadCount` to `NotificationsBadge` (badge + any open feed update **silently** — no banner/toast, clarified Q4).

The socket is never touched by Cubits/widgets (Constitution VIII). When realtime is down, the feed + badge render from the drift cache + last-known count and reconcile on reconnect / next refresh (FR-012).

## Testing
`FakeRealtimeClient.emitInbound(NotificationNew(entry: …, unreadCount: …))` drives the fold in `test()` (real async) — typed event in → cache/badge out; no live socket (Constitution XII). Duplicate emit asserts exactly-once (no double row, no double count).
