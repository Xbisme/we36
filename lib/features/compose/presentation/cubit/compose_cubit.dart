import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/services/media_upload_service.dart';
import 'package:we36/features/compose/data/compose_draft_store.dart';
import 'package:we36/features/compose/domain/create_post_repository.dart';
import 'package:we36/features/compose/domain/models/compose_draft.dart';
import 'package:we36/features/compose/domain/models/media_edit_state.dart';
import 'package:we36/features/compose/domain/models/post_metadata.dart';
import 'package:we36/features/compose/domain/models/selected_media_item.dart';
import 'package:we36/features/compose/domain/usecases/publish_post.dart';
import 'package:we36/features/compose/presentation/cubit/compose_state.dart';

/// Drives the compose flow: builds the working [ComposeDraft], applies per-item
/// edits + metadata, persists the draft across app kill (FR-021), and publishes
/// via [PublishPost] with cancel/retry (FR-017/018a/019).
@injectable
class ComposeCubit extends Cubit<ComposeState> {
  ComposeCubit(this._publish, this._draftStore, this._keys)
    : super(const ComposeState.initial());

  final PublishPost _publish;
  final ComposeDraftStore _draftStore;
  final IdempotencyKeys _keys;

  UploadCancelToken? _cancelToken;

  int get _activeIndex => switch (state) {
    ComposeLoaded(:final activeItemIndex) => activeItemIndex,
    _ => 0,
  };

  /// Build a fresh draft from picked asset ids (in selection order).
  Future<void> startFromAssets(List<String> assetIds) async {
    final draft = ComposeDraft(
      id: _keys.generate(),
      idempotencyKey: _keys.generate(),
      createdAt: DateTime.now().toUtc(),
      items: [
        for (var i = 0; i < assetIds.length; i++)
          SelectedMediaItem(assetId: assetIds[i], order: i),
      ],
    );
    emit(ComposeState.loaded(draft: draft));
    await _persist(draft);
  }

  /// Whether a non-empty draft is persisted (drives the restore prompt on entry).
  Future<bool> hasStoredDraft() async {
    final draft = await _draftStore.read();
    return draft != null && draft.items.isNotEmpty;
  }

  /// Restore a persisted draft if one exists (returns true if restored).
  ///
  /// [assetStillExists] lets the caller drop items whose device asset is gone
  /// since the draft was saved (Constitution IX); orders are re-packed. If every
  /// item is gone the draft is cleared and restore fails.
  Future<bool> tryRestore({
    Future<bool> Function(String assetId)? assetStillExists,
  }) async {
    final draft = await _draftStore.read();
    if (draft == null || draft.items.isEmpty) return false;

    var items = draft.items;
    if (assetStillExists != null) {
      final kept = <SelectedMediaItem>[];
      for (final item in draft.items) {
        if (await assetStillExists(item.assetId)) kept.add(item);
      }
      items = [
        for (var i = 0; i < kept.length; i++) kept[i].copyWith(order: i),
      ];
    }

    if (items.isEmpty) {
      await _draftStore.clear();
      return false;
    }
    final restored = draft.copyWith(items: items);
    emit(ComposeState.loaded(draft: restored));
    if (items.length != draft.items.length) await _persist(restored);
    return true;
  }

  /// Discard the in-progress draft (clears storage; resets to initial).
  Future<void> discard() async {
    await _draftStore.clear();
    emit(const ComposeState.initial());
  }

  void setActiveItem(int index) {
    final d = state.draftOrNull;
    if (d == null) return;
    emit(ComposeState.loaded(draft: d, activeItemIndex: index));
  }

  void setCaption(String caption) =>
      _mutate((d) => d.copyWith(caption: caption));

  void setFilter(FilterPreset filter) =>
      _mutateActive((e) => e.copyWith(filter: filter));

  void setBrightness(double v) =>
      _mutateActive((e) => e.copyWith(brightness: v));

  void setContrast(double v) => _mutateActive((e) => e.copyWith(contrast: v));

  void setWarmth(double v) => _mutateActive((e) => e.copyWith(warmth: v));

  void setCrop(CropRect rect) =>
      _mutateActive((e) => e.copyWith(cropRect: rect));

  void toggleComments({required bool disabled}) => _mutate(
    (d) => d.copyWith(
      metadata: d.metadata.copyWith(commentsDisabled: disabled),
    ),
  );

  void setLocation(PlaceRef? location) => _mutate(
    (d) => d.copyWith(metadata: d.metadata.copyWith(location: location)),
  );

  void setTaggedUsers(List<String> ids) => _mutate(
    (d) => d.copyWith(metadata: d.metadata.copyWith(taggedUserIds: ids)),
  );

  /// Publish the current draft. Idempotent + retryable with the same key.
  Future<void> publish() async {
    final draft = state.draftOrNull;
    if (draft == null || !draft.canProceed) return;
    _cancelToken = UploadCancelToken();
    emit(ComposeState.loadedUploading(draft: draft));

    await for (final event in _publish(draft, cancelToken: _cancelToken)) {
      if (isClosed) return;
      // Cancelled mid-flight: stop consuming so we don't re-enter uploading
      // after cancel() has already returned to `loaded` (FR-018a).
      if (_cancelToken?.isCancelled ?? false) return;
      switch (event) {
        case PublishProgress(:final overallFraction):
          emit(
            ComposeState.loadedUploading(
              draft: draft,
              progress: overallFraction,
            ),
          );
        case PublishSucceeded(:final post):
          await _draftStore.clear();
          if (!isClosed) emit(ComposeState.published(post));
        case PublishFailed(:final failure):
          if (!isClosed) {
            emit(ComposeState.error(failure: failure, draft: draft));
          }
          return;
      }
    }
  }

  /// Cancel the in-flight upload — no post created; returns to editing intact.
  void cancel() {
    _cancelToken?.cancel();
    final draft = state.draftOrNull;
    if (draft != null) emit(ComposeState.loaded(draft: draft));
  }

  /// Retry a failed publish (reuses the draft's idempotency key → no dupe).
  Future<void> retry() => publish();

  void _mutate(ComposeDraft Function(ComposeDraft) transform) {
    final d = state.draftOrNull;
    if (d == null) return;
    final next = transform(d);
    emit(ComposeState.loaded(draft: next, activeItemIndex: _activeIndex));
    unawaited(_persist(next));
  }

  void _mutateActive(MediaEditState Function(MediaEditState) transform) {
    final d = state.draftOrNull;
    if (d == null || d.items.isEmpty) return;
    final index = _activeIndex.clamp(0, d.items.length - 1);
    final items = [...d.items];
    items[index] = items[index].copyWith(edit: transform(items[index].edit));
    _mutate((draft) => draft.copyWith(items: items));
  }

  Future<void> _persist(ComposeDraft draft) => _draftStore.save(draft);
}
