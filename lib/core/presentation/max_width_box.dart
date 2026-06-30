import 'package:flutter/widgets.dart';

/// Centers content within a maximum readable width on wide layouts
/// (feed 560 / profile 900 / notifications 620). Constitution VI/VII.
class MaxWidthBox extends StatelessWidget {
  const MaxWidthBox({
    required this.maxWidth,
    required this.child,
    super.key,
  });

  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
