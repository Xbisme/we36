import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/data/social/follow_request.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/domain/app_failure.dart';
import 'package:we36/core/domain/app_state.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/settings/presentation/cubit/follow_requests_cubit.dart';
import 'package:we36/features/settings/presentation/widgets/request_tile.dart';

/// The follow-request approval inbox (#014 US2). Lists pending requests with
/// optimistic Approve/Decline; a rolled-back action toasts.
class FollowRequestsPage extends StatefulWidget {
  const FollowRequestsPage({super.key});

  @override
  State<FollowRequestsPage> createState() => _FollowRequestsPageState();
}

class _FollowRequestsPageState extends State<FollowRequestsPage> {
  StreamSubscription<AppFailure>? _errorSub;
  bool _wired = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_wired) return;
    _wired = true;
    final cubit = context.read<FollowRequestsCubit>();
    unawaited(cubit.load());
    _errorSub = cubit.errors.listen((_) {
      if (!mounted) return;
      getIt<ToastService>().show(
        context,
        message: context.l10n.followRequestActionFailed,
        tone: ToastTone.error,
      );
    });
  }

  @override
  void dispose() {
    unawaited(_errorSub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.tokens;
    final cubit = context.read<FollowRequestsCubit>();

    return Scaffold(
      backgroundColor: tokens.bgApp,
      appBar: TopBar(
        title: l10n.followRequestsTitle,
        large: true,
        onBack: () => context.pop(),
      ),
      body: BlocBuilder<FollowRequestsCubit, AppState<List<FollowRequest>>>(
        builder: (context, state) {
          return switch (state) {
            AppLoading() || AppInitial() => const Center(
              child: CircularProgressIndicator(),
            ),
            AppError() => _Message(
              title: l10n.followRequestsError,
              onRetry: cubit.load,
              retryLabel: l10n.activityRetry,
            ),
            AppLoaded(:final data) =>
              data.isEmpty
                  ? _Message(
                      title: l10n.followRequestsEmpty,
                      body: l10n.followRequestsEmptyBody,
                    )
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, i) {
                        final request = data[i];
                        return RequestTile(
                          request: request,
                          onApprove: () => cubit.approve(request),
                          onDecline: () => cubit.decline(request),
                        );
                      },
                    ),
          };
        },
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.title,
    this.body,
    this.onRetry,
    this.retryLabel,
  });

  final String title;
  final String? body;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTypography.label.copyWith(color: tokens.textPrimary),
              textAlign: TextAlign.center,
            ),
            if (body != null) ...[
              const SizedBox(height: 8),
              Text(
                body!,
                style: AppTypography.body16.copyWith(
                  color: tokens.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null && retryLabel != null) ...[
              const SizedBox(height: 16),
              TextButton(onPressed: onRetry, child: Text(retryLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
