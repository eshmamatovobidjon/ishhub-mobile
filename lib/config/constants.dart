class AppConstants {
  static const String appName = 'IshHub';

  /// Base API URL. Backend dev port is 8765 (8000 conflicts with autowash).
  /// Override at build time:
  ///   flutter run --dart-define=API_BASE=https://api.ishhub.uz/api/v1
  ///
  /// Default uses 10.0.2.2 which is the Android emulator alias for the host
  /// machine's localhost. iOS simulator can use localhost directly.
  static const String apiBase = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://10.0.2.2:8765/api/v1',
  );

  static const String wsBase = String.fromEnvironment(
    'WS_BASE',
    defaultValue: 'ws://10.0.2.2:8765/ws',
  );

  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');
  static const String sentryEnvironment = String.fromEnvironment(
    'SENTRY_ENVIRONMENT',
    defaultValue: 'local',
  );
  static const String sentryRelease = String.fromEnvironment('SENTRY_RELEASE');
  static const String _sentryTracesSampleRate = String.fromEnvironment(
    'SENTRY_TRACES_SAMPLE_RATE',
    defaultValue: '0',
  );
  static final double sentryTracesSampleRate =
      double.tryParse(_sentryTracesSampleRate) ?? 0;

  // Storage keys
  static const String kAccessToken = 'access_token';
  static const String kRefreshToken = 'refresh_token';
  static const String kLocale = 'locale';
  static const String kThemeMode = 'theme_mode';
}
