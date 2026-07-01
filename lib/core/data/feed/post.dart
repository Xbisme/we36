import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

/// Media kind — image or video (B#004 / B#003 projection). #004 renders image
/// segments only; video inline is reels (#008).
enum MediaKind { image, video }

/// Media processing status. Media may still be `processing` when first embedded
/// in a post; the client renders progressively.
enum MediaStatus { pending, processing, ready, failed }

/// Compact author / tagged-user projection (B#004 `UserSummary`).
@freezed
abstract class UserSummary with _$UserSummary {
  const factory UserSummary({
    required String id,
    required bool isVerified,
    String? username,
    String? displayName,
    String? avatarUrl,
  }) = _UserSummary;

  factory UserSummary.fromJson(Map<String, dynamic> json) =>
      _$UserSummaryFromJson(json);
}

/// B#003 media projection (status + delivery variants). `variants` holds the
/// delivery renditions/thumbnail (present when `ready`); #004 uses the display
/// image variant of `media[0]`.
@freezed
abstract class Media with _$Media {
  const factory Media({
    required String id,
    required MediaKind kind,
    required MediaStatus status,
    int? width,
    int? height,
    int? durationMs,
    Map<String, dynamic>? variants,
  }) = _Media;

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
}

/// One ordered carousel item — a reference to a [Media] plus its position.
/// #004 renders `position == 0` only (carousel deferred to #007).
@freezed
abstract class PostMedia with _$PostMedia {
  const factory PostMedia({
    required int position,
    required Media media,
  }) = _PostMedia;

  factory PostMedia.fromJson(Map<String, dynamic> json) =>
      _$PostMediaFromJson(json);
}

/// Canonical place (B#004) — label only in #004.
@freezed
abstract class Place with _$Place {
  const factory Place({
    required String id,
    required String name,
    double? lat,
    double? lng,
    String? externalId,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}

/// A feed post with its media, engagement counts, and the viewer's own
/// like/save state (B#004 `Post`). One canonical cached representation shared
/// across every screen (Constitution IX). Field names are camelCase matching the
/// backend JSON; ids are string UUIDv7.
@freezed
abstract class Post with _$Post {
  const factory Post({
    required String id,
    required UserSummary author,
    required List<PostMedia> media,
    required List<String> hashtags,
    required List<UserSummary> taggedUsers,
    required bool commentsDisabled,
    required int likeCount,
    required int saveCount,
    required int commentCount,
    required bool viewerHasLiked,
    required bool viewerHasSaved,
    required DateTime createdAt,
    String? caption,
    Place? location,
  }) = _Post;

  const Post._();

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  /// The first image media's delivery URL (display variant → thumb fallback),
  /// or null while processing / when the first item is not a ready image.
  /// #004 renders this single image (FR-008).
  String? get primaryImageUrl {
    if (media.isEmpty) return null;
    final sorted = [...media]..sort((a, b) => a.position.compareTo(b.position));
    final first = sorted.first.media;
    if (first.kind != MediaKind.image || first.status != MediaStatus.ready) {
      return null;
    }
    final v = first.variants;
    if (v == null) return null;
    final display = v['display'] ?? v['thumb'] ?? v['url'];
    return display is String ? display : null;
  }

  /// All ready-image delivery URLs in carousel order (#007 multi-photo posts).
  /// Empty while media is still processing or has no delivery variants.
  List<String> get imageUrls {
    final sorted = [...media]..sort((a, b) => a.position.compareTo(b.position));
    final urls = <String>[];
    for (final item in sorted) {
      final md = item.media;
      if (md.kind != MediaKind.image || md.status != MediaStatus.ready) {
        continue;
      }
      final v = md.variants;
      if (v == null) continue;
      final display = v['display'] ?? v['thumb'] ?? v['url'];
      if (display is String) urls.add(display);
    }
    return urls;
  }
}

/// Returned by like/unlike/save/unsave so the client reconciles optimistic UI
/// with server-authoritative counts (B#004 `EngagementState`).
@freezed
abstract class EngagementState with _$EngagementState {
  const factory EngagementState({
    required String postId,
    required int likeCount,
    required int saveCount,
    required bool viewerHasLiked,
    required bool viewerHasSaved,
  }) = _EngagementState;

  factory EngagementState.fromJson(Map<String, dynamic> json) =>
      _$EngagementStateFromJson(json);
}
