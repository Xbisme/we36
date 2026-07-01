import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_dialog.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
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
            child: Column(
              children: [
                // Top row: close + Share/Retry.
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: uploading ? null : () => unawaited(
                          _onClose(draft),
                        ),
                        icon: const AppIcon(AppIcons.close, color: Colors.white),
                      ),
                      const Spacer(),
                      AppButton(
                        label: failed
                            ? context.l10n.composeRetry
                            : context.l10n.storyShare,
                        size: AppButtonSize.sm,
                        onPressed: (draft == null || uploading)
                            ? null
                            : () => unawaited(
                                failed
                                    ? cubit.retry()
                                    : cubit.publish(boundaryKey: _boundaryKey),
                              ),
                      ),
                    ],
                  ),
                ),
                if (uploading)
                  StoryUploadProgress(
                    progress: progress,
                    onCancel: cubit.cancel,
                  ),
                // 9:16 canvas — flattened WYSIWYG at publish (FR-005).
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: RepaintBoundary(
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
                    ),
                  ),
                ),
                // Overlay tools (US2) — hidden while uploading.
                if (draft != null && !uploading)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        _ToolButton(
                          icon: AppIcons.sticker,
                          label: context.l10n.storyAddText,
                          onTap: () => unawaited(_addText()),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        _ToolButton(
                          icon: AppIcons.plus,
                          label: context.l10n.storyStickers,
                          onTap: () => unawaited(_addSticker()),
                        ),
                      ],
                    ),
                  ),
                // Footer: audience (default "Your story"; toggle arrives US3).
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      if (draft != null && !uploading)
                        AudienceToggle(
                          value: draft.audience,
                          onChanged: cubit.setAudience,
                        )
                      else
                        Text(
                          context.l10n.yourStory,
                          style: AppTypography.body16.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      const Spacer(),
                    ],
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

/// A compact icon+label story tool (Add text / Stickers) on the dark canvas.
class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: AppIcon(icon, size: 18, color: Colors.white),
      label: Text(
        label,
        style: AppTypography.label.copyWith(color: Colors.white),
      ),
    );
  }
}
