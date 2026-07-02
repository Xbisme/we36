import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/core/data/feed/post.dart';

part 'reel.freezed.dart';
part 'reel.g.dart';

/// A reel (a `Post` of `kind=reel` on the backend, B#007) with its single video,
/// engagement counts, and the viewer's own like/save state. Mirrors [Post] but
/// carries one [video] (not a carousel) plus an [isVideoReady] flag. Reuses the
/// shared [UserSummary]/[Media]/[Place]/[EngagementState] projections from the
/// feed slice (core→core; Constitution XI). One canonical cached representation
/// per reel (Constitution IX).
@freezed
abstract class Reel with _$Reel {
  const factory Reel({
    required String id,
    required UserSummary author,
    required Media video,
    required List<String> hashtags,
    required List<UserSummary> taggedUsers,
    required bool commentsDisabled,
    required int likeCount,
    required int saveCount,
    required int commentCount,
    required bool viewerHasLiked,
    required bool viewerHasSaved,
    required bool isVideoReady,
    required DateTime createdAt,
    String? caption,
    Place? location,
  }) = _Reel;

  const Reel._();

  factory Reel.fromJson(Map<String, dynamic> json) => _$ReelFromJson(json);

  /// The video's still-frame poster delivery URL (shown while initializing,
  /// while processing, or under Reduce Motion), or null when not yet available.
  String? get posterUrl {
    final v = video.variants;
    if (v == null) return null;
    final poster = v['poster'];
    if (poster is Map) {
      final url = poster['url'];
      return url is String ? url : null;
    }
    return poster is String ? poster : null;
  }

  /// The playable single video rendition URL, or null while processing / not
  /// ready (the feed then shows the poster placeholder).
  String? get videoUrl {
    if (!isVideoReady) return null;
    final v = video.variants;
    if (v == null) return null;
    final renditions = v['renditions'];
    if (renditions is List && renditions.isNotEmpty) {
      final first = renditions.first;
      if (first is Map) {
        final url = first['url'];
        return url is String ? url : null;
      }
      if (first is String) return first;
    }
    final single = v['url'];
    return single is String ? single : null;
  }

  /// True while the video is still transcoding (own just-published reel).
  bool get isProcessing => !isVideoReady;

  /// Video duration in milliseconds, when known.
  int? get durationMs => video.durationMs;
}
