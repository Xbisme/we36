import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_state.dart';
import 'package:we36/features/compose/presentation/widgets/gallery_grid.dart';

/// A single-pick photo grid for choosing an avatar (#010 Edit profile). Reuses
/// the compose [GalleryCubit] + [GalleryGrid]; tapping a photo pops the sheet
/// with that [AssetRef], or null when dismissed. The caller reads its bytes and
/// hands them to the upload pipeline.
Future<AssetRef?> showAvatarPickerSheet(BuildContext context) {
  return showModalBottomSheet<AssetRef>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) {
        final cubit = getIt<GalleryCubit>();
        unawaited(cubit.loadInitial());
        return cubit;
      },
      child: const _AvatarPickerSheet(),
    ),
  );
}

class _AvatarPickerSheet extends StatelessWidget {
  const _AvatarPickerSheet();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: tokens.bgApp,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            _Handle(),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                context.l10n.editChangePhoto,
                style: AppTypography.label.copyWith(color: tokens.textPrimary),
              ),
            ),
            Expanded(
              child: BlocBuilder<GalleryCubit, GalleryState>(
                builder: (context, state) {
                  final cubit = context.read<GalleryCubit>();
                  return switch (state) {
                    GalleryError() => _PermissionState(
                      onOpenSettings: () =>
                          cubit.library.openSettings().ignore(),
                    ),
                    GalleryInitial() || GalleryLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    _ when state.assets.isEmpty => Center(
                      child: Text(
                        context.l10n.composeEmptyLibrary,
                        style: AppTypography.body16.copyWith(
                          color: tokens.textSecondary,
                        ),
                      ),
                    ),
                    _ => GalleryGrid(
                      assets: state.assets,
                      selectedIds: const [],
                      library: cubit.library,
                      onToggle: (id) {
                        final asset = state.assets.firstWhere(
                          (a) => a.id == id,
                        );
                        Navigator.of(context).pop(asset);
                      },
                      onEndReached: state.hasMore ? cubit.loadMore : null,
                    ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.tokens.border,
        borderRadius: BorderRadius.circular(2),
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
