import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_dialog.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_gradients.dart';
import 'package:we36/core/theme/app_shadows.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/stories/domain/models/story_compose_draft.dart';
import 'package:we36/features/stories/presentation/cubit/story_compose_cubit.dart';
import 'package:we36/features/stories/presentation/cubit/story_compose_state.dart';
import 'package:we36/features/stories/presentation/cubit/story_gallery_cubit.dart';
import 'package:we36/features/stories/presentation/widgets/audience_toggle.dart';
import 'package:we36/features/stories/presentation/widgets/sticker_tray.dart';
import 'package:we36/features/stories/presentation/widgets/story_overlay_layer.dart';
import 'package:we36/features/stories/presentation/widgets/story_upload_progress.dart';
import 'package:we36/features/stories/presentation/widgets/text_overlay_editor.dart';

/// Step 2 of the create-story flow (Screen 9): the 9:16 compose canvas + Share.
/// The canvas is wrapped in a [RepaintBoundary] so [StoryComposeCubit] can
/// flatten exactly what is shown (overlays land in US2). A [BlocListener]
/// handles success (toast + haptic + return to feed) and failure (toast) —
/// side effects never in the builder (Constitution III).
class StoryComposePage extends StatefulWidget {
  const StoryComposePage({super.key});

  @override
  State<StoryComposePage> createState() => _StoryComposePageState();
}

class _StoryComposePageState extends State<StoryComposePage> {
  final GlobalKey _boundaryKey = GlobalKey();

  /// Back-out — confirm before discarding a story with a photo/overlays (FR-015).
  Future<void> _onClose(StoryComposeDraft? draft) async {
    if (draft == null) {
      context.pop();
      return;
    }
    final keep = await showAppDialog(
      context,
      title: context.l10n.storyDiscardTitle,
      body: '',
      primaryLabel: context.l10n.storyDiscardKeep,
      secondaryLabel: context.l10n.storyDiscardDiscard,
      destructive: true,
    );
    if (!keep && mounted) context.pop();
  }

  Future<void> _addText() async {
    final text = await promptStoryText(context);
    if (text != null && mounted) {
      context.read<StoryComposeCubit>().addText(text);
    }
  }

  Future<void> _addSticker() async {
    final sticker = await showStickerTray(context);
    if (sticker != null && mounted) {
      context.read<StoryComposeCubit>().addSticker(sticker);
    }
  }

  @override
  Widget build(BuildContext context) {
    final library = context.read<StoryGalleryCubit>().library;

    return BlocConsumer<StoryComposeCubit, StoryComposeState>(
      listener: (context, state) {
        switch (state) {
          case StoryComposePublished():
            unawaited(HapticFeedback.lightImpact());
            getIt<ToastService>().show(
              context,
              message: context.l10n.storyPublished,
              tone: ToastTone.success,
            );
            context.go(AppRoutes.home);
          case StoryComposeError():
            getIt<ToastService>().show(
              context,
              message: context.l10n.storyUploadFailed,
              tone: ToastTone.error,
            );
          case _:
            break;
        }
      },
      builder: (context, state) {
        final draft = state.draftOrNull;
        final uploading = state is StoryComposeLoadedUploading;
        final failed = state is StoryComposeError;
        final cubit = context.read<StoryComposeCubit>();
        final progress = switch (state) {
          StoryComposeLoadedUploading(:final progress) => progress,
          _ => 0.0,
        };

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Full-bleed media + overlays — flattened WYSIWYG at publish
                // (FR-005). The RepaintBoundary spans the whole frame so the
                // export matches exactly what the creator sees.
                RepaintBoundary(
                  key: _boundaryKey,
                  child: ColoredBox(
                    color: Colors.black,
                    child: draft == null
                        ? const SizedBox.shrink()
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              Image(
                                image: library.thumbnail(
                                  AssetRef(
                                    id: draft.assetId,
                                    width: 0,
                                    height: 0,
                                  ),
                                  pixelSize: 1080,
                                ),
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                              ),
                              // Baked into the export by the RepaintBoundary.
                              StoryOverlayLayer(
                                draft: draft,
                                onMoveText: cubit.moveText,
                                onMoveSticker: cubit.moveSticker,
                                onRemoveText: cubit.removeText,
                                onRemoveSticker: cubit.removeSticker,
                              ),
                            ],
                          ),
                  ),
                ),
                // Bottom protection gradient for control legibility.
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IgnorePointer(child: _ComposeGradient()),
                ),
                // Top controls: close (left) + tool chips (right).
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: uploading
                              ? null
                              : () => unawaited(_onClose(draft)),
                          icon: const AppIcon(
                            AppIcons.close,
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        _ToolChip(
                          icon: AppIcons.camera,
                          semanticLabel: context.l10n.storyComingSoon,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        _ToolChip(
                          icon: AppIcons.plus,
                          semanticLabel: context.l10n.storyStickers,
                          onTap: (draft == null || uploading)
                              ? null
                              : () => unawaited(_addSticker()),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        _ToolChip(
                          icon: AppIcons.more,
                          semanticLabel: context.l10n.storyAddText,
                          onTap: (draft == null || uploading)
                              ? null
                              : () => unawaited(_addText()),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        _ToolChip(
                          icon: AppIcons.settings,
                          semanticLabel: context.l10n.storyComingSoon,
                        ),
                      ],
                    ),
                  ),
                ),
                if (uploading)
                  Positioned(
                    top: 64,
                    left: AppSpacing.lg,
                    right: AppSpacing.lg,
                    child: StoryUploadProgress(
                      progress: progress,
                      onCancel: cubit.cancel,
                    ),
                  ),
                // Bottom controls: audience pills (left) + publish (right).
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (draft != null)
                          Flexible(
                            child: AudienceToggle(
                              value: draft.audience,
                              onChanged: uploading ? (_) {} : cubit.setAudience,
                            ),
                          ),
                        const SizedBox(width: AppSpacing.md),
                        _PublishButton(
                          onTap: (draft == null || uploading)
                              ? null
                              : () => unawaited(
                                  failed
                                      ? cubit.retry()
                                      : cubit.publish(
                                          boundaryKey: _boundaryKey,
                                        ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Bottom-to-top protection scrim so the audience/publish controls stay legible
/// over bright photos.
class _ComposeGradient extends StatelessWidget {
  const _ComposeGradient();

  @override
  Widget build(BuildContext context) => Container(
    height: 150,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.center,
        colors: [Colors.black54, Colors.transparent],
      ),
    ),
  );
}

/// A 40x40 translucent-dark circular tool chip (top-right cluster). Inert chips
/// (no [onTap]) mirror the design mock and render as disabled affordances.
class _ToolChip extends StatelessWidget {
  const _ToolChip({
    required this.icon,
    required this.semanticLabel,
    this.onTap,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: 0.35),
          ),
          child: AppIcon(icon, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}

/// The bottom-right publish control: a 54x54 brand-gradient circle with a white
/// share glyph and a brand shadow (Constitution VI — gradient earns its place).
class _PublishButton extends StatelessWidget {
  const _PublishButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: context.l10n.storyShare,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 54,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppGradients.brand,
            boxShadow: AppShadows.brand,
          ),
          child: const AppIcon(AppIcons.share, color: Colors.white),
        ),
      ),
    );
  }
}
