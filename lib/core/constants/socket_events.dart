/// Centralized Socket.IO event names (Constitution VIII) — never inline literals.
/// Mirrors the backend realtime catalog
/// (`backend/specs/001-service-foundation/contracts/realtime-events.md`).
/// Wired by #012 (DM) / #013 (notifications); #002 ships the typed surface only.
abstract final class SocketEvents {
  // Outbound: client → server
  static const String messageSend = 'message.send';
  static const String typingStart = 'typing.start';
  static const String typingStop = 'typing.stop';
  static const String conversationRead = 'conversation.read';
  static const String presencePing = 'presence.ping';

  // Inbound: server → client
  static const String messageNew = 'message.new';
  static const String messageDelivered = 'message.delivered';
  static const String messageRead = 'message.read';
  static const String typing = 'typing';
  static const String presenceUpdate = 'presence.update';
  static const String notificationNew = 'notification.new';
}
