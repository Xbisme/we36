import 'package:flutter/material.dart';
import 'package:we36/core/data/api/dev_media_url.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_gradients.dart';

enum AvatarRing { none, unseen, seen }

/// Circular avatar with optional story ring (unseen = brand-story gradient,
/// seen = flat gray), online dot, and a create (`+`) badge. Constitution VI.
class Avatar extends StatelessWidget {
  const Avatar({
    required this.size,
    this.image,
    this.ring = AvatarRing.none,
    this.online = false,
    this.showCreateBadge = false,
    this.semanticLabel,
    super.key,
  });

  final double size;
  final ImageProvider<Object>? image;
  final AvatarRing ring;
  final bool online;
  final bool showCreateBadge;
  final String? semanticLabel;

  /// Dev-only: rewrite a `localhost` avatar URL (often from the drift cache,
  /// which predates the API-response interceptor) to the LAN host so avatars
  /// load on a physical device. One place → covers every `Avatar` call site.
  /// No-op in prod / when unset. See `rewriteLocalhostUrl`.
  ImageProvider<Object>? get _resolvedImage {
    final provider = image;
    if (provider is NetworkImage) {
      final url = rewriteLocalhostUrl(provider.url, DevMediaHost.host);
      if (url != provider.url) return NetworkImage(url);
    }
    return provider;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final hasRing = ring != AvatarRing.none;
    final ringPad = hasRing ? 3.0 : 0.0;
    final display = _resolvedImage;

    Widget core = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: tokens.surface2,
        shape: BoxShape.circle,
        image: display == null
            ? null
            : DecorationImage(image: display, fit: BoxFit.cover),
      ),
    );

    if (hasRing) {
      core = Container(
        padding: EdgeInsets.all(ringPad),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: ring == AvatarRing.unseen ? AppGradients.story : null,
          color: ring == AvatarRing.seen ? tokens.border : null,
        ),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: tokens.bgApp,
            shape: BoxShape.circle,
          ),
          child: core,
        ),
      );
    }

    return Semantics(
      image: true,
      label: semanticLabel,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          core,
          if (online)
            Positioned(
              right: 0,
              bottom: 0,
              child: _Dot(color: tokens.success, border: tokens.surface),
            ),
          if (showCreateBadge)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: size * 0.34,
                height: size * 0.34,
                decoration: BoxDecoration(
                  gradient: AppGradients.brand,
                  shape: BoxShape.circle,
                  border: Border.all(color: tokens.surface, width: 2),
                ),
                child: Icon(
                  AppIcons.plus,
                  size: size * 0.2,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.border});

  final Color color;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: 2),
      ),
    );
  }
}
