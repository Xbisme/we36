# Contract: Realtime (Socket.IO) Events

Transport: **Socket.IO v4** (`socket_io_client ^3.1.6`) — matches the backend
`@nestjs/platform-socket.io` gateway. Auth: access token in the connect `auth` payload. One
connection; per-user subscription isolation. **Scaffold-only in #002** (typed surface + fake bus;
no feature wiring). See [`realtime-events.md`](../../../backend/specs/001-service-foundation/contracts/realtime-events.md).

## Connection lifecycle

`RealtimeConnectionState`: `connecting · connected · reconnecting · disconnected({AppFailure? cause})`
exposed as `Stream<RealtimeConnectionState>`. Reconnect + exponential backoff + heartbeat are
Socket.IO built-ins — **configured**, not reimplemented (`reconnection`, `reconnectionDelay`,
`reconnectionDelayMax`, `randomizationFactor`). Auth-rejected connect → `disconnected` (no tight loop).

## Event catalog (typed `RealtimeEvent`)

### Outbound (client → server)
| Constant (`SocketEvents`) | Wire name | Payload (minimal in #002) |
|---|---|---|
| `messageSend` | `message.send` | `{ conversationId, body, idempotencyKey }` |
| `typingStart` | `typing.start` | `{ conversationId }` |
| `typingStop` | `typing.stop` | `{ conversationId }` |
| `conversationRead` | `conversation.read` | `{ conversationId, upToMessageId }` |
| `presencePing` | `presence.ping` | `{}` |

### Inbound (server → client)
| Constant | Wire name | Payload (minimal in #002) |
|---|---|---|
| `messageNew` | `message.new` | `{ conversationId, message }` |
| `messageDelivered` | `message.delivered` | `{ conversationId, messageId }` |
| `messageRead` | `message.read` | `{ conversationId, messageId }` |
| `typing` | `typing` | `{ conversationId, userId }` |
| `presenceUpdate` | `presence.update` | `{ userId, online, lastSeen }` |
| `notificationNew` | `notification.new` | `{ notification }` |

## Rules

- Event names come from `core/constants/socket_events.dart` constants — never inline literals.
- DM semantics (persist-before-push, REST catch-up) are the backend's; the client just consumes.
- All #002 tests use a **fake** `RealtimeClient` (in-memory event bus) — never a live socket.
- When realtime is down, HTTP reads keep working; `realtimeDisconnected` surfaces quietly.
