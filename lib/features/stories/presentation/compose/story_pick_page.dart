import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/stories/presentation/compose/story_compose_page.dart';
import 'package:we36/features/stories/presentation/cubit/story_compose_cubit.dart';
import 'package:we36/features/stories/presentation/cubit/story_gallery_cubit.dart';
import 'package:we36/features/stories/presentation/cubit/story_gallery_state.dart';
import 'package:we36/features/stories/presentation/widgets/story_gallery_grid.dart';

/// Step 1 of the create-story flow (Screen 9): pick one photo from the device
/// gallery, then advance to the compose canvas. Single-select, no persisted
/// draft (#005). Nav-less full-screen; centered on tablet.
class StoryPickPage extends StatelessWidget {
  const StoryPickPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final gallery = context.watch<StoryGalleryCubit>();
    final state = gallery.state;
    final selectedId = state.selectedId;

    return Scaffold(
      backgroundColor: tokens.bgApp,
      appBar: TopBar(
        title: context.l10n.yourStory,
        onBack: () => context.pop(),
        actions: [
          AppButton(
            label: context.l10n.composeNext,
            kind: AppButtonKind.ghost,
            size: AppButtonSize.sm,
            onPressed: selectedId == null
                ? null
                : () {
                    context.read<StoryComposeCubit>().startFromAsset(
                      selectedId,
                    );
                    unawaited(context.push(AppRoutes.storyCompose));
                  },
          ),
        ],
      ),
      body: switch (state) {
        StoryGalleryError() => _PermissionState(
          onOpenSettings: () => unawaited(gallery.library.openSettings()),
        ),
        StoryGalleryInitial() || StoryGalleryLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        _ when state.assets.isEmpty => _EmptyLibrary(),
        _ => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                context.l10n.composeRecents,
                style: AppTypography.label.copyWith(
                  color: tokens.textSecondary,
                ),
              ),
            ),
            Expanded(
              child: StoryGalleryGrid(
                assets: state.assets,
                selectedId: selectedId,
                library: gallery.library,
                onSelect: gallery.select,
                onEndReached: gallery.loadMore,
              ),
            ),
          ],
        ),
      },
    );
  }
}

class _EmptyLibrary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Text(
        context.l10n.composeEmptyLibrary,
        style: AppTypography.body16.copyWith(color: tokens.textSecondary),
      ),
    );
  }
}

class _PermissionState extends StatelessWidget {
  const _PermissionState({required this.onOpenSettings});

  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(AppIcons.camera, size: 40, color: tokens.textTertiary),
            const SizedBox(height: 16),
            Text(
              context.l10n.composePermissionTitle,
              style: AppTypography.h3.copyWith(color: tokens.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.composePermissionBody,
              style: AppTypography.body16.copyWith(color: tokens.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            AppButton(
              label: context.l10n.composeOpenSettings,
              onPressed: onOpenSettings,
            ),
          ],
        ),
      ),
    );
  }
}
