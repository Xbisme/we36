import 'package:injectable/injectable.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/data/messaging/messaging_repository.dart';
import 'package:we36/core/data/pagination/cursor_page.dart';
import 'package:we36/core/domain/result.dart';

/// Reactive read of one conversation's thread (#012 US2), oldest→newest, from the
/// cache (renders offline, FR-014).
@injectable
class WatchThread {
  const WatchThread(this._repo);
  final MessagingRepository _repo;

  Stream<List<Message>> call(String conversationId) =>
      _repo.watchThread(conversationId);
}

/// Load an older page of history into the cache (back-paging, FR-015).
@injectable
class LoadHistory {
  const LoadHistory(this._repo);
  final MessagingRepository _repo;

  Future<Result<CursorPage<Message>>> call(
    String conversationId, {
    String? cursor,
  }) => _repo.loadHistory(conversationId, cursor: cursor);
}

/// Send a text message (optimistic + idempotent, FR-009).
@injectable
class SendText {
  const SendText(this._repo);
  final MessagingRepository _repo;

  Future<Result<Message>> call(String conversationId, String body) =>
      _repo.sendText(conversationId, body);
}

/// Send a photo message (pick→upload→send; the mediaId is already finalized).
@injectable
class SendPhoto {
  const SendPhoto(this._repo);
  final MessagingRepository _repo;

  Future<Result<Message>> call(String conversationId, String mediaId) =>
      _repo.sendPhoto(conversationId, mediaId);
}

/// Send a shared post/reel card.
@injectable
class SendSharedPost {
  const SendSharedPost(this._repo);
  final MessagingRepository _repo;

  Future<Result<Message>> call(String conversationId, PostRef ref) =>
      _repo.sendSharedPost(conversationId, ref);
}

/// Send a sticker glyph.
@injectable
class SendSticker {
  const SendSticker(this._repo);
  final MessagingRepository _repo;

  Future<Result<Message>> call(String conversationId, String glyphId) =>
      _repo.sendSticker(conversationId, glyphId);
}

/// Retry a failed send (same client key → exactly one message, SC-003).
@injectable
class RetrySend {
  const RetrySend(this._repo);
  final MessagingRepository _repo;

  Future<Result<Message>> call(String clientKey) => _repo.retrySend(clientKey);
}

/// Mark a conversation read up to a message id (clears unread + badge, FR-013).
@injectable
class MarkRead {
  const MarkRead(this._repo);
  final MessagingRepository _repo;

  Future<Result<void>> call(String conversationId, String upToMessageId) =>
      _repo.markRead(conversationId, upToMessageId);
}

/// Emit a typing signal (debounced by the caller, FR-012).
@injectable
class EmitTyping {
  const EmitTyping(this._repo);
  final MessagingRepository _repo;

  void call(String conversationId, {required bool started}) =>
      _repo.emitTyping(conversationId, started: started);
}
