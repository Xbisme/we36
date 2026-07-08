import 'package:flutter/widgets.dart';
import 'package:we36/core/data/messaging/message.dart' show PostRef;

/// Cross-feature entry seam into Direct Messages (#012, Constitution XI). Other
/// features (profile, post, reels) reach messaging **only** through this core
/// abstraction — `getIt<MessagingLauncher>()` — never by importing
/// `features/messaging` internals. The implementation lives in
/// `features/messaging` (mirrors the #011 `SavedTabSlot` pattern).
abstract interface class MessagingLauncher {
  /// Open (or start) a 1-1 conversation with [userId] and navigate to it — the
  /// "Message" action on a profile (#010).
  Future<void> openConversationWith(BuildContext context, String userId);

  /// Share a post/reel into a conversation — the "share to DM" action from a
  /// post (#006) / reel (#008). Opens the compose picker carrying [ref].
  void shareToDm(BuildContext context, PostRef ref);
}
