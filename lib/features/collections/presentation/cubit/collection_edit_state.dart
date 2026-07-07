import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_edit_state.freezed.dart';

/// The create/rename/delete/set-cover mutations surface (#011 US4). Thin — the
/// collections grid repaints through the reactive cache; this only tracks the
/// in-flight flag for the sheet/dialog.
@freezed
sealed class CollectionEditState with _$CollectionEditState {
  const factory CollectionEditState.idle() = CollectionEditIdle;
  const factory CollectionEditState.working() = CollectionEditWorking;
}
