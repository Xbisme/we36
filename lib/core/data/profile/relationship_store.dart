import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:we36/core/data/discovery/search_results.dart';

/// The **one canonical** viewer↔account follow relationship, held in memory and
/// reactive (#010, Constitution IX). Keyed by userId; the profile and the
/// followers/following lists both `watch` + `apply` here, so an optimistic follow
/// on one surface reflects on the other without a manual refresh (SC-004).
///
/// Session-scoped by design: relationships are server-authoritative and
/// re-fetched on every profile open, so cross-restart persistence adds no value
/// (tradeoff recorded in plan.md — precedent: #005 `OwnStoryStore`). Cleared on
/// logout.
@lazySingleton
class RelationshipStore {
  final Map<String, ViewerRelationship> _current = {};
  final Map<String, StreamController<ViewerRelationship>> _controllers = {};

  StreamController<ViewerRelationship> _controllerFor(String userId) =>
      _controllers.putIfAbsent(
        userId,
        StreamController<ViewerRelationship>.broadcast,
      );

  /// The current relationship for [userId], or null if not yet seeded.
  ViewerRelationship? current(String userId) => _current[userId];

  /// Reactive read — emits the current value (if any) then every change.
  Stream<ViewerRelationship> watch(String userId) async* {
    final existing = _current[userId];
    if (existing != null) yield existing;
    yield* _controllerFor(userId).stream;
  }

  /// Populate/replace from a fetched profile or list row.
  void seed(String userId, ViewerRelationship relationship) {
    if (_current[userId] == relationship) return;
    _current[userId] = relationship;
    _controllerFor(userId).add(relationship);
  }

  /// Optimistically mutate (follow/unfollow/withdraw + rollback) and notify.
  /// No-op if the account has never been seeded.
  void apply(
    String userId,
    ViewerRelationship Function(ViewerRelationship current) mutator,
  ) {
    final cur = _current[userId];
    if (cur == null) return;
    final next = mutator(cur);
    if (next == cur) return;
    _current[userId] = next;
    _controllerFor(userId).add(next);
  }

  /// Drop all relationships (on logout — session-scoped).
  void clear() {
    for (final c in _controllers.values) {
      unawaited(c.close());
    }
    _controllers.clear();
    _current.clear();
  }
}
