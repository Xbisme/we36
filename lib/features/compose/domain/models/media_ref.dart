import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_ref.freezed.dart';
part 'media_ref.g.dart';

/// Server reference to an uploaded media object (B#007 `POST /media` result).
@freezed
abstract class MediaRef with _$MediaRef {
  const factory MediaRef({
    required String id,
    String? url,
    int? width,
    int? height,
  }) = _MediaRef;

  factory MediaRef.fromJson(Map<String, dynamic> json) =>
      _$MediaRefFromJson(json);
}

/// Transient upload progress for the progress bar (FR-017). Not persisted.
@freezed
abstract class UploadProgress with _$UploadProgress {
  const factory UploadProgress({
    required int sentBytes,
    required int totalBytes,
    @Default(0) int itemIndex,
    @Default(1) int itemCount,
  }) = _UploadProgress;

  const UploadProgress._();

  /// Zero-progress start for [itemCount] items.
  factory UploadProgress.start({int itemCount = 1}) =>
      UploadProgress(sentBytes: 0, totalBytes: 1, itemCount: itemCount);

  /// 0.0..1.0 fraction for the current item.
  double get fraction =>
      totalBytes <= 0 ? 0 : (sentBytes / totalBytes).clamp(0.0, 1.0);

  /// 0.0..1.0 fraction across the whole draft (all items).
  double get overallFraction =>
      itemCount <= 0 ? 0 : ((itemIndex + fraction) / itemCount).clamp(0.0, 1.0);
}
