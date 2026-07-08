import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// The Direct-Messages data seam (#012, B#012 contract; Constitution VIII/IX).
/// Screens consume this via use cases — never HTTP or the socket directly. A real
/// impl (`env:['real']`) and an in-memory fake (`env:['fake']`, the one that runs)
/// exist. Conversations + threads are the one canonical cached copy (reactive
/// drift cache); sends are optimistic + idempotent (client [Message.clientKey]);
/// realtime inbound is folded into the cache by `MessagingRealtimeService`, and
/// typing/presence ride transient streams exposed here.
abstract interface class MessagingRepository {
  /// Reactive conversation list (newest-activity first) — the render source for
  /// the Messages tab. Cache-first (renders offline, FR-007).
  Stream<List<Conversation>> watchConversations();

  /// Reconcile the cached conversation list with the server. Errors surface
  /// without clearing the cache.
  Future<Result<void>> refreshConversations();

  /// Reactive thread for [conversationId] (oldest→newest) — the chat render
  /// source. Cache-first.
  Stream<List<Message>> watchThread(String conversationId);

  /// Load an older page of history (`GET …/messages`, cursor) into the cache.
  Future<Result<CursorPage<Message>>> loadHistory(
    String conversationId, {
    String? cursor,
  });

  /// Send a text message (optimistic + idempotent via a client key). Returns the
  /// persisted message (or the failed optimistic row on error).
  Future<Result<Message>> sendText(String conversationId, String body);

  /// Send a photo message (pick→upload→send; the optimistic bubble shows upload
  /// progress). [mediaId] is the finalized upload id.
  Future<Result<Message>> sendPhoto(String conversationId, String mediaId);

  /// Send a shared post/reel card.
  Future<Result<Message>> sendSharedPost(String conversationId, PostRef ref);

  /// Send a sticker glyph.
  Future<Result<Message>> sendSticker(String conversationId, String glyphId);

  /// Retry a previously-failed send (re-POSTs with the same [clientKey] →
  /// exactly one message, SC-003).
  Future<Result<Message>> retrySend(String clientKey);

  /// Mark a conversation read up to [upToMessageId] — clears the unread marker +
  /// tab badge and signals read to the peer (emits `conversation.read`).
  Future<Result<void>> markRead(String conversationId, String upToMessageId);

  /// Emit a typing signal (debounced by the caller). Fire-and-forget over the
  /// socket; safe to call when disconnected.
  void emitTyping(String conversationId, {required bool started});

  /// Open the existing 1-1 conversation with [userId], or start a new one
  /// (idempotent → no duplicate, SC-007).
  Future<Result<Conversation>> openOrStartConversation(String userId);

  /// People search for the new-message composer (follows/recents suggested when
  /// [query] is empty).
  Future<Result<CursorPage<UserSummary>>> searchPeople(String query);
}
