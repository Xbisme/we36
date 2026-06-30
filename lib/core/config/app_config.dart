/// Build flavor for We36.
enum Flavor { dev, prod }

/// App-wide, per-flavor configuration.
///
/// API/realtime endpoints carry **placeholder** hosts (#002): the app runs on
/// fakes until the backend deploys, at which point the real hosts are wired here.
/// `apiBaseUrl` is rooted at the versioned `/v1` path (Constitution VIII).
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.bundleId,
    this.apiBaseUrl = '',
    this.realtimeUrl = '',
    this.googleServerClientId = '',
  });

  /// Development flavor (app.we36.dev).
  const AppConfig.dev()
    : flavor = Flavor.dev,
      appName = 'We36 Dev',
      bundleId = 'app.we36.dev',
      apiBaseUrl = 'https://api.we36.dev/v1',
      realtimeUrl = 'wss://rt.we36.dev',
      // Google **Web** OAuth client ID → id_token audience the backend verifies
      // (GOOGLE_OAUTH_CLIENT_IDS). Required for the Android id_token too.
      googleServerClientId =
          '606535223915-8e3ir2c10skgsf9agvmrb7o8tvqqbrrk.apps.googleusercontent.com';

  /// Production flavor (app.we36).
  const AppConfig.prod()
    : flavor = Flavor.prod,
      appName = 'We36',
      bundleId = 'app.we36',
      apiBaseUrl = 'https://api.we36.app/v1',
      realtimeUrl = 'wss://rt.we36.app',
      // TODO(prod): swap for a prod-specific Web client ID before release.
      googleServerClientId =
          '606535223915-8e3ir2c10skgsf9agvmrb7o8tvqqbrrk.apps.googleusercontent.com';

  final Flavor flavor;
  final String appName;
  final String bundleId;
  final String apiBaseUrl;
  final String realtimeUrl;

  /// Google **Web** client ID used as `serverClientId` for `google_sign_in`, so
  /// the returned id_token's audience matches the backend's accepted list.
  final String googleServerClientId;

  bool get isDev => flavor == Flavor.dev;
}
