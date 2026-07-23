import 'package:flutter/material.dart';
import 'package:we36/core/data/api/dev_media_url.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_gradients.dart';
import 'package:we36/core/theme/app_typography.dart';

enum AvatarRing { none, unseen, seen }

/// Circular avatar with optional story ring (unseen = brand-story gradient,
/// seen = flat gray), online dot, and a create (`+`) badge. Constitution VI.
class Avatar extends StatelessWidget {
  const Avatar({
    required this.size,
    this.image,
    this.initials,
    this.ring = AvatarRing.none,
    this.online = false,
    this.showCreateBadge = false,
    this.semanticLabel,
    super.key,
  });

  final double size;
  final ImageProvider<Object>? image;

  /// Shown (on a soft brand gradient) when [image] is null — e.g. the first
  /// letter of a username. Keeps avatar-less rows from reading as empty.
  final String? initials;
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
    // Design: ring width & gap scale with the avatar (2px ≤44, 3px ≥56).
    final ringWidth = size >= 56 ? 3.0 : 2.0;
    final display = _resolvedImage;

    Widget core = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // With an image: neutral surface behind it while it loads. Without one:
        // the design's soft brand gradient (never a flat gray) — Constitution VI.
        color: display != null ? tokens.surface2 : null,
        gradient: display == null ? AppGradients.brandSoft : null,
        shape: BoxShape.circle,
        image: display == null
            ? null
            : DecorationImage(image: display, fit: BoxFit.cover),
      ),
      child: display == null && (initials?.isNotEmpty ?? false)
          ? Text(
              initials!,
              style: AppTypography.stat.copyWith(
                color: Colors.white,
                fontSize: size * 0.38,
                height: 1,
              ),
            )
          : null,
    );

    if (hasRing) {
      core = Container(
        padding: EdgeInsets.all(ringWidth),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: ring == AvatarRing.unseen ? AppGradients.story : null,
          color: ring == AvatarRing.seen ? tokens.borderStrong : null,
        ),
        child: Container(
          padding: EdgeInsets.all(ringWidth),
          decoration: BoxDecoration(
            color: tokens.surface,
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
              right: hasRing ? ringWidth : 0,
              bottom: hasRing ? ringWidth : 0,
              child: _Dot(
                size: (size * 0.28).clamp(10.0, double.infinity),
                color: tokens.online,
                border: tokens.surface,
              ),
            ),
          if (showCreateBadge)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  gradient: AppGradients.brand,
                  shape: BoxShape.circle,
                  border: Border.all(color: tokens.surface, width: 2),
                ),
                child: const Icon(
                  AppIcons.plus,
                  size: 13,
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
  const _Dot({required this.color, required this.border, this.size = 12});

  final Color color;
  final Color border;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: 2),
      ),
    );
  }
}
