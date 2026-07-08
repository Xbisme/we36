import 'package:flutter/material.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';

/// The peer's live "typing…" bubble in a chat (#012 US2). Three pulsing dots;
/// under Reduce Motion the animation degrades to static dots (Constitution VI).
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      label: 'typing',
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 3,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: tokens.surface2,
          borderRadius: BorderRadius.circular(AppRadius.lg).copyWith(
            bottomLeft: const Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++)
              Padding(
                padding: EdgeInsets.only(right: i < 2 ? 4 : 0),
                child: reduceMotion
                    ? _Dot(opacity: 0.6, color: tokens.textTertiary)
                    : AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) {
                          final t = (_controller.value - i * 0.2) % 1.0;
                          final opacity =
                              0.3 +
                              0.7 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
                          return _Dot(
                            opacity: opacity,
                            color: tokens.textTertiary,
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.opacity, required this.color});
  final double opacity;
  final Color color;

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: opacity,
    child: Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ),
  );
}
