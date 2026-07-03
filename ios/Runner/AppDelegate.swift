import AVFoundation
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    let registry = engineBridge.pluginRegistry
    GeneratedPluginRegistrant.register(with: registry)

    // Reels audio (#008 R3): set a mute-switch-respecting AVAudioSession category
    // so reel video honors the hardware silent switch (video_player defaults to
    // `playback`, which sounds through it). Channel-first — no extra package.
    let messenger = registry.registrar(forPlugin: "ReelAudio")!.messenger()
    let audioChannel = FlutterMethodChannel(name: "we36/reel_audio", binaryMessenger: messenger)
    audioChannel.setMethodCallHandler { call, result in
      switch call.method {
      case "configureAmbient":
        do {
          try AVAudioSession.sharedInstance().setCategory(.ambient)
          result(nil)
        } catch {
          result(FlutterError(code: "AUDIO_SESSION", message: error.localizedDescription, details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
