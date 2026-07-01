import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/features/compose/domain/models/media_edit_state.dart';
import 'package:we36/features/compose/domain/models/post_metadata.dart';
import 'package:we36/features/compose/domain/models/selected_media_item.dart';

part 'compose_draft.freezed.dart';
part 'compose_draft.g.dart';

/// Maximum photos in a carousel (clarified default — spec Assumptions).
const int kCarouselMaxItems = 10;

/// Maximum caption length (clarified default — spec Assumptions).
const int kCaptionMaxLength = 2200;

/// The in-progress post being built — the single unit the flow mutates and
/// the object persisted across app kill/restart (FR-021, Q2).
@freezed
abstract class ComposeDraft with _$ComposeDraft {
  const factory ComposeDraft({
    required String id,
    required String idempotencyKey,
    required DateTime createdAt,
    @Default(<SelectedMediaItem>[]) List<SelectedMediaItem> items,
    @Default('') String caption,
    @Default(PostMetadata()) PostMetadata metadata,
  }) = _ComposeDraft;

  const ComposeDraft._();

  factory ComposeDraft.fromJson(Map<String, dynamic> json) =>
      _$ComposeDraftFromJson(json);

  /// True once at least one photo is selected (gate to leave the pick step).
  bool get canProceed => items.isNotEmpty;

  /// True when the selection is a carousel (multiple photos).
  bool get isCarousel => items.length > 1;

  /// Whether another photo may still be selected.
  bool get canAddMore => items.length < kCarouselMaxItems;

  /// The edit state for the item at [index] (or a pristine one).
  MediaEditState editAt(int index) => (index >= 0 && index < items.length)
      ? items[index].edit
      : const MediaEditState();
}
