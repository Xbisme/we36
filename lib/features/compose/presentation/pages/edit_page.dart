import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/compose/presentation/cubit/compose_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/compose_state.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_cubit.dart';

/// Step 2 (Screen 12): edit the selected photo(s). US1 ships a pass-through
/// (4:5 preview + Next); filters/crop/adjustments are added in US2.
class EditPage extends StatelessWidget {
  const EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final compose = context.watch<ComposeCubit>();
    final draft = compose.state.draftOrNull;
    final library = context.read<GalleryCubit>().library;
    final activeIndex = switch (compose.state) {
      ComposeLoaded(:final activeItemIndex) => activeItemIndex,
      _ => 0,
    };
    final items = draft?.items ?? const [];

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
            onPressed: items.isEmpty
                ? null
                : () => unawaited(context.push(AppRoutes.composeCaption)),
          ),
        ],
      ),
      body: items.isEmpty
          ? const SizedBox.shrink()
          : Center(
              child: AspectRatio(
                aspectRatio: 4 / 5,
                child: Image(
                  image: library.thumbnail(
                    AssetRef(
                      id: items[activeIndex.clamp(0, items.length - 1)].assetId,
                      width: 0,
                      height: 0,
                    ),
                    pixelSize: 1080,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
    );
  }
}
