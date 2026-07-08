import 'package:we36/core/data/feed/post.dart' show UserSummary, renditionUrl;
import 'package:we36/core/data/messaging/conversation.dart';
import 'package:we36/core/data/messaging/message.dart';

/// Wire ↔ domain mappers for the B#012 backend (reconciled with the shipped dev
/// backend 2026-07-08 via `/docs-json`). `MessageDto` fields are **flat**
/// (`senderId`/`body`/`media`/`sharedPost`/`stickerId`); a `ConversationDto`
/// carries `otherUser` + `lastMessage` (a `MessagePreviewDto`). The wire message
/// `kind` enum is `text|media|sharedPost|sticker` — **`media` maps to the client
/// `MessageKind.photo`**. A malformed field degrades to a safe default rather
/// than throwing (Constitution IX).

/// Wire message-kind name (`media` for a photo) → client [MessageKind].
MessageKind kindFromWire(String? name) => switch (name) {
  'media' => MessageKind.photo,
  'sharedPost' => MessageKind.sharedPost,
  'sticker' => MessageKind.sticker,
  _ => MessageKind.text,
};

/// Client [MessageKind] → wire kind name (photo → `media`).
String kindToWire(MessageKind kind) => switch (kind) {
  MessageKind.photo => 'media',
  MessageKind.sharedPost => 'sharedPost',
  MessageKind.sticker => 'sticker',
  MessageKind.text => 'text',
};

/// Map a wire `UserSummaryDto` to the shared [UserSummary].
UserSummary userSummaryFromDto(Map<String, dynamic>? u) {
  final m = u ?? const {};
  return UserSummary(
    id: m['id'] as String? ?? '',
    isVerified: m['isVerified'] as bool? ?? false,
    username: m['username'] as String?,
    displayName: m['displayName'] as String?,
    avatarUrl: m['avatarUrl'] as String?,
  );
}

/// Map a wire `MessageDto` (flat) to a [Message]. [isMine] is decided by the
/// caller (the realtime service treats a `message.new` echo as inbound; the
/// send-response reconcile sets it mine).
Message messageFromWire(
  Map<String, dynamic> json, {
  required bool isMine,
  String? conversationId,
}) {
  final kind = kindFromWire(json['kind'] as String?);
  final serverId = json['id'] as String?;
  return Message(
    // The backend does not echo a client key; key the row by the server id.
    clientKey: json['clientKey'] as String? ?? serverId ?? 'srv-$serverId',
    serverId: serverId,
    conversationId: conversationId ?? json['conversationId'] as String? ?? '',
    authorId: json['senderId'] as String? ?? '',
    isMine: isMine,
    kind: kind,
    content: contentFromWire(kind, json),
    createdAt:
        DateTime.tryParse(json['createdAt'] as String? ?? '')?.toUtc() ??
        DateTime.utc(2026),
    // Inbound messages carry no sender-facing delivery state; treat as read.
    deliveryState: DeliveryState.read,
  );
}

/// Build a [MessageContent] from a flat wire `MessageDto` per [kind].
MessageContent contentFromWire(MessageKind kind, Map<String, dynamic> json) {
  switch (kind) {
    case MessageKind.text:
      return MessageContent.text(body: json['body'] as String? ?? '');
    case MessageKind.photo:
      final media = (json['media'] as Map?)?.cast<String, dynamic>();
      return MessageContent.photo(
        mediaId: media?['id'] as String?,
        url: renditionUrl(
          (media?['variants'] as Map?)?.cast<String, dynamic>(),
        ),
      );
    case MessageKind.sharedPost:
      return MessageContent.sharedPost(ref: _sharedPostRef(json['sharedPost']));
    case MessageKind.sticker:
      return MessageContent.sticker(
        glyphId: json['stickerId'] as String? ?? '',
      );
  }
}

/// Map a wire `SavedItemDto` (kind-tagged post/reel, == `ExploreItem` shape) to
/// a [PostRef]. Null / not-viewable → an unavailable ref.
PostRef _sharedPostRef(Object? shared) {
  final s = (shared as Map?)?.cast<String, dynamic>();
  if (s == null) {
    return const PostRef(id: '', kind: PostKind.post, unavailable: true);
  }
  final isReel = s['kind'] == 'reel';
  final inner = ((s['post'] ?? s['reel']) as Map?)?.cast<String, dynamic>();
  final author = (inner?['author'] as Map?)?.cast<String, dynamic>();
  return PostRef(
    id: inner?['id'] as String? ?? s['id'] as String? ?? '',
    kind: isReel ? PostKind.reel : PostKind.post,
    thumbUrl: _thumbUrl(inner),
    authorName: author?['username'] as String?,
    unavailable: inner == null,
  );
}

/// Best-effort thumbnail url from a post/reel's first media rendition.
String? _thumbUrl(Map<String, dynamic>? inner) {
  final media = inner?['media'];
  final first = (media is List && media.isNotEmpty) ? media.first : null;
  final variants = (first as Map?)?['variants'];
  return renditionUrl((variants as Map?)?.cast<String, dynamic>());
}

/// Map a wire `ConversationDto` to a [Conversation]. Presence/`isRequest`/`muted`
/// are not modelled (typing/presence ride the transient realtime streams).
Conversation conversationFromWire(Map<String, dynamic> json) {
  final last = (json['lastMessage'] as Map?)?.cast<String, dynamic>();
  return Conversation(
    id: json['id'] as String? ?? '',
    participant: userSummaryFromDto(
      (json['otherUser'] as Map?)?.cast<String, dynamic>(),
    ),
    lastActivityAt:
        DateTime.tryParse(
          (json['lastActivityAt'] ?? last?['createdAt']) as String? ?? '',
        )?.toUtc() ??
        DateTime.utc(2026),
    unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
    lastMessagePreview: last?['preview'] as String?,
  );
}
