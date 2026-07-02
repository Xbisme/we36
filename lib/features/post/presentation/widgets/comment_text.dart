import 'package:flutter/widgets.dart';
import 'package:we36/core/theme/app_colors.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_typography.dart';

/// Renders comment text with `@mentions` and `#hashtags` accented in brand
/// violet (FR-014). Non-interactive — tapping does nothing (mention/tag
/// navigation is deferred to #009/#010). Splitting on token boundaries keeps
/// the widget pure + text-scaling friendly.
class CommentText extends StatelessWidget {
  const CommentText(this.text, {super.key});

  final String text;

  static final RegExp _token = RegExp(r'([@#][\w]+)');

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final base = AppTypography.body16.copyWith(color: tokens.textPrimary);
    final accent = base.copyWith(color: AppColors.violet500);

    final spans = <TextSpan>[];
    var index = 0;
    for (final match in _token.allMatches(text)) {
      if (match.start > index) {
        spans.add(TextSpan(text: text.substring(index, match.start)));
      }
      spans.add(TextSpan(text: match.group(0), style: accent));
      index = match.end;
    }
    if (index < text.length) {
      spans.add(TextSpan(text: text.substring(index)));
    }

    return Text.rich(
      TextSpan(style: base, children: spans),
    );
  }
}
