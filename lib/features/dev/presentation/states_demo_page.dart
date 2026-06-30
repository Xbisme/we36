import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we36/core/domain/app_failure_messages.dart';
import 'package:we36/core/domain/app_state.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/dev/presentation/states_demo_cubit.dart';

/// Exercises all four AppState transitions (FR-028a / SC-010).
class StatesDemoPage extends StatelessWidget {
  const StatesDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatesDemoCubit>(
      create: (_) => StatesDemoCubit(),
      child: const _StatesDemoView(),
    );
  }
}

class _StatesDemoView extends StatelessWidget {
  const _StatesDemoView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<StatesDemoCubit>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              title: l10n.devStatesTitle,
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: Center(
                child: BlocBuilder<StatesDemoCubit, AppState<String>>(
                  builder: (context, state) {
                    final label = switch (state) {
                      AppInitial<String>() => l10n.stateInitial,
                      AppLoading<String>() => l10n.stateLoading,
                      AppLoaded<String>(:final data) =>
                        '${l10n.stateLoaded}: $data',
                      AppError<String>(:final failure) =>
                        '${l10n.stateError}: ${failure.toMessage(l10n)}',
                    };
                    final tokens = context.tokens;
                    return Text(
                      label,
                      style: AppTypography.h3.copyWith(
                        color: tokens.textPrimary,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: l10n.stateLoaded,
                      onPressed: cubit.loadSuccess,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      label: l10n.stateError,
                      kind: AppButtonKind.secondary,
                      onPressed: cubit.loadFailure,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      label: l10n.stateInitial,
                      kind: AppButtonKind.ghost,
                      onPressed: cubit.reset,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
