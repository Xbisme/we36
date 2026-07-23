import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/app_failure_messages.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_text_field.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/auth/domain/usecases/sign_out.dart';
import 'package:we36/features/auth/presentation/profile_setup/profile_setup_cubit.dart';
import 'package:we36/features/auth/presentation/profile_setup/profile_setup_state.dart';

/// Profile setup (Group A · Screen 6): required username (live availability) +
/// display name, optional bio. No avatar control in this release (upload depends
/// on B#003 Media — design delta, spec FR-026).
class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _username = TextEditingController();
  final _displayName = TextEditingController();
  final _bio = TextEditingController();

  @override
  void initState() {
    super.initState();
    _displayName.addListener(_onFormChanged);
  }

  void _onFormChanged() => setState(() {});

  @override
  void dispose() {
    _username.dispose();
    _displayName.dispose();
    _bio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return BlocProvider<ProfileSetupCubit>(
      create: (_) => getIt<ProfileSetupCubit>(),
      child: Scaffold(
        backgroundColor: tokens.bgApp,
        // Back = abandon registration → sign out → router returns to Sign in.
        appBar: TopBar(
          title: context.l10n.authProfileSetupTitle,
          onBack: () => unawaited(getIt<SignOut>().call()),
        ),
        body: SafeArea(
          child: BlocConsumer<ProfileSetupCubit, ProfileSetupState>(
            listener: (context, state) {
              final failure = state.submitError;
              if (failure != null) {
                getIt<ToastService>().show(
                  context,
                  message: failure.toMessage(context.l10n),
                  tone: ToastTone.error,
                );
              }
            },
            builder: (context, state) {
              final l10n = context.l10n;
              final cubit = context.read<ProfileSetupCubit>();
              final canSubmit =
                  state.usernameAvailable &&
                  _displayName.text.trim().isNotEmpty &&
                  !state.submitting;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    // Title lives in the TopBar; this line frames the fields.
                    Text(
                      l10n.authProfileSetupSubtitle,
                      style: AppTypography.body16.copyWith(
                        color: tokens.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    AppTextField(
                      label: l10n.authUsernameLabel,
                      controller: _username,
                      hint: l10n.authUsernameHint,
                      enabled: !state.submitting,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-z0-9._]')),
                        LengthLimitingTextInputFormatter(30),
                      ],
                      onChanged: cubit.onUsernameChanged,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _UsernameHint(status: state.username),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: l10n.authDisplayNameLabel,
                      controller: _displayName,
                      hint: l10n.authDisplayNameHint,
                      textInputAction: TextInputAction.next,
                      enabled: !state.submitting,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _BioField(
                      label: l10n.authBioLabel,
                      hint: l10n.authBioHint,
                      controller: _bio,
                      enabled: !state.submitting,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    AppButton(
                      label: l10n.authContinueCta,
                      fullWidth: true,
                      onPressed: canSubmit ? () => _submit(context) : null,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    unawaited(
      context.read<ProfileSetupCubit>().submit(
        username: _username.text,
        displayName: _displayName.text,
        bio: _bio.text,
      ),
    );
  }
}

/// Multiline bio input (design A6: min-height ~76). Mirrors [AppTextField]'s
/// bordered, focus-ring styling — the shared atom is single-line only, so this
/// local variant covers the multiline case without touching core.
class _BioField extends StatefulWidget {
  const _BioField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.enabled,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool enabled;

  @override
  State<_BioField> createState() => _BioFieldState();
}

class _BioFieldState extends State<_BioField> {
  late final FocusNode _focus = FocusNode()..addListener(_onFocusChange);
  bool _focused = false;

  void _onFocusChange() {
    if (_focus.hasFocus != _focused) {
      setState(() => _focused = _focus.hasFocus);
    }
  }

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final borderColor = _focused ? tokens.accent : tokens.borderStrong;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTypography.label.copyWith(color: tokens.textPrimary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: _focused
                ? [BoxShadow(color: tokens.accentSoft, spreadRadius: 4)]
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: TextField(
            focusNode: _focus,
            controller: widget.controller,
            enabled: widget.enabled,
            minLines: 3,
            maxLines: 6,
            keyboardType: TextInputType.multiline,
            textAlignVertical: TextAlignVertical.top,
            inputFormatters: [LengthLimitingTextInputFormatter(150)],
            style: AppTypography.body16.copyWith(color: tokens.textPrimary),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
              ),
              hintText: widget.hint,
              hintStyle: AppTypography.body16.copyWith(
                color: tokens.textTertiary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UsernameHint extends StatelessWidget {
  const _UsernameHint({required this.status});

  final UsernameStatus status;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final l10n = context.l10n;
    final (text, color) = switch (status) {
      UsernameStatus.empty => ('', tokens.textTertiary),
      UsernameStatus.checking => (
        l10n.authUsernameChecking,
        tokens.textTertiary,
      ),
      UsernameStatus.available => (l10n.authUsernameAvailable, tokens.success),
      UsernameStatus.taken => (l10n.authUsernameTaken, tokens.error),
      UsernameStatus.invalid => (l10n.authUsernameInvalid, tokens.error),
    };
    if (text.isEmpty) return const SizedBox(height: 18);
    return Text(
      text,
      style: AppTypography.caption.copyWith(color: color),
    );
  }
}
