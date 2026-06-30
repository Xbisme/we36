import 'package:flutter/material.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_icon_button.dart';
import 'package:we36/core/presentation/app_switch.dart';
import 'package:we36/core/presentation/app_tag.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/presentation/post_card.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/presentation/wordmark.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// Renders the shared components + key variants for visual review + goldens
/// (SC-004). Dev flavor only.
class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              title: context.l10n.devGalleryTitle,
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  const Wordmark(fontSize: 40),
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      AppButton(label: 'Primary', onPressed: () {}),
                      AppButton(
                        label: 'Secondary',
                        kind: AppButtonKind.secondary,
                        onPressed: () {},
                      ),
                      AppButton(
                        label: 'Ghost',
                        kind: AppButtonKind.ghost,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      const Avatar(size: 56, ring: AvatarRing.unseen),
                      const SizedBox(width: AppSpacing.md),
                      const Avatar(size: 56, ring: AvatarRing.seen),
                      const SizedBox(width: AppSpacing.md),
                      const Avatar(size: 56, online: true),
                      const SizedBox(width: AppSpacing.md),
                      const Avatar(size: 56, showCreateBadge: true),
                      const SizedBox(width: AppSpacing.lg),
                      AppIconButton(
                        icon: AppIcons.like,
                        semanticLabel: 'Like',
                        active: true,
                        onPressed: () {},
                      ),
                      AppSwitch(value: true, onChanged: (_) {}),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      AppTag(label: 'For you', active: true),
                      AppTag(label: 'travel'),
                      AppTag(label: 'goldenhour', hashtag: true),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const PostCard(
                    username: 'mira.kw',
                    likesText: '38.4k likes',
                    caption: 'golden hour never misses 🌅',
                    location: 'Lisbon, Portugal',
                    commentsText: 'View all 86 comments',
                    timeText: '2h',
                    liked: true,
                    saved: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
