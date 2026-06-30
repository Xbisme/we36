import 'package:we36/core/constants/socket_events.dart';
import 'package:we36/core/domain/app_failure.dart';

/// Realtime connection lifecycle (Constitution VIII). The app stays usable
/// read-only over HTTP while not `connected`.
sealed class RealtimeConnectionState {
  const RealtimeConnectionState();
}

class RtConnecting extends RealtimeConnectionState {
  const RtConnecting();
}

class RtConnected extends RealtimeConnectionState {
  const RtConnected();
}

class RtReconnecting extends RealtimeConnectionState {
  const RtReconnecting();
}

class RtDisconnected extends RealtimeConnectionState {
  const RtDisconnected({this.cause});
  final AppFailure? cause;
}

/// Outbound events (client → server). `name` comes from [SocketEvents] — never an
/// inline literal.
sealed class OutboundEvent {
  const OutboundEvent();
  String get name;
  Map<String, dynamic> get data;
}

class MessageSend extends OutboundEvent {
  const MessageSend({
    required this.conversationId,
    required this.body,
    required this.idempotencyKey,
  });
  final String conversationId;
  final String body;
  final String idempotencyKey;

  @override
  String get name => SocketEvents.messageSend;
  @override
  Map<String, dynamic> get data => {
    'conversationId': conversationId,
    'body': body,
    'idempotencyKey': idempotencyKey,
  };
}

class TypingStart extends OutboundEvent {
  const TypingStart(this.conversationId);
  final String conversationId;
  @override
  String get name => SocketEvents.typingStart;
  @override
  Map<String, dynamic> get data => {'conversationId': conversationId};
}

class TypingStop extends OutboundEvent {
  const TypingStop(this.conversationId);
  final String conversationId;
  @override
  String get name => SocketEvents.typingStop;
  @override
  Map<String, dynamic> get data => {'conversationId': conversationId};
}

class ConversationRead extends OutboundEvent {
  const ConversationRead({
    required this.conversationId,
    required this.upToMessageId,
  });
  final String conversationId;
  final String upToMessageId;
  @override
  String get name => SocketEvents.conversationRead;
  @override
  Map<String, dynamic> get data => {
    'conversationId': conversationId,
    'upToMessageId': upToMessageId,
  };
}

class PresencePing extends OutboundEvent {
  const PresencePing();
  @override
  String get name => SocketEvents.presencePing;
  @override
  Map<String, dynamic> get data => const {};
}

/// Inbound events (server → client). Parsed from the wire by [InboundEvent.parse].
sealed class InboundEvent {
  const InboundEvent();

  /// Map a wire (name, payload) to a typed inbound event; unknown names become
  /// [UnknownInbound] rather than throwing (forward-compatible).
  static InboundEvent parse(String name, Map<String, dynamic> data) {
    switch (name) {
      case SocketEvents.messageNew:
        return MessageNew(
          conversationId: data['conversationId'] as String? ?? '',
          message:
              (data['message'] as Map?)?.cast<String, dynamic>() ?? const {},
        );
      case SocketEvents.messageDelivered:
        return MessageDelivered(
          conversationId: data['conversationId'] as String? ?? '',
          messageId: data['messageId'] as String? ?? '',
        );
      case SocketEvents.messageRead:
        return MessageReadEvent(
          conversationId: data['conversationId'] as String? ?? '',
          messageId: data['messageId'] as String? ?? '',
        );
      case SocketEvents.typing:
        return TypingInbound(
          conversationId: data['conversationId'] as String? ?? '',
          userId: data['userId'] as String? ?? '',
        );
      case SocketEvents.presenceUpdate:
        return PresenceUpdate(
          userId: data['userId'] as String? ?? '',
          online: data['online'] as bool? ?? false,
        );
      case SocketEvents.notificationNew:
        return NotificationNew(
          (data['notification'] as Map?)?.cast<String, dynamic>() ?? const {},
        );
      default:
        return UnknownInbound(name, data);
    }
  }
}

class MessageNew extends InboundEvent {
  const MessageNew({required this.conversationId, required this.message});
  final String conversationId;
  final Map<String, dynamic> message;
}

class MessageDelivered extends InboundEvent {
  const MessageDelivered({
    required this.conversationId,
    required this.messageId,
  });
  final String conversationId;
  final String messageId;
}

class MessageReadEvent extends InboundEvent {
  const MessageReadEvent({
    required this.conversationId,
    required this.messageId,
  });
  final String conversationId;
  final String messageId;
}

class TypingInbound extends InboundEvent {
  const TypingInbound({required this.conversationId, required this.userId});
  final String conversationId;
  final String userId;
}

class PresenceUpdate extends InboundEvent {
  const PresenceUpdate({required this.userId, required this.online});
  final String userId;
  final bool online;
}

class NotificationNew extends InboundEvent {
  const NotificationNew(this.notification);
  final Map<String, dynamic> notification;
}

class UnknownInbound extends InboundEvent {
  const UnknownInbound(this.name, this.data);
  final String name;
  final Map<String, dynamic> data;
}
