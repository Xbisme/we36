import 'package:flutter/widgets.dart';

/// Cross-feature render seam (Constitution XI). The profile's **owner-only**
/// Saved tab body (#011) is provided by the collections feature through this
/// abstraction, so `features/profile` renders it via `getIt<SavedTabSlot>()`
/// without importing `features/collections`. The concrete impl is registered by
/// the collections feature (`@LazySingleton(as: SavedTabSlot)`).
// ignore: one_member_abstracts — a DI-registered seam, not a callback type.
abstract interface class SavedTabSlot {
  /// Build the Saved-collections view (its own `BlocProvider`/cubit).
  Widget build(BuildContext context);
}
