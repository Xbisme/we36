import 'package:we36/features/compose/domain/models/media_edit_state.dart';

/// Fixed 4x5 color matrices for each [FilterPreset].
///
/// A 4x5 matrix is 20 values (RGBA rows). This is the SINGLE source used by
/// both the live preview (`ColorFilter.matrix`) and the export bake (`image`
/// package) so the baked result matches the preview pixel-for-pixel (R3).
///
/// Row layout (per Flutter `ColorFilter.matrix`):
///   R' = m[0]*R  + m[1]*G  + m[2]*B  + m[3]*A  + m[4]
///   G' = m[5]*R  + m[6]*G  + m[7]*B  + m[8]*A  + m[9]
///   B' = m[10]*R + m[11]*G + m[12]*B + m[13]*A + m[14]
///   A' = m[15]*R + m[16]*G + m[17]*B + m[18]*A + m[19]
abstract final class FilterMatrices {
  /// Identity — no change.
  static const List<double> _identity = <double>[
    1, 0, 0, 0, 0, //
    0, 1, 0, 0, 0, //
    0, 0, 1, 0, 0, //
    0, 0, 0, 1, 0, //
  ];

  /// Warm — lift reds, gently drop blues.
  static const List<double> _warm = <double>[
    1.10, 0, 0, 0, 6, //
    0, 1.02, 0, 0, 2, //
    0, 0, 0.92, 0, -4, //
    0, 0, 0, 1, 0, //
  ];

  /// Lux — punchy contrast + slight saturation lift.
  static const List<double> _lux = <double>[
    1.18, 0, 0, 0, -8, //
    0, 1.18, 0, 0, -8, //
    0, 0, 1.18, 0, -8, //
    0, 0, 0, 1, 0, //
  ];

  /// Mono — luminance grayscale (Rec. 601 weights).
  static const List<double> _mono = <double>[
    0.299, 0.587, 0.114, 0, 0, //
    0.299, 0.587, 0.114, 0, 0, //
    0.299, 0.587, 0.114, 0, 0, //
    0, 0, 0, 1, 0, //
  ];

  /// Fade — lower contrast, raise blacks (matte look).
  static const List<double> _fade = <double>[
    0.90, 0, 0, 0, 18, //
    0, 0.90, 0, 0, 18, //
    0, 0, 0.92, 0, 22, //
    0, 0, 0, 1, 0, //
  ];

  /// The base 4x5 matrix for [preset].
  static List<double> forPreset(FilterPreset preset) => switch (preset) {
    FilterPreset.original => _identity,
    FilterPreset.warm => _warm,
    FilterPreset.lux => _lux,
    FilterPreset.mono => _mono,
    FilterPreset.fade => _fade,
  };

  /// Composite matrix = preset filter followed by brightness/contrast/warmth.
  ///
  /// `brightness`/`contrast`/`warmth` are -1.0..1.0. The result is what both
  /// the preview and the bake apply.
  static List<double> resolve(MediaEditState edit) {
    final base = forPreset(edit.filter);
    // Adjustment matrix: contrast scales around mid-grey, brightness offsets,
    // warmth shifts R up / B down.
    final c = 1.0 + edit.contrast * 0.5; // contrast gain
    final t = 128.0 * (1 - c); // keep mid-grey fixed under contrast
    final b = edit.brightness * 40.0; // brightness offset (0..±40)
    final w = edit.warmth * 20.0; // warmth split
    final adjust = <double>[
      c, 0, 0, 0, t + b + w, //
      0, c, 0, 0, t + b, //
      0, 0, c, 0, t + b - w, //
      0, 0, 0, 1, 0, //
    ];
    return _multiply(adjust, base);
  }

  /// Multiply two 4x5 color matrices ([a] applied after [b]): result = a·b.
  static List<double> _multiply(List<double> a, List<double> b) {
    final out = List<double>.filled(20, 0);
    for (var row = 0; row < 4; row++) {
      for (var col = 0; col < 5; col++) {
        var sum = 0.0;
        for (var k = 0; k < 4; k++) {
          sum += a[row * 5 + k] * b[k * 5 + col];
        }
        // The constant column also picks up a's constant term.
        if (col == 4) sum += a[row * 5 + 4];
        out[row * 5 + col] = sum;
      }
    }
    return out;
  }
}
