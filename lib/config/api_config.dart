class ApiConfig {
  /// Override at build time for Android emulator:
  /// flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static Uri closetUri() => Uri.parse('$baseUrl/closet');
}
