import 'package:flutter/material.dart';
import 'package:we36/core/theme/app_gradients.dart';
import 'package:we36/core/theme/app_typography.dart';

/// "We36" wordmark — gradient-clipped on light surfaces, solid white (`mono`)
/// on gradient/ink backgrounds. Pure Flutter (no asset). Constitution VI.
class Wordmark extends StatelessWidget {
  const Wordmark({this.mono = false, this.fontSize = 26, super.key});

  final bool mono;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final style = AppTypography.wordmark.copyWith(fontSize: fontSize);
    final text = Text('We36', style: style.copyWith(color: Colors.white));
    return Semantics(
      header: true,
      label: 'We36',
      child: mono
          ? text
          : ShaderMask(
              shaderCallback: (bounds) =>
                  AppGradients.brand.createShader(bounds),
              blendMode: BlendMode.srcIn,
              child: text,
            ),
    );
  }
}
