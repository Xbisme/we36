import 'package:flutter/material.dart';
import 'package:we36/core/data/messaging/message.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_gradients.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/features/messaging/presentation/widgets/delivery_status.dart';
import 'package:we36/features/messaging/presentation/widgets/shared_post_card.dart';

/// One message bubble (#012 US2, Screen 26): my messages are the brand gradient
/// aligned right; the peer's are neutral `surface-2` aligned left. Renders text,
/// photo, sticker, and shared-post content; own bubbles show a delivery status.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    this.onRetry,
    this.onOpenShared,
    super.key,
  });

  final Message message;
  final VoidCallback? onRetry;
  final void Function(PostRef)? onOpenShared;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final mine = message.isMine;
    final isSticker = message.content is StickerContent;
    // Shared-post cards render as their own bordered card, not inside a bubble.
    final isCard = message.content is SharedPostContent;

    return LayoutBuilder(
      builder: (context, constraints) {
        final Widget bubble;
        if (isSticker) {
          bubble = _StickerContent(message.content as StickerContent);
        } else if (isCard) {
          bubble = _content(context, mine: mine);
        } else {
          bubble = Container(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.74),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              gradient: mine ? AppGradients.brand : null,
              color: mine ? null : tokens.surface2,
              borderRadius: BorderRadius.circular(AppRadius.lg).copyWith(
                bottomRight: mine ? const Radius.circular(6) : null,
                bottomLeft: mine ? null : const Radius.circular(6),
              ),
            ),
            child: _content(context, mine: mine),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 3,
          ),
          child: Column(
            crossAxisAlignment: mine
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Semantics(
                container: true,
                excludeSemantics: true,
                label: mine ? 'You: $_semantics' : _semantics,
                child: GestureDetector(
                  onTap: message.isFailed ? onRetry : null,
                  child: bubble,
                ),
              ),
              if (mine) DeliveryStatus(state: message.deliveryState),
            ],
          ),
        );
      },
    );
  }

  String get _semantics => switch (message.content) {
    TextContent(:final body) => body,
    PhotoContent() => 'Photo',
    SharedPostContent() => 'Shared a post',
    StickerContent() => 'Sticker',
  };

  Widget _content(BuildContext context, {required bool mine}) {
    final tokens = context.tokens;
    final color = mine ? tokens.textOnBrand : tokens.textPrimary;
    return switch (message.content) {
      TextContent(:final body) => Text(
        body,
        style: AppTypography.body16.copyWith(
          color: color,
          fontSize: 14,
          height: 20 / 14,
        ),
      ),
      PhotoContent(:final url, :final localPath) => _Photo(
        url: url,
        localPath: localPath,
      ),
      SharedPostContent(:final ref) => SharedPostCard(
        ref: ref,
        onTap: onOpenShared == null ? null : () => onOpenShared!(ref),
      ),
      StickerContent() => const SizedBox.shrink(),
    };
  }
}

class _StickerContent extends StatelessWidget {
  const _StickerContent(this.content);
  final StickerContent content;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(4),
    child: Text(content.glyphId, style: const TextStyle(fontSize: 56)),
  );
}

class _Photo extends StatelessWidget {
  const _Photo({this.url, this.localPath});
  final String? url;
  final String? localPath;

  @override
  Widget build(BuildContext context) {
    final src = url;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: SizedBox(
        width: 200,
        height: 200,
        child: src == null
            ? Container(color: context.tokens.surfaceSunken)
            : Image.network(src, fit: BoxFit.cover, cacheWidth: 400),
      ),
    );
  }
}
