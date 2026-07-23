import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:we36/core/constants/app_routes.dart';
import 'package:we36/core/presentation/app_button.dart';
import 'package:we36/core/presentation/app_icon.dart';
import 'package:we36/core/presentation/app_icon_button.dart';
import 'package:we36/core/presentation/pressable.dart';
import 'package:we36/core/presentation/top_bar.dart';
import 'package:we36/core/services/photo_library_service.dart';
import 'package:we36/core/theme/app_colors_x.dart';
import 'package:we36/core/theme/app_dimens.dart';
import 'package:we36/core/utils/l10n_extension.dart';
import 'package:we36/features/compose/domain/models/filter_matrices.dart';
import 'package:we36/features/compose/domain/models/media_edit_state.dart';
import 'package:we36/features/compose/presentation/cubit/compose_cubit.dart';
import 'package:we36/features/compose/presentation/cubit/compose_state.dart';
import 'package:we36/features/compose/presentation/cubit/gallery_cubit.dart';
import 'package:we36/features/compose/presentation/widgets/adjust_slider.dart';
import 'package:we36/features/compose/presentation/widgets/filter_row.dart';

/// Step 2 (Screen 12): edit the active photo — a full-bleed square preview, the
/// preset-filter strip, and brightness/contrast/warmth sliders stacked together
/// (no tabs, matching the mockup) — all previewed live via `ColorFilter.matrix`
/// (the same matrix the isolate bakes at publish, R3). Edits are per-photo (Q4).
class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool _cropMode = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final compose = context.watch<ComposeCubit>();
    final draft = compose.state.draftOrNull;
    final library = context.read<GalleryCubit>().library;
    final activeIndex = switch (compose.state) {
      ComposeLoaded(:final activeItemIndex) => activeItemIndex,
      _ => 0,
    };
    final items = draft?.items ?? const [];
    if (items.isEmpty) {
      return Scaffold(
        backgroundColor: tokens.bgApp,
        appBar: TopBar(
          title: context.l10n.composeEditTitle,
          onBack: context.pop,
        ),
        body: const SizedBox.shrink(),
      );
    }

    final index = activeIndex.clamp(0, items.length - 1);
    final item = items[index];
    final edit = item.edit;
    final assetRef = AssetRef(id: item.assetId, width: 0, height: 0);

    if (_cropMode) {
      return _CropView(
        bytesFuture: library.originBytes(assetRef),
        initial: edit.cropRect,
        onCancel: () => setState(() => _cropMode = false),
        onDone: (rect) {
          context.read<ComposeCubit>().setCrop(rect);
          setState(() => _cropMode = false);
        },
      );
    }

    final multi = items.length > 1;

    return Scaffold(
      backgroundColor: tokens.bgApp,
      appBar: TopBar(
        title: context.l10n.composeEditTitle,
        onBack: context.pop,
        actions: [
          AppIconButton(
            icon: AppIcons.plus,
            semanticLabel: context.l10n.composeCrop,
            onPressed: () => setState(() => _cropMode = true),
          ),
          AppButton(
            label: context.l10n.composeNext,
            kind: AppButtonKind.ghost,
            size: AppButtonSize.sm,
            onPressed: () => unawaited(context.push(AppRoutes.composeCaption)),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Full-bleed square on phones (design), but cap the height so the
          // filter strip + sliders always keep room on short/wide viewports.
          final reserved = (multi ? 56.0 : 0.0) + AppSpacing.md + 96 + 140;
          final previewSide = math.min(
            constraints.maxWidth,
            (constraints.maxHeight - reserved).clamp(0.0, constraints.maxWidth),
          );
          return Column(
            children: [
              // Full-bleed square preview — no padding, no rounded corners.
              SizedBox(
                width: double.infinity,
                height: previewSide,
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(FilterMatrices.resolve(edit)),
                  child: Image(
                    image: library.thumbnail(assetRef, pixelSize: 1080),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (multi)
                _ItemStrip(
                  assetIds: [for (final it in items) it.assetId],
                  activeIndex: index,
                  library: library,
                  onSelect: context.read<ComposeCubit>().setActiveItem,
                ),
              const SizedBox(height: AppSpacing.md),
              FilterRow(
                preview: library.thumbnail(assetRef, pixelSize: 160),
                selected: edit.filter,
                onSelect: context.read<ComposeCubit>().setFilter,
              ),
              // Sliders sit below the filter strip, separated by a hairline.
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: tokens.divider)),
                  ),
                  child: _AdjustPanel(
                    edit: edit,
                    cubit: context.read<ComposeCubit>(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Horizontal thumbnail strip to switch the active carousel item (Q4 per-photo
/// editing). The active thumbnail carries a rose border.
class _ItemStrip extends StatelessWidget {
  const _ItemStrip({
    required this.assetIds,
    required this.activeIndex,
    required this.library,
    required this.onSelect,
  });

  final List<String> assetIds;
  final int activeIndex;
  final PhotoLibraryService library;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: assetIds.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final active = i == activeIndex;
          return Pressable(
            onTap: () => onSelect(i),
            child: Semantics(
              selected: active,
              button: true,
              label: 'Photo ${i + 1}',
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: active ? tokens.accent : tokens.border,
                    width: active ? 2 : 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm - 1),
                  child: Image(
                    image: library.thumbnail(
                      AssetRef(id: assetIds[i], width: 0, height: 0),
                      pixelSize: 120,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AdjustPanel extends StatelessWidget {
  const _AdjustPanel({required this.edit, required this.cubit});

  final MediaEditState edit;
  final ComposeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      children: [
        AdjustSlider(
          label: context.l10n.composeAdjustBrightness,
          value: edit.brightness,
          onChanged: cubit.setBrightness,
        ),
        AdjustSlider(
          label: context.l10n.composeAdjustContrast,
          value: edit.contrast,
          onChanged: cubit.setContrast,
        ),
        AdjustSlider(
          label: context.l10n.composeAdjustWarmth,
          value: edit.warmth,
          onChanged: cubit.setWarmth,
        ),
      ],
    );
  }
}

/// Full-screen 4:5 crop stage (`crop_your_image`). The normalized [CropRect] is
/// captured from `onMoved` (image-pixel rect ÷ image size) and applied to the
/// active item; the isolate bake re-applies it at publish (no cropped bytes are
/// persisted — Constitution I/IX).
class _CropView extends StatefulWidget {
  const _CropView({
    required this.bytesFuture,
    required this.initial,
    required this.onCancel,
    required this.onDone,
  });

  final Future<dynamic> bytesFuture;
  final CropRect? initial;
  final VoidCallback onCancel;
  final ValueChanged<CropRect> onDone;

  @override
  State<_CropView> createState() => _CropViewState();
}

class _CropViewState extends State<_CropView> {
  final _controller = CropController();
  Uint8List? _bytes;
  Size? _imageSize;
  Rect? _imageRect;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final result = await widget.bytesFuture;
    // The service returns Result<Uint8List>; read its value defensively.
    final bytes = (result as dynamic).valueOrNull as Uint8List?;
    if (bytes == null) {
      if (mounted) widget.onCancel();
      return;
    }
    // Guard: never let an undecodable file crash the crop stage.
    final ui.Image decoded;
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      decoded = frame.image;
    } on Object {
      if (mounted) widget.onCancel();
      return;
    }
    if (!mounted) return;
    setState(() {
      _bytes = bytes;
      _imageSize = Size(
        decoded.width.toDouble(),
        decoded.height.toDouble(),
      );
    });
  }

  void _confirm() {
    final size = _imageSize;
    final rect = _imageRect;
    if (size == null || rect == null) {
      widget.onCancel();
      return;
    }
    widget.onDone(
      CropRect(
        left: (rect.left / size.width).clamp(0.0, 1.0),
        top: (rect.top / size.height).clamp(0.0, 1.0),
        width: (rect.width / size.width).clamp(0.0, 1.0),
        height: (rect.height / size.height).clamp(0.0, 1.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bytes = _bytes;
    return Scaffold(
      backgroundColor: tokens.bgApp,
      appBar: TopBar(
        title: context.l10n.composeCrop,
        onBack: widget.onCancel,
        actions: [
          AppButton(
            label: context.l10n.composeCropDone,
            kind: AppButtonKind.ghost,
            size: AppButtonSize.sm,
            onPressed: bytes == null ? null : _confirm,
          ),
        ],
      ),
      body: bytes == null
          ? const Center(child: CircularProgressIndicator())
          : Crop(
              image: bytes,
              controller: _controller,
              aspectRatio: 4 / 5,
              baseColor: tokens.bgApp,
              maskColor: tokens.overlay,
              onMoved: (_, imageRect) => _imageRect = imageRect,
              onCropped: (_) {},
            ),
    );
  }
}
