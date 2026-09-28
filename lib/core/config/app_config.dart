class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8787',
  );

  static const String loginPath = '/api/auth/login';
  static const String registerPath = '/api/auth/register';
  static const String refreshPath = '/api/auth/refresh';
  static const String logoutPath = '/api/auth/logout';
  static const String mePath = '/api/auth/me';
  static const String marketsPath = '/api/markets';
  static const String weatherPath = '/api/weather';
  static const String newsPath = '/api/news';

  static const Duration connectTimeout = Duration(seconds: 12);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const String logTag = '[AgriBoard]';
  static const String demoEmail = 'demo@agriboard.tg';
  static const String demoPassword = 'demo1234';
}
