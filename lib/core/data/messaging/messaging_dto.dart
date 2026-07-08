import 'package:we36/core/data/feed/post.dart' show UserSummary;
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/data/messaging/message.dart';

/// Wire ↔ domain mappers for the DERIVED B#012 shapes (see
/// `contracts/messaging-api.md` / `realtime-events.md`). Shared by the remote
/// data source (REST DTOs) and the realtime service (socket `message.new`
/// payloads) so the mapping lives in one place — reconcile at dev-backend
/// cutover. A malformed field degrades to a safe default rather than throwing
/// (Constitution IX).

/// Map a wire `MessageDto` to a [Message]. [isMine] is decided by the caller
/// (the realtime service treats `message.new` as inbound = not mine).
Message messageFromWire(
  Map<String, dynamic> json, {
  required bool isMine,
  String? conversationId,
}) {
  final kindName = json['kind'] as String? ?? 'text';
  final kind = MessageKind.values.asNameMap()[kindName] ?? MessageKind.text;
  final content =
      (json['content'] as Map?)?.cast<String, dynamic>() ?? const {};
  final stateName = json['deliveryState'] as String? ?? 'sent';
  return Message(
    clientKey:
        json['clientKey'] as String? ??
        json['id'] as String? ??
        'srv-${json['id']}',
    serverId: json['id'] as String?,
    conversationId: conversationId ?? json['conversationId'] as String? ?? '',
    authorId: json['authorId'] as String? ?? '',
    isMine: isMine,
    kind: kind,
    content: contentFromWire(kind, content),
    createdAt:
        DateTime.tryParse(json['createdAt'] as String? ?? '')?.toUtc() ??
        DateTime.utc(2026),
    deliveryState:
        DeliveryState.values.asNameMap()[stateName] ?? DeliveryState.sent,
  );
}

/// Map a wire message `content` object (kind-tagged) to a [MessageContent].
MessageContent contentFromWire(MessageKind kind, Map<String, dynamic> content) {
  switch (kind) {
    case MessageKind.text:
      return MessageContent.text(body: content['body'] as String? ?? '');
    case MessageKind.photo:
      return MessageContent.photo(
        mediaId: content['mediaId'] as String?,
        url: content['url'] as String?,
      );
    case MessageKind.sharedPost:
      return MessageContent.sharedPost(
        ref: PostRef(
          id: content['postId'] as String? ?? content['id'] as String? ?? '',
          kind: (content['postKind'] as String?) == 'reel'
              ? PostKind.reel
              : PostKind.post,
          thumbUrl: content['thumbUrl'] as String?,
          authorName: content['authorName'] as String?,
        ),
      );
    case MessageKind.sticker:
      return MessageContent.sticker(
        glyphId: content['glyphId'] as String? ?? '',
      );
  }
}

/// Map a wire `ConversationDto` to a [Conversation]. Transient typing/presence
/// default false (decorated later from the realtime streams).
Conversation conversationFromWire(Map<String, dynamic> json) {
  final last = (json['lastMessage'] as Map?)?.cast<String, dynamic>();
  final p = (json['participant'] as Map?)?.cast<String, dynamic>() ?? const {};
  return Conversation(
    id: json['id'] as String? ?? '',
    participant: UserSummary(
      id: p['id'] as String? ?? '',
      isVerified: p['isVerified'] as bool? ?? false,
      username: p['username'] as String?,
      displayName: p['displayName'] as String?,
      avatarUrl: p['avatarUrl'] as String?,
    ),
    lastActivityAt:
        DateTime.tryParse(
          (last?['createdAt'] ?? json['lastActivityAt']) as String? ?? '',
        )?.toUtc() ??
        DateTime.utc(2026),
    unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
    lastMessagePreview: last?['preview'] as String?,
  );
}
