import 'package:flutter/widgets.dart';

/// Cross-feature seam (Constitution XI): opens the #011 "Save to collection"
/// sheet for a post/reel from anywhere (feed, post detail, reels) without those
/// features importing `features/collections`. The concrete impl is registered by
/// the collections feature (`@LazySingleton(as: SaveToCollectionLauncher)`).
// ignore: one_member_abstracts — a DI-registered seam, not a callback type.
abstract interface class SaveToCollectionLauncher {
  /// Open the "Save to collection" bottom sheet for [postId].
  Future<void> open(BuildContext context, String postId);
}
