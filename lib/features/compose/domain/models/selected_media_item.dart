import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:we36/features/compose/domain/models/media_edit_state.dart';

part 'selected_media_item.freezed.dart';
part 'selected_media_item.g.dart';

/// One chosen photo plus its per-photo edit state and carousel position (Q4).
///
/// Stores the stable device [assetId] (re-resolvable via PhotoLibraryService)
/// rather than bytes, so drafts stay tiny and privacy-safe (Constitution I).
@freezed
abstract class SelectedMediaItem with _$SelectedMediaItem {
  const factory SelectedMediaItem({
    required String assetId,
    required int order,
    @Default(MediaEditState()) MediaEditState edit,
  }) = _SelectedMediaItem;

  factory SelectedMediaItem.fromJson(Map<String, dynamic> json) =>
      _$SelectedMediaItemFromJson(json);
}
