import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_metadata.freezed.dart';
part 'post_metadata.g.dart';

/// Lightweight place reference for the caption step (v1.0 simple picker).
@freezed
abstract class PlaceRef with _$PlaceRef {
  const factory PlaceRef({
    required String label,
    String? id,
  }) = _PlaceRef;

  factory PlaceRef.fromJson(Map<String, dynamic> json) =>
      _$PlaceRefFromJson(json);
}

/// Optional post metadata set on the caption step (FR-013/014).
///
/// "Also share to Stories" and "Add music" are hidden in v1.0 (Q5) — no fields.
@freezed
abstract class PostMetadata with _$PostMetadata {
  const factory PostMetadata({
    @Default(<String>[]) List<String> taggedUserIds,
    PlaceRef? location,
    @Default(false) bool commentsDisabled,
  }) = _PostMetadata;

  factory PostMetadata.initial() => const PostMetadata();

  factory PostMetadata.fromJson(Map<String, dynamic> json) =>
      _$PostMetadataFromJson(json);
}
