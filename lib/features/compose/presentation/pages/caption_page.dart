import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_text_field.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/compose/domain/models/compose_draft.dart';
import 'package:we36/features/compose/presentation/cubit/compose_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/compose_state.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_cubit.dart';

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
                label: context.l10n.composeShare,
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
                      LinearProgressIndicator(
                        value: state.progress,
                        color: tokens.accent,
                        backgroundColor: tokens.surface2,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (firstAssetId != null)
                            SizedBox(
                              width: 64,
                              height: 80,
                              child: Image(
                                image: library.thumbnail(
                                  AssetRef(id: firstAssetId, width: 0, height: 0),
                                  pixelSize: 160,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              label: context.l10n.composeCaptionHint,
                              controller: _controller,
                              enabled: !uploading,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(kCaptionMaxLength),
                              ],
                              onChanged: context.read<ComposeCubit>().setCaption,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
