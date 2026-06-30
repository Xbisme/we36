/// Build flavor for We36.
enum Flavor { dev, prod }

/// App-wide, per-flavor configuration.
///
/// The API/realtime endpoints are intentionally empty in this spec (#001):
/// networking lands in #002. They exist here only as reserved slots.
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.bundleId,
    this.apiBaseUrl = '',
    this.realtimeUrl = '',
  });

  /// Development flavor (app.we36.dev).
  const AppConfig.dev()
    : flavor = Flavor.dev,
      appName = 'We36 Dev',
      bundleId = 'app.we36.dev',
      apiBaseUrl = '',
      realtimeUrl = '';

  /// Production flavor (app.we36).
  const AppConfig.prod()
    : flavor = Flavor.prod,
      appName = 'We36',
      bundleId = 'app.we36',
      apiBaseUrl = '',
      realtimeUrl = '';

  final Flavor flavor;
  final String appName;
  final String bundleId;
  final String apiBaseUrl;
  final String realtimeUrl;

  bool get isDev => flavor == Flavor.dev;
}
