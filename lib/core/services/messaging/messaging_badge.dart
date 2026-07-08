import 'package:injectable/injectable.dart';
import 'package:we36/core/data/messaging/messaging_repository.dart';

/// The Messages-tab unread badge source (#012). Watches the canonical
/// conversation list from [MessagingRepository] and exposes the count of
/// conversations with unread messages for the `BottomNav`/`SidebarRail`
/// `badges: {message: N}`. Living in `core/services` keeps the badge a
/// **core→core** read so `core/presentation` never imports `features/messaging`
/// (Constitution XI; mirrors the #011 `SavedTabSlot` seam pattern).
@lazySingleton
class MessagingBadge {
  MessagingBadge(this._repository);

  final MessagingRepository _repository;

  /// The number of conversations with unread messages, updated reactively.
  Stream<int> get unreadConversationCount => _repository
      .watchConversations()
      .map((list) => list.where((c) => c.hasUnread).length);
}
