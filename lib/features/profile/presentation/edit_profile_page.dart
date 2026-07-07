import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_dialog.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_text_field.dart';
import 'package:we36/core/presentation/avatar.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/profile/presentation/cubit/edit_profile_cubit.dart';
import 'package:we36/features/profile/presentation/cubit/edit_profile_state.dart';
import 'package:we36/features/profile/presentation/widgets/avatar_picker_sheet.dart';

/// Edit my profile (#010 Screen 23): name / username (live availability) /
/// pronouns / website / bio + change photo, with optimistic save + discard-confirm.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({this.initialAvatarUrl, super.key});

  /// The current (server-resolved) avatar URL, shown as the form's initial
  /// preview until the user picks a new photo. Null when unset/unresolved.
  final String? initialAvatarUrl;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _pronouns = TextEditingController();
  final _website = TextEditingController();
  final _bio = TextEditingController();
  bool _seeded = false;

  /// Bytes of the just-picked avatar, shown as a local preview until save (the
  /// server avatar URL is not resolved into the Edit form).
  Uint8List? _pickedAvatar;

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _pronouns.dispose();
    _website.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _seed(EditProfileEditing s) {
    if (_seeded) return;
    _seeded = true;
    _name.text = s.displayName;
    _username.text = s.username;
    _pronouns.text = s.pronouns ?? '';
    _website.text = s.website ?? '';
    _bio.text = s.bio ?? '';
  }

  Future<bool> _confirmDiscard(BuildContext context) async {
    final s = context.read<EditProfileCubit>().state;
    final dirty = s is EditProfileEditing && s.dirty;
    if (!dirty) return true;
    final l10n = context.l10n;
    return showAppDialog(
      context,
      title: l10n.editDiscardTitle,
      body: l10n.editDiscardBody,
      primaryLabel: l10n.editDiscardAction,
      secondaryLabel: l10n.commonCancel,
      destructive: true,
    );
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final ok = await context.read<EditProfileCubit>().save();
    if (!mounted) return;
    if (ok) {
      getIt<ToastService>().show(context, message: l10n.editSavedAck);
      context.pop();
    } else {
      getIt<ToastService>().show(context, message: l10n.editSaveFailed);
    }
  }

  Future<void> _changePhoto() async {
    final cubit = context.read<EditProfileCubit>();
    final lib = getIt<PhotoLibraryService>();
    // Present the single-pick photo grid; null = dismissed without choosing.
    final asset = await showAvatarPickerSheet(context);
    if (asset == null) return;
    final bytes = await lib.originBytes(asset);
    if (!mounted) return;
    if (bytes.isErr) {
      getIt<ToastService>().show(context, message: context.l10n.editSaveFailed);
      return;
    }
    setState(() => _pickedAvatar = bytes.valueOrNull);
    final ok = await cubit.changeAvatar(bytes.valueOrNull!);
    if (!ok && mounted) {
      getIt<ToastService>().show(context, message: context.l10n.editSaveFailed);
    }
  }

  String? _usernameError(EditProfileEditing s, AppLocalizations l10n) =>
      switch (s.usernameStatus) {
        UsernameStatus.taken => l10n.editUsernameTaken,
        UsernameStatus.invalid => l10n.editUsernameTaken,
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmDiscard(context) && context.mounted) context.pop();
      },
      child: Scaffold(
        backgroundColor: tokens.bgApp,
        appBar: AppBar(
          backgroundColor: tokens.bgApp,
          leading: IconButton(
            icon: const AppIcon(AppIcons.back),
            onPressed: () async {
              if (await _confirmDiscard(context) && context.mounted) {
                context.pop();
              }
            },
          ),
          title: Text(
            l10n.profileEditProfile,
            style: AppTypography.h3.copyWith(color: tokens.textPrimary),
          ),
          actions: [
            BlocBuilder<EditProfileCubit, EditProfileState>(
              builder: (context, state) => IconButton(
                icon: AppIcon(
                  AppIcons.check,
                  color: state.canSave ? tokens.accent : tokens.textTertiary,
                ),
                onPressed: state.canSave ? () => unawaited(_save()) : null,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<EditProfileCubit, EditProfileState>(
            builder: (context, state) => switch (state) {
              EditProfileEditing() => _form(context, state),
              EditProfileError() => Center(child: Text(l10n.profileError)),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ),
      ),
    );
  }

  Widget _form(BuildContext context, EditProfileEditing state) {
    _seed(state);
    final l10n = context.l10n;
    final cubit = context.read<EditProfileCubit>();
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Avatar(
                    size: 88,
                    image: _pickedAvatar != null
                        ? MemoryImage(_pickedAvatar!)
                        : (widget.initialAvatarUrl == null
                              ? null
                              : NetworkImage(widget.initialAvatarUrl!)),
                    semanticLabel: l10n.editChangePhoto,
                  ),
                  if (state.avatarUploading)
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              TextButton(
                onPressed: state.avatarUploading
                    ? null
                    : () => unawaited(_changePhoto()),
                child: Text(l10n.editChangePhoto),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: l10n.editName,
          controller: _name,
          onChanged: cubit.updateDisplayName,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: l10n.editUsername,
          controller: _username,
          errorText: _usernameError(state, l10n),
          onChanged: (v) => unawaited(cubit.updateUsername(v)),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: l10n.editPronouns,
          controller: _pronouns,
          onChanged: cubit.updatePronouns,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: l10n.editWebsite,
          controller: _website,
          keyboardType: TextInputType.url,
          onChanged: cubit.updateWebsite,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: l10n.editBio,
          controller: _bio,
          onChanged: cubit.updateBio,
        ),
      ],
    );
  }
}
