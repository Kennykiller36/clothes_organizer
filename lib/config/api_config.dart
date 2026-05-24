import 'api_config_platform.dart'
    if (dart.library.html) 'api_config_platform_web.dart';

class ApiConfig {
  /// Physical phone: use your PC LAN IP, e.g.
  /// flutter run --dart-define=API_BASE_URL=http://192.168.1.10:3000
  static String get baseUrl => platformBaseUrl();

  static Uri closetUri() => Uri.parse('$baseUrl/closet');
}
