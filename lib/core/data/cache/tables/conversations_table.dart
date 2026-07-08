import 'package:drift/drift.dart';

/// The persisted 1-1 conversation list (#012) — the one canonical conversation
/// copy (Constitution IX), cached so the Messages tab opens to content on a cold
/// start while offline (spec FR-007). Each row is one `Conversation`; ordered by
/// [lastActivityAt] (newest first). Reconciled with the server + realtime events;
/// wiped on logout (Constitution I/IX). Drift's row class is `CachedConversation`
/// to avoid clashing with the domain model. Transient typing/presence are NOT
/// stored (decorated at read time from the realtime streams).
@DataClassName('CachedConversation')
class Conversations extends Table {
  /// Server conversation id — the primary key.
  TextColumn get id => text()();

  /// JSON-encoded participant `UserSummary`.
  TextColumn get participantJson => text()();

  /// One-line preview of the last message (null for a brand-new empty thread).
  TextColumn get lastMessagePreview => text().nullable()();

  /// Last-activity timestamp — the list order key (desc).
  DateTimeColumn get lastActivityAt => dateTime()();

  /// Count of unread messages (drives the row marker + the tab badge).
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
