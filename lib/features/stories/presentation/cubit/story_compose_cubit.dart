import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/services/media_upload_service.dart';
import 'package:we36/core/services/story_image_composer.dart';
import 'package:we36/features/stories/domain/models/story_compose_draft.dart';
import 'package:we36/features/stories/domain/usecases/publish_story.dart';
import 'package:we36/features/stories/presentation/cubit/story_compose_state.dart';

/// Drives the story compose flow (#005): builds the [StoryComposeDraft] from the
/// picked photo, flattens the 9:16 canvas WYSIWYG via [StoryImageComposer], and
/// publishes via [PublishStory] with progress + cancel + idempotent retry
/// (FR-008/FR-009/FR-017). Side effects (toast/haptic/pop) live in the page's
/// `BlocListener`, not here (Constitution III).
@injectable
class StoryComposeCubit extends Cubit<StoryComposeState> {
  StoryComposeCubit(this._publish, this._composer, this._keys)
    : super(const StoryComposeState.initial());

  final PublishStory _publish;
  final StoryImageComposer _composer;
  final IdempotencyKeys _keys;

  UploadCancelToken? _cancelToken;
  Uint8List? _bytes; // flattened once per session; reused on retry (idempotent)

  /// Start a fresh compose session from the picked [assetId].
  void startFromAsset(String assetId) {
    _bytes = null;
    emit(
      StoryComposeState.loaded(
        draft: StoryComposeDraft(
          assetId: assetId,
          idempotencyKey: _keys.generate(),
        ),
      ),
    );
  }

  /// Choose the audience (Your story / Close friends) — US3.
  void setAudience(StoryAudience audience) {
    final draft = state.draftOrNull;
    if (draft == null) return;
    emit(StoryComposeState.loaded(draft: draft.copyWith(audience: audience)));
  }

  /// Flatten the canvas identified by [boundaryKey] and publish the story.
  Future<void> publish({required GlobalKey boundaryKey}) async {
    final draft = state.draftOrNull;
    if (draft == null) return;
    _cancelToken = UploadCancelToken();
    emit(StoryComposeState.loadedUploading(draft: draft));

    if (_bytes == null) {
      final flattened = await _composer.flatten(boundaryKey: boundaryKey);
      if (isClosed || (_cancelToken?.isCancelled ?? false)) return;
      final bytes = flattened.valueOrNull;
      if (bytes == null) {
        emit(
          StoryComposeState.error(
            failure:
                flattened.failureOrNull ?? const AppFailure.uploadFailed(),
            draft: draft,
          ),
        );
        return;
      }
      _bytes = bytes;
    }
    await _doPublish(draft);
  }

  /// Retry a failed publish — reuses the flattened bytes + the same idempotency
  /// key so exactly one story is ever created (FR-009/SC-004).
  Future<void> retry() async {
    final draft = state.draftOrNull;
    if (draft == null || _bytes == null) return;
    _cancelToken = UploadCancelToken();
    emit(StoryComposeState.loadedUploading(draft: draft));
    await _doPublish(draft);
  }

  /// Cancel the in-flight upload — no story created; returns to editing intact.
  void cancel() {
    _cancelToken?.cancel();
    final draft = state.draftOrNull;
    if (draft != null) emit(StoryComposeState.loaded(draft: draft));
  }

  Future<void> _doPublish(StoryComposeDraft draft) async {
    final result = await _publish(
      imageBytes: _bytes!,
      audience: draft.audience,
      idempotencyKey: draft.idempotencyKey,
      cancelToken: _cancelToken,
      onProgress: (p) {
        if (!isClosed && !(_cancelToken?.isCancelled ?? false)) {
          emit(StoryComposeState.loadedUploading(draft: draft, progress: p));
        }
      },
    );
    if (isClosed || (_cancelToken?.isCancelled ?? false)) return;
    result.fold(
      (segment) => emit(StoryComposeState.published(segment)),
      (failure) => emit(StoryComposeState.error(failure: failure, draft: draft)),
    );
  }
}
