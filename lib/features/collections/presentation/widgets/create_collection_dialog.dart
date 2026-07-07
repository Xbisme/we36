import 'package:flutter/material.dart';
import 'package:we36/core/data/collections/saved_collection.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/utils/l10n_extension.dart';

/// A name-input dialog for creating or renaming a collection (#011 US1/US4).
/// Names are capped at [kCollectionNameMaxLength] and must be non-empty; they are
/// **not** required to be unique (FR-005). Returns the entered name, or null on
/// cancel.
class CreateCollectionDialog extends StatefulWidget {
  const CreateCollectionDialog({
    this.initialName,
    this.isRename = false,
    super.key,
  });

  final String? initialName;
  final bool isRename;

  /// Show the dialog; resolves to the trimmed name, or null if cancelled.
  static Future<String?> show(
    BuildContext context, {
    String? initialName,
    bool isRename = false,
  }) => showDialog<String>(
    context: context,
    builder: (_) =>
        CreateCollectionDialog(initialName: initialName, isRename: isRename),
  );

  @override
  State<CreateCollectionDialog> createState() => _CreateCollectionDialogState();
}

class _CreateCollectionDialogState extends State<CreateCollectionDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialName ?? '',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    return AlertDialog(
      backgroundColor: tokens.surface,
      title: Text(
        widget.isRename
            ? l10n.collectionRenameTitle
            : l10n.collectionCreateTitle,
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: kCollectionNameMaxLength,
        textInputAction: TextInputAction.done,
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(hintText: l10n.collectionNameHint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: _controller.text.trim().isEmpty ? null : _submit,
          child: Text(
            widget.isRename
                ? l10n.collectionRename
                : l10n.collectionCreateAction,
          ),
        ),
      ],
    );
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(name);
  }
}
