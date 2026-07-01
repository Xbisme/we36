// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_edit_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CropRect _$CropRectFromJson(Map<String, dynamic> json) => _CropRect(
  left: (json['left'] as num).toDouble(),
  top: (json['top'] as num).toDouble(),
  width: (json['width'] as num).toDouble(),
  height: (json['height'] as num).toDouble(),
);

Map<String, dynamic> _$CropRectToJson(_CropRect instance) => <String, dynamic>{
  'left': instance.left,
  'top': instance.top,
  'width': instance.width,
  'height': instance.height,
};

_MediaEditState _$MediaEditStateFromJson(Map<String, dynamic> json) =>
    _MediaEditState(
      cropRect: json['cropRect'] == null
          ? null
          : CropRect.fromJson(json['cropRect'] as Map<String, dynamic>),
      filter:
          $enumDecodeNullable(_$FilterPresetEnumMap, json['filter']) ??
          FilterPreset.original,
      brightness: (json['brightness'] as num?)?.toDouble() ?? 0.0,
      contrast: (json['contrast'] as num?)?.toDouble() ?? 0.0,
      warmth: (json['warmth'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$MediaEditStateToJson(_MediaEditState instance) =>
    <String, dynamic>{
      'cropRect': instance.cropRect?.toJson(),
      'filter': _$FilterPresetEnumMap[instance.filter]!,
      'brightness': instance.brightness,
      'contrast': instance.contrast,
      'warmth': instance.warmth,
    };

const _$FilterPresetEnumMap = {
  FilterPreset.original: 'original',
  FilterPreset.warm: 'warm',
  FilterPreset.lux: 'lux',
  FilterPreset.mono: 'mono',
  FilterPreset.fade: 'fade',
};
