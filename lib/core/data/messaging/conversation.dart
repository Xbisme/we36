import 'package:freezed_annotation/freezed_annotation.dart';
// Full import (not `show UserSummary`) so the generated nested copyWith can see
// `$UserSummaryCopyWith` from post.freezed.dart.
import 'package:we36/core/data/feed/post.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

/// One 1-1 conversation in the Messages list (#012). The one canonical cached
/// copy per conversation (Constitution IX), read by the list, the tab badge, and
/// the tablet two-pane master. [isTyping] and [participantOnline] are **transient**
/// (decorated at read time from the realtime presence/typing streams — never
/// persisted), so they default false when loaded from cache.
@freezed
abstract class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    required UserSummary participant,
    required DateTime lastActivityAt,
    @Default(0) int unreadCount,
    String? lastMessagePreview,
    @Default(false) bool isTyping,
    @Default(false) bool participantOnline,
  }) = _Conversation;

  const Conversation._();

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  /// Has unread messages (drives the row emphasis + tab badge).
  bool get hasUnread => unreadCount > 0;
}
