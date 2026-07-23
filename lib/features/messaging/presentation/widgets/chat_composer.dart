import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/sticker_tray.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_gradients.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// The chat input row (#012 US2/US3, Screen 26/28): a camera (photo), a text
/// field that reports typing, a sticker toggle opening the shared sticker tray,
/// and a send action.
class ChatComposer extends StatefulWidget {
  const ChatComposer({
    required this.onSendText,
    required this.onTyping,
    this.onPickPhoto,
    this.onSendSticker,
    super.key,
  });

  final ValueChanged<String> onSendText;
  final ValueChanged<bool> onTyping;
  final VoidCallback? onPickPhoto;
  final ValueChanged<String>? onSendSticker;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final _controller = TextEditingController();
  bool _showStickers = false;
  bool _typing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final active = value.trim().isNotEmpty;
    if (active != _typing) {
      _typing = active;
      widget.onTyping(active);
    }
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    unawaited(HapticFeedback.lightImpact()); // message sent (Constitution VII).
    widget.onSendText(text);
    _controller.clear();
    _typing = false;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: tokens.surface,
            border: Border(top: BorderSide(color: tokens.divider)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                if (widget.onPickPhoto != null) ...[
                  Semantics(
                    button: true,
                    label: l10n.dmPhoto,
                    child: GestureDetector(
                      onTap: widget.onPickPhoto,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          gradient: AppGradients.brand,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: AppIcon(
                          AppIcons.camera,
                          size: 20,
                          color: tokens.textOnBrand,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: tokens.surface2,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            onChanged: _onChanged,
                            onSubmitted: (_) => _send(),
                            textInputAction: TextInputAction.send,
                            minLines: 1,
                            maxLines: 4,
                            style: AppTypography.body16.copyWith(
                              color: tokens.textPrimary,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: l10n.dmMessageHint,
                              hintStyle: AppTypography.body16.copyWith(
                                color: tokens.textTertiary,
                              ),
                            ),
                          ),
                        ),
                        Semantics(
                          button: true,
                          label: l10n.dmSticker,
                          child: GestureDetector(
                            onTap: () => setState(
                              () => _showStickers = !_showStickers,
                            ),
                            child: AppIcon(
                              AppIcons.sticker,
                              color: _showStickers
                                  ? tokens.accent
                                  : tokens.icon,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Idle action is a like/heart affordance (Screen E2); it still
                // sends any typed text.
                IconButton(
                  onPressed: _send,
                  icon: AppIcon(AppIcons.like, color: tokens.icon),
                  tooltip: l10n.dmNewMessage,
                ),
              ],
            ),
          ),
        ),
        if (_showStickers)
          SizedBox(
            height: 260,
            child: StickerTray(
              categories: const ['Smileys', 'Love', 'Gestures'],
              emojis: const [
                '😀',
                '😂',
                '😍',
                '🥳',
                '😎',
                '🤝',
                '👍',
                '🙌',
                '🔥',
                '❤️',
                '✨',
                '🎉',
                '😮',
                '😢',
                '👏',
                '💯',
              ],
              onPick: (glyph) {
                widget.onSendSticker?.call(glyph);
                setState(() => _showStickers = false);
              },
            ),
          ),
      ],
    );
  }
}
