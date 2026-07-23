import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_dialog.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/compose/domain/models/compose_draft.dart';
import 'package:we36/features/compose/presentation/cubit/compose_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_state.dart';
import 'package:we36/features/compose/presentation/widgets/gallery_grid.dart';

/// Step 1 of the compose flow (Screen 11): pick one or more photos from a
/// custom device gallery grid, then advance to the edit step. On entry it
/// offers to restore a persisted draft (FR-021); backing out with a live draft
/// prompts keep/discard.
class PickPage extends StatefulWidget {
  const PickPage({super.key});

  @override
  State<PickPage> createState() => _PickPageState();
}

class _PickPageState extends State<PickPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeRestore());
  }

  /// If a draft was persisted (app-kill or an abandoned session), ask to resume
  /// it or discard. Restoring drops any items whose device asset is gone.
  Future<void> _maybeRestore() async {
    final compose = context.read<ComposeCubit>();
    if (!await compose.hasStoredDraft()) return;
    if (!mounted) return;
    final resume = await showAppDialog(
      context,
      title: context.l10n.composeDiscardTitle,
      body: context.l10n.composePermissionBody,
      primaryLabel: context.l10n.composeDiscardKeep,
      secondaryLabel: context.l10n.composeDiscardDiscard,
      destructive: true,
    );
    if (!mounted) return;
    if (resume) {
      final library = context.read<GalleryCubit>().library;
      final restored = await compose.tryRestore(
        assetStillExists: (id) async =>
            (await library.originBytes(
              AssetRef(id: id, width: 0, height: 0),
            )).valueOrNull !=
            null,
      );
      if (restored && mounted) unawaited(context.push(AppRoutes.composeEdit));
    } else {
      await compose.discard();
    }
  }

  /// Backing out of the flow entry — clear a live draft after confirmation.
  Future<void> _onExit() async {
    final compose = context.read<ComposeCubit>();
    final draft = compose.state.draftOrNull;
    if (draft == null || draft.items.isEmpty) {
      if (mounted) context.pop();
      return;
    }
    final keep = await showAppDialog(
      context,
      title: context.l10n.composeDiscardTitle,
      body: context.l10n.composePermissionBody,
      primaryLabel: context.l10n.composeDiscardKeep,
      secondaryLabel: context.l10n.composeDiscardDiscard,
      destructive: true,
    );
    if (!mounted) return;
    if (!keep) {
      await compose.discard();
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final gallery = context.watch<GalleryCubit>();
    final state = gallery.state;
    final selected = state.selectedIds;
    final heroId = selected.isNotEmpty
        ? selected.first
        : (state.assets.isNotEmpty ? state.assets.first.id : null);

    return Scaffold(
      backgroundColor: tokens.bgApp,
      appBar: TopBar(
        title: context.l10n.composeTitle,
        onBack: () => unawaited(_onExit()),
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
        GalleryError() => _PermissionState(
          onOpenSettings: () => unawaited(gallery.library.openSettings()),
        ),
        GalleryInitial() || GalleryLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        _ => LayoutBuilder(
          builder: (context, constraints) {
            // Full-bleed square hero on phones (design), but cap its height so
            // the grid keeps room on short/wide viewports (tablet, landscape).
            final heroSide = math.min(
              constraints.maxWidth,
              (constraints.maxHeight - 168).clamp(0.0, constraints.maxWidth),
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (heroId != null)
                  SizedBox(
                    width: double.infinity,
                    height: heroSide,
                    child: _HeroPreview(
                      image: gallery.library.thumbnail(
                        AssetRef(id: heroId, width: 0, height: 0),
                        pixelSize: 1080,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Text(
                        context.l10n.composeRecents,
                        style: AppTypography.label.copyWith(
                          color: tokens.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          AppIcon(
                            AppIcons.camera,
                            size: 22,
                            color: tokens.icon,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          AppIcon(AppIcons.reels, size: 22, color: tokens.icon),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GalleryGrid(
                    assets: state.assets,
                    selectedIds: selected,
                    library: gallery.library,
                    onToggle: (id) {
                      if (!gallery.toggleSelect(id)) {
                        getIt<ToastService>().show(
                          context,
                          message: context.l10n.composeMaxReached(
                            kCarouselMaxItems,
                          ),
                        );
                      }
                    },
                    onEndReached: gallery.loadMore,
                  ),
                ),
              ],
            );
          },
        ),
      },
    );
  }
}

/// Full-bleed square hero of the selected photo with a translucent "Carousel"
/// chip top-right (Screen 11). Colour earns its place only on the chip scrim.
class _HeroPreview extends StatelessWidget {
  const _HeroPreview({required this.image});

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image(image: image, fit: BoxFit.cover, gaplessPlayback: true),
        Positioned(
          top: AppSpacing.md,
          right: AppSpacing.md,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: tokens.overlay,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon(
                  AppIcons.plus,
                  size: 14,
                  color: tokens.textOnBrand,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  context.l10n.composeCarousel,
                  style: AppTypography.caption.copyWith(
                    color: tokens.textOnBrand,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
