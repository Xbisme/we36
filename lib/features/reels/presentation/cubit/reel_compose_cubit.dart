import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:we36/core/data/api/idempotency.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/services/media_upload_service.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/features/reels/domain/reel_draft.dart';
import 'package:we36/features/reels/domain/usecases/publish_reel.dart';
import 'package:we36/features/reels/presentation/cubit/reel_compose_state.dart';

/// Drives the create-reel flow (#008): permission → list videos → pick (validate
/// ≤90s) → caption/options → publish (progress/cancel/retry, idempotent). The
/// heavy work is delegated to [PublishReel] (Constitution XI).
@injectable
class ReelComposeCubit extends Cubit<ReelComposeState> {
  ReelComposeCubit(this._library, this._publish, this._keys)
    : super(const ReelComposeState.initial());

  final PhotoLibraryService _library;
  final PublishReel _publish;
  final IdempotencyKeys _keys;

  UploadCancelToken? _cancel;

  /// Request permission + load the pickable video list.
  Future<void> loadInitial() async {
    emit(const ReelComposeState.loading());
    final perm = await _library.ensurePermission();
    if (perm.valueOrNull == PhotoPermission.denied) {
      emit(
        const ReelComposeState.error(failure: AppFailure.permissionDenied()),
      );
      return;
    }
    final result = await _library.loadVideos(page: 0, pageSize: 60);
    if (isClosed) return;
    result.fold(
      (page) => emit(ReelComposeState.loaded(videos: page.assets)),
      (failure) => emit(ReelComposeState.error(failure: failure)),
    );
  }

  /// Pick a video. Rejects a clip longer than 90s (FR-017) with a failure to
  /// toast; otherwise starts a fresh draft (stable idempotency key).
  AppFailure? pickVideo(AssetRef ref) {
    final videos = state.videos;
    final duration = ref.durationMs ?? 0;
    if (duration > kReelMaxDurationMs) {
      return const AppFailure.mediaTooLarge();
    }
    final draft = ReelDraft(
      id: _keys.generate(),
      idempotencyKey: _keys.generate(),
      videoAssetId: ref.id,
      videoDurationMs: duration,
    );
    emit(ReelComposeState.loaded(videos: videos, draft: draft));
    return null;
  }

  void setCaption(String caption) {
    final draft = state.draft;
    if (draft == null) return;
    _emitDraft(draft.copyWith(caption: caption.isEmpty ? null : caption));
  }

  void toggleComments({required bool disabled}) {
    final draft = state.draft;
    if (draft == null) return;
    _emitDraft(draft.copyWith(commentsDisabled: disabled));
  }

  void setLocation(String? name) {
    final draft = state.draft;
    if (draft == null) return;
    _emitDraft(draft.copyWith(locationName: name));
  }

  void _emitDraft(ReelDraft draft) {
    emit(ReelComposeState.loaded(videos: state.videos, draft: draft));
  }

  /// Publish the current draft. Streams progress; on success emits `published`.
  Future<void> publish() async {
    final draft = state.draft;
    if (draft == null) return;
    _cancel = UploadCancelToken();
    emit(ReelComposeState.loadedUploading(draft: draft, fraction: 0));
    await for (final event in _publish(draft, cancelToken: _cancel)) {
      if (isClosed) return;
      switch (event) {
        case ReelPublishProgress(:final fraction):
          emit(
            ReelComposeState.loadedUploading(draft: draft, fraction: fraction),
          );
        case ReelPublishSucceeded(:final reel):
          emit(ReelComposeState.published(reel));
        case ReelPublishFailed(:final failure):
          emit(ReelComposeState.error(failure: failure, draft: draft));
      }
    }
  }

  /// Cancel an in-flight upload and return to the editable draft.
  void cancel() {
    _cancel?.cancel();
    final draft = state.draft;
    if (draft != null) {
      emit(ReelComposeState.loaded(videos: state.videos, draft: draft));
    }
  }

  /// Retry a failed publish (reuses the draft's idempotency key ⇒ one reel).
  Future<void> retry() async {
    if (state.draft != null) await publish();
  }
}
