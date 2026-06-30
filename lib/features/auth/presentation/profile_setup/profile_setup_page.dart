import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/app_failure_messages.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_text_field.dart';
import 'package:we36/core/presentation/toast.dart';
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
        appBar: AppBar(
          backgroundColor: tokens.bgApp,
          elevation: 0,
          // Back = abandon registration → sign out → router returns to Sign in.
          leading: IconButton(
            icon: AppIcon(AppIcons.back, color: tokens.textPrimary),
            onPressed: () => unawaited(getIt<SignOut>().call()),
            tooltip: context.l10n.authSignOut,
          ),
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
                    Text(l10n.authProfileSetupTitle, style: AppTypography.h1),
                    const SizedBox(height: AppSpacing.sm),
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
                    AppTextField(
                      label: l10n.authBioLabel,
                      controller: _bio,
                      hint: l10n.authBioHint,
                      enabled: !state.submitting,
                      inputFormatters: [LengthLimitingTextInputFormatter(150)],
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
