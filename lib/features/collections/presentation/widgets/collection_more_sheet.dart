import 'package:flutter/material.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/collections/domain/usecases/manage_collection_usecases.dart';
import 'package:we36/features/collections/presentation/widgets/create_collection_dialog.dart';

enum _ManageAction { rename, delete }

/// The manage-collection action sheet (#011 US4): rename / delete a named
/// collection. Hidden for the "All saved" default (system-managed — FR-003).
/// Deleting keeps the collection's posts saved (SC-006). The sheet only *picks*
/// an action; the dialog + mutation run against the caller's (stable) context so
/// they survive the sheet closing. The reactive drift cache repaints the grid.
class CollectionMoreSheet {
  /// Show the sheet for [collection] (named collections only).
  static Future<void> show(
    BuildContext context,
    SavedCollection collection,
  ) async {
    if (!collection.canManage) return;
    final action = await showModalBottomSheet<_ManageAction>(
      context: context,
      backgroundColor: context.tokens.surface,
      builder: (_) => const _MoreSheet(),
    );
    if (action == null || !context.mounted) return;
    switch (action) {
      case _ManageAction.rename:
        await _rename(context, collection);
      case _ManageAction.delete:
        await _delete(context, collection);
    }
  }

  static Future<void> _rename(
    BuildContext context,
    SavedCollection collection,
  ) async {
    final name = await CreateCollectionDialog.show(
      context,
      initialName: collection.name,
      isRename: true,
    );
    if (name == null || !context.mounted) return;
    final res = await getIt<RenameCollection>()(collection.id, name);
    if (res.isErr && context.mounted) {
      getIt<ToastService>().show(
        context,
        message: context.l10n.collectionUpdateFailed,
      );
    }
  }

  static Future<void> _delete(
    BuildContext context,
    SavedCollection collection,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: dialogContext.tokens.surface,
        title: Text(dialogContext.l10n.collectionDeleteTitle),
        content: Text(dialogContext.l10n.collectionDeleteBody(collection.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(dialogContext.l10n.collectionDeleteAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final res = await getIt<DeleteCollection>()(collection.id);
    if (res.isErr && context.mounted) {
      getIt<ToastService>().show(
        context,
        message: context.l10n.collectionDeleteFailed,
      );
    }
  }
}

class _MoreSheet extends StatelessWidget {
  const _MoreSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const AppIcon(AppIcons.plus),
            title: Text(l10n.collectionRename),
            onTap: () => Navigator.of(context).pop(_ManageAction.rename),
          ),
          ListTile(
            leading: AppIcon(AppIcons.close, color: tokens.error),
            title: Text(
              l10n.collectionDelete,
              style: TextStyle(color: tokens.error),
            ),
            onTap: () => Navigator.of(context).pop(_ManageAction.delete),
          ),
        ],
      ),
    );
  }
}
