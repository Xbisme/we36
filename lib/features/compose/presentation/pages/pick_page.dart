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
import 'package:we36/features/compose/presentation/cubit/compose_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_state.dart';
import 'package:we36/features/compose/presentation/widgets/gallery_grid.dart';

/// Step 1 of the compose flow (Screen 11): pick one or more photos from a
/// custom device gallery grid, then advance to the edit step.
class PickPage extends StatelessWidget {
  const PickPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final gallery = context.watch<GalleryCubit>();
    final state = gallery.state;
    final selected = state.selectedIds;

    return Scaffold(
      backgroundColor: tokens.bgApp,
      appBar: TopBar(
        title: context.l10n.composeTitle,
        onBack: () => context.pop(),
        actions: [
          AppButton(
            label: context.l10n.composeNext,
            kind: AppButtonKind.ghost,
            size: AppButtonSize.sm,
            onPressed: selected.isEmpty
                ? null
                : () {
                    unawaited(
                      context.read<ComposeCubit>().startFromAssets(selected),
                    );
                    unawaited(context.push(AppRoutes.composeEdit));
                  },
          ),
        ],
      ),
      body: switch (state) {
        GalleryError() => _PermissionState(),
        GalleryInitial() || GalleryLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        _ => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                context.l10n.composeRecents,
                style: AppTypography.label.copyWith(color: tokens.textSecondary),
              ),
            ),
            Expanded(
              child: GalleryGrid(
                assets: state.assets,
                selectedIds: selected,
                library: gallery.library,
                onToggle: gallery.toggleSelect,
                onEndReached: gallery.loadMore,
              ),
            ),
          ],
        ),
      },
    );
  }
}

class _PermissionState extends StatelessWidget {
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
          ],
        ),
      ),
    );
  }
}
