import 'package:freezed_annotation/freezed_annotation.dart';

part 'reel_draft.freezed.dart';

/// Max reel video duration (90s) and file size (150 MB) — aligned with the
/// backend media pipeline (`MEDIA_VIDEO_MAX_DURATION_SECONDS` /
/// `MEDIA_VIDEO_MAX_BYTES`). Enforced at pick time (FR-017).
const int kReelMaxDurationMs = 90 * 1000;
const int kReelMaxBytes = 150 * 1024 * 1024;

/// An in-progress create-reel draft (#008). Not persisted (single-video, short
/// lived — the discard-confirm covers accidental exit). [idempotencyKey] is
/// stable across publish retries so exactly one reel is created (FR-020).
@freezed
abstract class ReelDraft with _$ReelDraft {
  const factory ReelDraft({
    required String id,
    required String idempotencyKey,
    required String videoAssetId,
    required int videoDurationMs,
    String? caption,
    @Default(false) bool commentsDisabled,
    String? locationName,
    @Default(<String>[]) List<String> taggedUserIds,
  }) = _ReelDraft;
}
