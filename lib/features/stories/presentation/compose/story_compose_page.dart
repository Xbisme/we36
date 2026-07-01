import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/stories/presentation/cubit/story_compose_cubit.dart';
import 'package:we36/features/stories/presentation/cubit/story_compose_state.dart';
import 'package:we36/features/stories/presentation/cubit/story_gallery_cubit.dart';

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
                        onPressed: uploading ? null : () => context.pop(),
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
                  LinearProgressIndicator(
                    value: progress == 0 ? null : progress,
                    minHeight: 2,
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
                              : Image(
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
                        ),
                      ),
                    ),
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
                      const AppIcon(AppIcons.profile, color: Colors.white),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        context.l10n.yourStory,
                        style: AppTypography.body16.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      if (uploading)
                        TextButton(
                          onPressed: cubit.cancel,
                          child: Text(context.l10n.composeCancel),
                        ),
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
