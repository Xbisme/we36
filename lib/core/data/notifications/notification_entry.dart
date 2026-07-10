import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_entry.freezed.dart';
part 'notification_entry.g.dart';

/// The kind of social activity a notification represents (#013, B#013). Wire
/// values match the backend `NotificationType` enum exactly (camelCase). There is
/// **no `message`** kind — DM activity is push-only and never enters this feed.
/// [unknown] is a forward-compat fallback for an unrecognized wire value.
enum NotificationType {
  like,
  comment,
  reply,
  mention,
  follow,
  followRequest,
  followAccepted,
  unknown,
}

/// What a notification points at. [unknown] is a forward-compat fallback.
enum TargetKind { post, reel, comment, user, unknown }

/// A minimal actor identity for rendering a notification row (#013). [avatarUrl]
/// is currently always null server-side — render a name/initial fallback.
@freezed
abstract class ActorCard with _$ActorCard {
  const factory ActorCard({
    required String id,
    String? username,
    String? displayName,
    String? avatarUrl,
  }) = _ActorCard;

  const ActorCard._();

  factory ActorCard.fromJson(Map<String, dynamic> json) =>
      _$ActorCardFromJson(json);

  /// Best-effort display handle (falls back through display name → id).
  String get handle => username ?? displayName ?? id;
}

/// The object a notification points at (#013). Null on the entry ⇒ the target was
/// deleted / is no longer visible ⇒ a degraded, non-tappable row (FR-006).
@freezed
abstract class NotificationTarget with _$NotificationTarget {
  const factory NotificationTarget({
    @JsonKey(unknownEnumValue: TargetKind.unknown) required TargetKind kind,
    required String id,
    String? postId,
    String? thumbnailUrl,
  }) = _NotificationTarget;

  const NotificationTarget._();

  factory NotificationTarget.fromJson(Map<String, dynamic> json) =>
      _$NotificationTargetFromJson(json);

  bool get hasThumbnail => (thumbnailUrl ?? '').isNotEmpty;
}

/// One grouped notification-feed entry (#013). Grouping + read state are
/// server-owned — the client renders, it never regroups. [actorCount] is the
/// total distinct actors ("and N others" = actorCount - 1); [actors] is the most
/// recent slice. [updatedAt] (latest activity) drives feed order + time bucket;
/// [isRead] (server: latest activity newer than lastReadAt) drives the unread
/// accent independent of the time section.
@freezed
abstract class NotificationEntry with _$NotificationEntry {
  const factory NotificationEntry({
    required String id,
    @JsonKey(unknownEnumValue: NotificationType.unknown)
    required NotificationType type,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(<ActorCard>[]) List<ActorCard> actors,
    @Default(1) int actorCount,
    NotificationTarget? target,
    @Default(false) bool isRead,
  }) = _NotificationEntry;

  const NotificationEntry._();

  factory NotificationEntry.fromJson(Map<String, dynamic> json) =>
      _$NotificationEntryFromJson(json);

  /// The most-recent actor (drives the leading avatar + bold name).
  ActorCard? get leadActor => actors.isEmpty ? null : actors.first;

  /// Count of additional actors beyond the lead ("and N others"); 0 when single.
  int get andOthersCount => actorCount > 1 ? actorCount - 1 : 0;

  /// Whether the row carries a follow-relationship action (follow-back / route).
  bool get isFollowType =>
      type == NotificationType.follow ||
      type == NotificationType.followAccepted ||
      type == NotificationType.followRequest;

  /// A degraded, non-tappable row (its target is gone / not visible).
  bool get isDegraded => target == null && !isFollowType;
}
