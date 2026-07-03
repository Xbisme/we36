import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:we36/core/di/injection.dart';
import 'package:we36/core/utils/app_logger.dart';

/// Configures the platform audio session so reel playback honors the device
/// silent switch (#008 R3 / FR clarification).
///
/// On **iOS**, `video_player` defaults to a `playback` AVAudioSession category
/// that sounds through the hardware mute switch. To honor the switch we set the
/// category to `ambient` (mute-switch-respecting) via a minimal method channel —
/// no new package (research R3: channel-first). On **Android** there is no
/// silent-switch semantic for media; playback follows the media stream volume,
/// so this is a no-op. Reduce-Motion (R6) shows a silent poster regardless.
///
/// Best-effort: any channel failure is logged and swallowed — audio category is
/// not worth crashing the feed over.
class ReelAudioSession {
  const ReelAudioSession();

  static const MethodChannel _channel = MethodChannel('we36/reel_audio');

  /// Set the mute-switch-respecting (`ambient`) audio session category. Call once
  /// when the Reels surface becomes active. No-op off iOS.
  Future<void> configureAmbient() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) return;
    try {
      await _channel.invokeMethod<void>('configureAmbient');
    } on PlatformException catch (e) {
      getIt<AppLogger>().warn(
        'ReelAudioSession.configureAmbient failed: ${e.code}',
      );
    } on MissingPluginException {
      // Channel not registered (e.g. hermetic test host) — safe to ignore.
    }
  }
}
