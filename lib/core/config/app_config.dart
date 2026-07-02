/// Build flavor for We36.
enum Flavor { dev, prod }

/// App-wide, per-flavor configuration.
///
/// `apiBaseUrl` is rooted at the versioned `/v1` path (Constitution VIII).
/// [diEnvironment] selects the DI graph: `'real'` (live backend) or `'fake'`
/// (in-memory, zero-network — used by hermetic tests). Dev/prod default to
/// `'real'` now that the backend is live; the dev host + realtime URL are
/// overridable at launch via `--dart-define=API_BASE_URL=…` (defaults to the
/// local backend at `http://localhost:3000`).
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.bundleId,
    this.apiBaseUrl = '',
    this.realtimeUrl = '',
    this.googleServerClientId = '',
    this.diEnvironment = 'real',
  });

  /// Development flavor (app.we36.dev) — points at the local backend by default.
  const AppConfig.dev()
    : flavor = Flavor.dev,
      appName = 'We36 Dev',
      bundleId = 'app.we36.dev',
      apiBaseUrl = const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:3000/v1',
      ),
      realtimeUrl = const String.fromEnvironment(
        'REALTIME_URL',
        defaultValue: 'http://localhost:3000',
      ),
      diEnvironment = const String.fromEnvironment(
        'DI_ENV',
        defaultValue: 'real',
      ),
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
      diEnvironment = 'real',
      // TODO(prod): swap for a prod-specific Web client ID before release.
      googleServerClientId =
          '606535223915-8e3ir2c10skgsf9agvmrb7o8tvqqbrrk.apps.googleusercontent.com';

  final Flavor flavor;
  final String appName;
  final String bundleId;
  final String apiBaseUrl;
  final String realtimeUrl;

  /// DI graph selector: `'real'` (live backend) or `'fake'` (in-memory).
  final String diEnvironment;

  /// Google **Web** client ID used as `serverClientId` for `google_sign_in`, so
  /// the returned id_token's audience matches the backend's accepted list.
  final String googleServerClientId;

  bool get isDev => flavor == Flavor.dev;
}
