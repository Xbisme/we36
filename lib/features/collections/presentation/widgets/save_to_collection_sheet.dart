import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/data/collections/post_collections_membership.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/collections/presentation/cubit/save_to_collection_cubit.dart';
import 'package:we36/features/collections/presentation/cubit/save_to_collection_state.dart';
import 'package:we36/features/collections/presentation/widgets/create_collection_dialog.dart';

/// The Save-to-collection bottom sheet (#011 US2): pick the collections a post
/// belongs to (checkmark toggles membership optimistically), or create one
/// inline. Reachable from a post/reel "Save to collection" affordance.
class SaveToCollectionSheet extends StatelessWidget {
  const SaveToCollectionSheet({super.key});

  /// Open the sheet for [postId] (provides its own cubit).
  static Future<void> show(BuildContext context, String postId) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: context.tokens.surface,
        builder: (_) => BlocProvider<SaveToCollectionCubit>(
          create: (_) {
            final cubit = getIt<SaveToCollectionCubit>();
            unawaited(cubit.load(postId));
            return cubit;
          },
          child: const SaveToCollectionSheet(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Text(
                l10n.saveToCollectionTitle,
                style: AppTypography.h3.copyWith(color: tokens.textPrimary),
              ),
            ),
            BlocBuilder<SaveToCollectionCubit, SaveToCollectionState>(
              builder: (context, state) => switch (state) {
                SaveToCollectionLoaded(:final membership) => _List(
                  membership: membership,
                ),
                SaveToCollectionError() => Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    l10n.savedError,
                    style: AppTypography.body16.copyWith(
                      color: tokens.textTertiary,
                    ),
                  ),
                ),
                _ => const Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Center(child: CircularProgressIndicator()),
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.membership});
  final PostCollectionsMembership membership;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    final rows = membership.collections
        .where((r) => !r.collection.isDefault)
        .toList();
    return Flexible(
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: AppIcon(AppIcons.plus, color: tokens.accent),
            title: Text(
              l10n.collectionNew,
              style: AppTypography.body16.copyWith(color: tokens.accent),
            ),
            onTap: () => unawaited(_createInline(context)),
          ),
          for (final row in rows)
            ListTile(
              title: Text(
                row.collection.name,
                style: AppTypography.body16.copyWith(color: tokens.textPrimary),
              ),
              trailing: row.contains
                  ? AppIcon(AppIcons.check, color: tokens.accent)
                  : null,
              onTap: () =>
                  unawaited(_toggle(context, row.collection.id, row.contains)),
            ),
        ],
      ),
    );
  }

  Future<void> _toggle(BuildContext context, String id, bool contains) async {
    final ok = await context.read<SaveToCollectionCubit>().toggle(
      id,
      currentlyContains: contains,
    );
    if (!ok && context.mounted) {
      getIt<ToastService>().show(context, message: context.l10n.saveFailed);
    }
  }

  Future<void> _createInline(BuildContext context) async {
    final name = await CreateCollectionDialog.show(context);
    if (name == null || !context.mounted) return;
    final ok = await context.read<SaveToCollectionCubit>().createAndFile(name);
    if (!ok && context.mounted) {
      getIt<ToastService>().show(
        context,
        message: context.l10n.collectionCreateFailed,
      );
    }
  }
}
