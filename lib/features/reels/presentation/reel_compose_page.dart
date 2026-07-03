import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/toast.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/reels/presentation/cubit/reel_compose_cubit.dart';
import 'package:we36/features/reels/presentation/cubit/reel_compose_state.dart';

/// Create-reel flow (#008): pick a video → caption/options → publish. Nav-less
/// full-screen (contextual Create action). Reduce-scope: pick + caption + upload
/// (no trim/cover/filter).
class ReelComposePage extends StatelessWidget {
  const ReelComposePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<ReelComposeCubit, ReelComposeState>(
      listenWhen: (a, b) => b is ReelComposePublished || b is ReelComposeError,
      listener: (context, state) {
        if (state is ReelComposePublished) {
          getIt<ToastService>().show(
            context,
            message: l10n.reelProcessing,
            tone: ToastTone.success,
          );
          if (context.canPop()) context.pop();
        } else if (state is ReelComposeError && state.draft != null) {
          getIt<ToastService>().show(
            context,
            message: l10n.reelPublishFailed,
            tone: ToastTone.error,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ReelComposeCubit>();
        final draft = state.draft;
        return PopScope(
          canPop: draft == null,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            final discard = await _confirmDiscard(context);
            if (discard && context.mounted && context.canPop()) context.pop();
          },
          child: Scaffold(
            backgroundColor: context.tokens.bgApp,
            appBar: AppBar(
              title: Text(l10n.reelComposeTitle),
              leading: IconButton(
                icon: const AppIcon(AppIcons.close),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            body: switch (state) {
              ReelComposeLoading() || ReelComposeInitial() => const Center(
                child: CircularProgressIndicator(),
              ),
              ReelComposeError(:final draft) when draft == null =>
                _PermissionOrError(
                  onRetry: cubit.loadInitial,
                ),
              ReelComposeLoadedUploading(:final fraction) => _Uploading(
                fraction: fraction,
                onCancel: cubit.cancel,
              ),
              _ when draft == null => _VideoGrid(
                videos: state.videos,
                onPick: (ref) => _pick(context, ref),
              ),
              _ => _Editor(),
            },
          ),
        );
      },
    );
  }

  void _pick(BuildContext context, AssetRef ref) {
    final failure = context.read<ReelComposeCubit>().pickVideo(ref);
    if (failure != null) {
      getIt<ToastService>().show(
        context,
        message: context.l10n.reelComposeTooLong,
        tone: ToastTone.error,
      );
    }
  }

  Future<bool> _confirmDiscard(BuildContext context) async {
    final l10n = context.l10n;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.reelComposeDiscard),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.reelComposeCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.reelDelete),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _VideoGrid extends StatelessWidget {
  const _VideoGrid({required this.videos, required this.onPick});
  final List<AssetRef> videos;
  final void Function(AssetRef) onPick;

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) {
      return Center(child: Text(context.l10n.reelComposePick));
    }
    final library = getIt<PhotoLibraryService>();
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.xs),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 9 / 16,
      ),
      itemCount: videos.length,
      itemBuilder: (context, i) {
        final ref = videos[i];
        return Semantics(
          button: true,
          label: 'Video ${i + 1}',
          child: GestureDetector(
            onTap: () => onPick(ref),
            child: Image(
              image: library.thumbnail(ref),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

class _Editor extends StatefulWidget {
  @override
  State<_Editor> createState() => _EditorState();
}

class _EditorState extends State<_Editor> {
  final _caption = TextEditingController();

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ReelComposeCubit>();
    final draft = cubit.state.draft;
    final library = getIt<PhotoLibraryService>();
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        if (draft != null)
          AspectRatio(
            aspectRatio: 9 / 16,
            child: Image(
              image: library.thumbnail(
                AssetRef(id: draft.videoAssetId, width: 0, height: 0),
                pixelSize: 512,
              ),
              fit: BoxFit.cover,
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _caption,
          onChanged: cubit.setCaption,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: l10n.reelComposeCaptionHint,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile(
          title: Text(l10n.commentsDisabledNotice),
          value: draft?.commentsDisabled ?? false,
          onChanged: (v) => cubit.toggleComments(disabled: v),
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: cubit.publish,
          child: Text(l10n.reelComposePublish),
        ),
      ],
    );
  }
}

class _Uploading extends StatelessWidget {
  const _Uploading({required this.fraction, required this.onCancel});
  final double fraction;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.reelComposeUploading),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              value: fraction == 0 ? null : fraction,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onCancel, child: Text(l10n.reelComposeCancel)),
        ],
      ),
    );
  }
}

class _PermissionOrError extends StatelessWidget {
  const _PermissionOrError({required this.onRetry});
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.reelComposePick),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onRetry, child: Text(l10n.reelRetry)),
        ],
      ),
    );
  }
}
