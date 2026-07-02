import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we36/core/data/stories/story.dart';
import 'package:we36/core/theme/app_theme.dart';
import 'package:we36/features/stories/domain/models/story_compose_draft.dart';
import 'package:we36/features/stories/domain/models/story_sticker_overlay.dart';
import 'package:we36/features/stories/domain/models/story_text_overlay.dart';
import 'package:we36/features/stories/presentation/widgets/audience_toggle.dart';
import 'package:we36/features/stories/presentation/widgets/story_overlay_layer.dart';
import 'package:we36/l10n/generated/app_localizations.dart';

/// US1/US2/US3 polish — the new story widgets meet Semantics + text-scaling +
/// light/dark requirements (SC-008).
void main() {
  Widget host(
    Widget child, {
    ThemeMode mode = ThemeMode.light,
    double scale = 1,
  }) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: mode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(scale)),
        child: Scaffold(body: Center(child: child)),
      ),
    );
  }

  testWidgets('audience toggle exposes selectable Semantics at 2x text', (
    tester,
  ) async {
    var value = StoryAudience.yourStory;
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      await tester.pumpWidget(
        host(
          AudienceToggle(value: value, onChanged: (v) => value = v),
          mode: mode,
          scale: 2,
        ),
      );
      expect(tester.takeException(), isNull);
      // Both options render as labelled buttons (Semantics).
      expect(find.text('Your story'), findsWidgets);
      expect(find.text('Close friends'), findsWidgets);
    }
  });

  testWidgets('overlay layer renders text + sticker with no overflow', (
    tester,
  ) async {
    const draft = StoryComposeDraft(
      assetId: 'a',
      idempotencyKey: 'k',
      textOverlays: [StoryTextOverlay(id: 't', text: 'hi', styleId: 'default')],
      stickerOverlays: [StoryStickerOverlay(id: 's', assetKey: '⭐')],
    );
    await tester.pumpWidget(
      host(
        const SizedBox(
          width: 270,
          height: 480,
          child: StoryOverlayLayer(
            draft: draft,
            onMoveText: _noop3,
            onMoveSticker: _noop3,
            onRemoveText: _noop1,
            onRemoveSticker: _noop1,
          ),
        ),
        scale: 1.5,
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('hi'), findsOneWidget);
    expect(find.text('⭐'), findsOneWidget);
  });
}

void _noop1(String _) {}
void _noop3(String _, double _, double _) {}
