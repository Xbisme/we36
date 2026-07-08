import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

/// Max message text length (spec assumption; validated on send). Reconcile with
/// B#012 server config at cutover.
const int kMessageTextMaxLength = 2000;

/// The kind of a chat message (#012). Payload lives in [MessageContent].
enum MessageKind { text, photo, sharedPost, sticker }

/// Per-message delivery lifecycle (#012, R5). `sending → sent → delivered →
/// read`, plus `failed` for a rejected/timed-out send. Meaningful for the
/// sender's own messages; the client collapses `delivered → sent` if the backend
/// omits *delivered* (clarified). Inbound (other-authored) messages are treated
/// as read on view.
enum DeliveryState { sending, sent, delivered, read, failed }

/// The kind of content a shared-post message points at.
enum PostKind { post, reel }

/// A lightweight reference a `sharedPost` message carries so its card can render
/// a preview + deep-link to the underlying post (#006) / reel (#008) without
/// embedding a full copy (Constitution IX). [unavailable] renders a graceful
/// "content unavailable" state when the target was removed.
@freezed
abstract class PostRef with _$PostRef {
  const factory PostRef({
    required String id,
    required PostKind kind,
    String? thumbUrl,
    String? authorName,
    @Default(false) bool unavailable,
  }) = _PostRef;

  factory PostRef.fromJson(Map<String, dynamic> json) =>
      _$PostRefFromJson(json);
}

/// The kind-specific payload of a [Message]. A freezed sealed union so the
/// message row stores exactly one shape; serialized to `contentJson` in the
/// drift cache (the discriminator round-trips locally — the remote source maps
/// the wire `content` to this).
@freezed
sealed class MessageContent with _$MessageContent {
  /// A text message.
  const factory MessageContent.text({required String body}) = TextContent;

  /// A photo message. While sending, [localPath] + [uploadProgress] drive the
  /// optimistic bubble; once uploaded, [mediaId]/[url] point at server media.
  const factory MessageContent.photo({
    String? mediaId,
    String? localPath,
    String? url,
    double? uploadProgress,
  }) = PhotoContent;

  /// A shared post/reel card.
  const factory MessageContent.sharedPost({required PostRef ref}) =
      SharedPostContent;

  /// A sticker/emoji glyph.
  const factory MessageContent.sticker({required String glyphId}) =
      StickerContent;

  factory MessageContent.fromJson(Map<String, dynamic> json) =>
      _$MessageContentFromJson(json);
}

/// One message in a 1-1 conversation (#012). Also the outbox row: an outgoing
/// message is created optimistically with [deliveryState] `sending` + a
/// client-generated [clientKey] (the Idempotency-Key + local primary key +
/// reconcile/dedupe key, R8); on POST success it reconciles in place to `sent`
/// with a [serverId]. One canonical copy per message in the drift cache.
@freezed
abstract class Message with _$Message {
  const factory Message({
    required String clientKey,
    required String conversationId,
    required String authorId,
    required bool isMine,
    required MessageKind kind,
    required MessageContent content,
    required DateTime createdAt,
    required DeliveryState deliveryState,
    String? serverId,
  }) = _Message;

  const Message._();

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  /// Still in flight (optimistic, not yet acked).
  bool get isPending => deliveryState == DeliveryState.sending;

  /// The send failed and can be retried.
  bool get isFailed => deliveryState == DeliveryState.failed;

  /// A one-line preview for the conversation list (rich kinds show a label; the
  /// display string is localized at the call site via the [kind]).
  String? get previewBody => switch (content) {
    TextContent(:final body) => body,
    _ => null,
  };
}
