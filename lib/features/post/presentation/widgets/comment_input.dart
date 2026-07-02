import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we36/core/data/comments/comment.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/post/presentation/cubit/comments_state.dart';
import 'package:we36/features/post/presentation/widgets/quick_emoji_row.dart';

/// The comment composer (Screen 15): quick-emoji row + avatar + text field +
/// Post. Enforces non-empty and ≤[Comment.maxLength] (FR-013). Shows a
/// "Replying to @handle" banner while a [ReplyContext] is active (US3). Hidden
/// by the page when commenting is turned off (FR-012).
class CommentInput extends StatefulWidget {
  const CommentInput({
    required this.onSubmit,
    this.replyContext,
    this.onCancelReply,
    super.key,
  });

  /// Returns true when the comment was accepted (so the field can clear).
  final Future<bool> Function(String text) onSubmit;
  final ReplyContext? replyContext;
  final VoidCallback? onCancelReply;

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  bool _sending = false;

  bool get _canPost => !_sending && _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(CommentInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Focus the field when a reply target is set.
    if (widget.replyContext != null && oldWidget.replyContext == null) {
      _focus.requestFocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _insert(String emoji) {
    _controller.text = '${_controller.text}$emoji';
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );
    _focus.requestFocus();
  }

  Future<void> _submit() async {
    if (!_canPost) return;
    setState(() => _sending = true);
    final ok = await widget.onSubmit(_controller.text.trim());
    if (!mounted) return;
    setState(() => _sending = false);
    if (ok) {
      _controller.clear();
      _focus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final reply = widget.replyContext;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(top: BorderSide(color: tokens.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (reply != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.commentReplyingTo(reply.handle),
                          style: AppTypography.caption.copyWith(
                            color: tokens.textSecondary,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onCancelReply,
                        child: Semantics(
                          button: true,
                          label: l10n.commentReplyCancel,
                          child: const AppIcon(AppIcons.close, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              QuickEmojiRow(onSelect: _insert),
              Row(
                children: [
                  const Avatar(size: 32),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focus,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(Comment.maxLength),
                      ],
                      onSubmitted: (_) => _submit(),
                      style: AppTypography.body16.copyWith(
                        color: tokens.textPrimary,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: l10n.commentAddHint,
                        hintStyle: AppTypography.body16.copyWith(
                          color: tokens.textTertiary,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _canPost ? _submit : null,
                    child: Text(
                      l10n.commentPost,
                      style: AppTypography.label.copyWith(
                        color: _canPost ? tokens.accent : tokens.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
