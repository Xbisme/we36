import 'package:flutter/widgets.dart';
import 'package:we36/core/theme/app_motion.dart';

/// Wraps a tappable child with the We36 press-scale feedback. Honors
/// Reduce-Motion by skipping the scale animation (Constitution VI).
class Pressable extends StatefulWidget {
  const Pressable({
    required this.child,
    this.onTap,
    this.scale = AppMotion.pressScaleButton,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool value) {
    if (widget.onTap == null) return;
    setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    final reduce = context.reduceMotion;
    final target = _down && !reduce ? widget.scale : 1.0;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: target,
        duration: AppMotion.fast,
        curve: AppMotion.springCurve,
        child: widget.child,
      ),
    );
  }
}
