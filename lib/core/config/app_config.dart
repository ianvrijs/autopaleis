class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'https://api.autopaleis.com';
  static const int apiTimeout = 30000; // milliseconds

  // App Configuration
  static const String appName = 'AutoPaleis';
  static const String appVersion = '1.0.0';

  // Feature Flags
  static const bool enableDebugMode = true;
  static const bool enableAnalytics = false;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}
