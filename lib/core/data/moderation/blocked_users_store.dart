import 'dart:async';

import 'package:injectable/injectable.dart';

/// The **one canonical** set of accounts the signed-in person has blocked
/// (#014, Constitution IX/XI), held in memory and reactive. Feed, search,
/// messaging, and notifications read this core store to filter blocked authors
/// so a block takes effect in-session with no reload (FR-014) — features depend
/// on this core seam, never on `features/settings`.
///
/// Session-scoped: cleared on logout via `SessionController` (FR-033).
@lazySingleton
class BlockedUsersStore {
  final Set<String> _blocked = <String>{};
  final StreamController<Set<String>> _controller =
      StreamController<Set<String>>.broadcast();

  /// Reactive read — emits the current set immediately, then on every change.
  Stream<Set<String>> get blockedIds async* {
    yield Set<String>.unmodifiable(_blocked);
    yield* _controller.stream;
  }

  bool isBlocked(String userId) => _blocked.contains(userId);

  /// Current snapshot (unmodifiable).
  Set<String> get current => Set<String>.unmodifiable(_blocked);

  /// Populate from a fetched blocked-accounts page.
  void seed(Iterable<String> userIds) {
    _blocked
      ..clear()
      ..addAll(userIds);
    _emit();
  }

  void add(String userId) {
    if (_blocked.add(userId)) _emit();
  }

  void remove(String userId) {
    if (_blocked.remove(userId)) _emit();
  }

  void _emit() => _controller.add(Set<String>.unmodifiable(_blocked));

  /// Drop all blocked ids (on logout — session-scoped).
  void clear() {
    if (_blocked.isEmpty) return;
    _blocked.clear();
    _emit();
  }
}
