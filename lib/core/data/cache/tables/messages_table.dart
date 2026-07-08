import 'package:drift/drift.dart';

/// The persisted per-conversation message cache (#012) — the one canonical copy
/// per message (Constitution IX), and also the **outbox**: an outgoing message is
/// written first with `deliveryState='sending'` (serverId null) and flushed on
/// reconnect (R4/SC-006). Keyed by [clientKey] (the client-generated id +
/// Idempotency-Key + reconcile/dedupe key, R8). Ordered within a conversation by
/// [createdAt] (oldest→newest). Wiped on logout (Constitution I/IX). Drift's row
/// class is `CachedMessage` to avoid clashing with the domain model.
@DataClassName('CachedMessage')
class Messages extends Table {
  /// Client-generated id — local primary key + idempotency + reconcile key.
  TextColumn get clientKey => text()();

  /// Server id — null while pending (an unsent/failed outbox row).
  TextColumn get serverId => text().nullable()();

  /// Owning conversation id (filter + order key).
  TextColumn get conversationId => text()();

  /// Sender user id.
  TextColumn get authorId => text()();

  /// Author == current user.
  BoolColumn get isMine => boolean()();

  /// `MessageKind` name (`text|photo|sharedPost|sticker`).
  TextColumn get kind => text()();

  /// JSON-encoded `MessageContent`.
  TextColumn get contentJson => text()();

  /// Creation timestamp (thread order).
  DateTimeColumn get createdAt => dateTime()();

  /// `DeliveryState` name; `sending`/`failed` rows are the outbox.
  TextColumn get deliveryState => text()();

  @override
  Set<Column<Object>> get primaryKey => {clientKey};
}
