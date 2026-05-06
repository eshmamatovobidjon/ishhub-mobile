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

  // Storage keys
  static const String kAccessToken = 'access_token';
  static const String kRefreshToken = 'refresh_token';
  static const String kLocale = 'locale';
  static const String kThemeMode = 'theme_mode';
}
