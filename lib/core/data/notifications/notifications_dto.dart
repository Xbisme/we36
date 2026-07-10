import 'package:we36/core/data/notifications/notification_entry.dart';

// Wire ↔ domain mappers for the B#013 notifications backend (source-verified
// against `backend/src/modules/notifications/dto`). `NotificationEntryDto` is
// grouped server-side (actors + actorCount); `target` is nullable (deleted /
// hidden). A malformed field degrades to a safe default rather than throwing
// (Constitution IX); an unrecognized enum → `unknown`.

/// Wire `NotificationType` name → client enum (tolerant; falls back to unknown).
NotificationType notificationTypeFromWire(String? name) {
  for (final t in NotificationType.values) {
    if (t.name == name) return t;
  }
  return NotificationType.unknown;
}

/// Wire target `kind` name → client enum (tolerant; falls back to unknown).
TargetKind targetKindFromWire(String? name) {
  for (final k in TargetKind.values) {
    if (k.name == name) return k;
  }
  return TargetKind.unknown;
}

/// Map a wire `ActorCardDto` to [ActorCard].
ActorCard actorCardFromDto(Map<String, dynamic> json) => ActorCard(
  id: json['id'] as String? ?? '',
  username: json['username'] as String?,
  displayName: json['displayName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
);

/// Map a wire `NotificationTargetDto` (nullable) to [NotificationTarget].
NotificationTarget? notificationTargetFromDto(Map<String, dynamic>? json) {
  if (json == null) return null;
  final id = json['id'] as String?;
  if (id == null || id.isEmpty) return null;
  return NotificationTarget(
    kind: targetKindFromWire(json['kind'] as String?),
    id: id,
    postId: json['postId'] as String?,
    thumbnailUrl: json['thumbnailUrl'] as String?,
  );
}

/// Map a wire `NotificationEntryDto` to a [NotificationEntry].
NotificationEntry notificationEntryFromDto(Map<String, dynamic> json) {
  final rawActors = json['actors'];
  final actors = <ActorCard>[];
  if (rawActors is List) {
    for (final a in rawActors) {
      if (a is Map) actors.add(actorCardFromDto(a.cast<String, dynamic>()));
    }
  }
  final createdAt =
      DateTime.tryParse(json['createdAt'] as String? ?? '')?.toUtc() ??
      DateTime.utc(2026);
  return NotificationEntry(
    id: json['id'] as String? ?? '',
    type: notificationTypeFromWire(json['type'] as String?),
    actors: actors,
    actorCount: (json['actorCount'] as num?)?.toInt() ?? actors.length,
    target: notificationTargetFromDto(
      (json['target'] as Map?)?.cast<String, dynamic>(),
    ),
    isRead: json['isRead'] as bool? ?? false,
    createdAt: createdAt,
    updatedAt:
        DateTime.tryParse(json['updatedAt'] as String? ?? '')?.toUtc() ??
        createdAt,
  );
}

/// Body for `POST /devices` — `{platform, token}`. [platform] ∈ `ios|android`.
Map<String, dynamic> registerDeviceBody(String platform, String token) => {
  'platform': platform,
  'token': token,
};
