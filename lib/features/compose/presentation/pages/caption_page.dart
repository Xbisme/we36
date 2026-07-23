import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_switch.dart';
import 'package:we36/core/presentation/app_text_field.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/theme/app_typography.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/compose/domain/models/compose_draft.dart';
import 'package:we36/features/compose/domain/models/post_metadata.dart';
import 'package:we36/features/compose/presentation/cubit/compose_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/compose_state.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_cubit.dart';
import 'package:we36/features/compose/presentation/widgets/upload_progress.dart';

/// Step 3 (Screen 13): caption + Share. Publishes via [ComposeCubit]; a
/// [BlocListener] handles success (toast + haptic + return to feed) and failure
/// (toast) — side effects never live in the builder (Constitution III/VI).
class CaptionPage extends StatefulWidget {
  const CaptionPage({super.key});

  @override
  State<CaptionPage> createState() => _CaptionPageState();
}

class _CaptionPageState extends State<CaptionPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final library = context.read<GalleryCubit>().library;

    return BlocConsumer<ComposeCubit, ComposeState>(
      listener: (context, state) {
        switch (state) {
          case ComposePublished():
            unawaited(HapticFeedback.lightImpact());
            getIt<ToastService>().show(
              context,
              message: context.l10n.composePublished,
              tone: ToastTone.success,
            );
            context.go(AppRoutes.home);
          case ComposeError():
            getIt<ToastService>().show(
              context,
              message: context.l10n.composeUploadFailed,
              tone: ToastTone.error,
            );
          case _:
            break;
        }
      },
      builder: (context, state) {
        final draft = state.draftOrNull;
        final uploading = state is ComposeLoadedUploading;
        final failed = state is ComposeError;
        final firstAssetId = draft?.items.isNotEmpty ?? false
            ? draft!.items.first.assetId
            : null;

        return Scaffold(
          backgroundColor: tokens.bgApp,
          appBar: TopBar(
            title: context.l10n.composeTitle,
            onBack: uploading ? null : () => context.pop(),
            actions: [
              AppButton(
                // Same idempotency key on retry → no duplicate (FR-018/019).
                // Plain rose text action (ghost) — matches the "Next" actions on
                // the pick/edit steps; never a filled gradient here (Screen 13).
                label: failed
                    ? context.l10n.composeRetry
                    : context.l10n.composeShare,
                kind: AppButtonKind.ghost,
                size: AppButtonSize.sm,
                onPressed: (draft == null || uploading)
                    ? null
                    : () => unawaited(context.read<ComposeCubit>().publish()),
              ),
            ],
          ),
          body: draft == null
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    if (uploading)
                      UploadProgress(
                        progress: state.progress,
                        onCancel: context.read<ComposeCubit>().cancel,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (firstAssetId != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              child: SizedBox(
                                width: 72,
                                height: 72,
                                child: Image(
                                  image: library.thumbnail(
                                    AssetRef(
                                      id: firstAssetId,
                                      width: 0,
                                      height: 0,
                                    ),
                                    pixelSize: 160,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              label: context.l10n.composeCaptionHint,
                              controller: _controller,
                              enabled: !uploading,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(
                                  kCaptionMaxLength,
                                ),
                              ],
                              onChanged: context
                                  .read<ComposeCubit>()
                                  .setCaption,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: tokens.divider),
                    _CaptionOptions(draft: draft, enabled: !uploading),
                  ],
                ),
        );
      },
    );
  }
}

/// Caption-step post options (FR-013/014, Q5): tag people, add location, and a
/// turn-off-commenting toggle. "Also share to Stories" and "Add music" are
/// intentionally hidden in v1.0 (not stubbed).
class _CaptionOptions extends StatelessWidget {
  const _CaptionOptions({required this.draft, required this.enabled});

  final ComposeDraft draft;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final cubit = context.read<ComposeCubit>();
    final l10n = context.l10n;
    final tagged = draft.metadata.taggedUserIds;
    final location = draft.metadata.location;

    return Column(
      children: [
        _OptionRow(
          icon: AppIcons.profile,
          label: l10n.composeTagPeople,
          value: tagged.isEmpty ? null : '${tagged.length}',
          onTap: enabled
              ? () async {
                  final input = await _promptText(
                    context,
                    l10n.composeTagPeople,
                    initial: tagged.join(', '),
                  );
                  if (input == null) return;
                  cubit.setTaggedUsers(
                    input
                        .split(',')
                        .map((s) => s.trim())
                        .where((s) => s.isNotEmpty)
                        .toList(),
                  );
                }
              : null,
        ),
        _OptionRow(
          icon: AppIcons.location,
          label: l10n.composeAddLocation,
          value: location?.label,
          onTap: enabled
              ? () async {
                  final input = await _promptText(
                    context,
                    l10n.composeAddLocation,
                    initial: location?.label ?? '',
                  );
                  if (input == null) return;
                  cubit.setLocation(
                    input.trim().isEmpty ? null : PlaceRef(label: input.trim()),
                  );
                }
              : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              AppIcon(AppIcons.comment, size: 20, color: tokens.icon),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  l10n.composeTurnOffComments,
                  style: AppTypography.body16.copyWith(
                    color: tokens.textPrimary,
                  ),
                ),
              ),
              AppSwitch(
                value: draft.metadata.commentsDisabled,
                semanticLabel: l10n.composeTurnOffComments,
                onChanged: enabled
                    ? (v) => cubit.toggleComments(disabled: v)
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Pressable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            AppIcon(icon, size: 20, color: tokens.icon),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTypography.body16.copyWith(color: tokens.textPrimary),
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: AppTypography.label.copyWith(
                  color: tokens.textSecondary,
                ),
              ),
            const SizedBox(width: AppSpacing.sm),
            AppIcon(
              AppIcons.chevronRight,
              size: 16,
              color: tokens.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

/// A minimal single-field text prompt (v1.0 "simple picker" — Q5). Returns the
/// entered text, or null if dismissed.
Future<String?> _promptText(
  BuildContext context,
  String title, {
  String initial = '',
}) {
  final controller = TextEditingController(text: initial);
  final tokens = context.tokens;
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: tokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: AppTypography.h3.copyWith(color: tokens.textPrimary),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(label: title, controller: controller),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: context.l10n.composeCropDone,
              size: AppButtonSize.sm,
              onPressed: () => Navigator.of(dialogContext).pop(controller.text),
            ),
          ],
        ),
      ),
    ),
  );
}
