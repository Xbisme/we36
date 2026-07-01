import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_edit_state.freezed.dart';
part 'media_edit_state.g.dart';

/// Preset color filters offered on the edit step (Screen 12).
///
/// Each value maps to a fixed 4x5 color matrix in `filter_matrices.dart` —
/// the single source used by both the live `ColorFilter.matrix` preview and
/// the `image`-package bake at export (research R3).
enum FilterPreset { original, warm, lux, mono, fade }

/// Normalized crop rectangle (0..1 of the source), serializable for drafts.
///
/// Used instead of `dart:ui.Rect` so the draft persists as plain JSON.
@freezed
abstract class CropRect with _$CropRect {
  const factory CropRect({
    required double left,
    required double top,
    required double width,
    required double height,
  }) = _CropRect;

  /// Full-frame default (whole image; the edit stage crops to 4:5 on top).
  factory CropRect.full() =>
      const CropRect(left: 0, top: 0, width: 1, height: 1);

  factory CropRect.fromJson(Map<String, dynamic> json) =>
      _$CropRectFromJson(json);
}

/// Per-photo edit state: crop + filter + adjustments (Q4 — per-photo edits).
@freezed
abstract class MediaEditState with _$MediaEditState {
  const factory MediaEditState({
    CropRect? cropRect,
    @Default(FilterPreset.original) FilterPreset filter,
    @Default(0.0) double brightness,
    @Default(0.0) double contrast,
    @Default(0.0) double warmth,
  }) = _MediaEditState;

  /// A pristine edit (no crop, no filter, neutral adjustments).
  factory MediaEditState.initial() => const MediaEditState();

  factory MediaEditState.fromJson(Map<String, dynamic> json) =>
      _$MediaEditStateFromJson(json);
}
