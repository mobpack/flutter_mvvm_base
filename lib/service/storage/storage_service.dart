/// Service to handle both regular storage (SharedPreferences) and secure storage (FlutterSecureStorage)
/// Interface for storage service abstraction
abstract class IStorageService {
  /// Stores a string value in regular storage
  Future<bool> setString(String key, String value);

  /// Retrieves a string value from regular storage
  String? getString(String key);

  /// Stores a boolean value in regular storage
  Future<bool> setBool(String key, {required bool value});

  /// Retrieves a boolean value from regular storage
  bool? getBool(String key);

  /// Removes a value from regular storage
  Future<bool> remove(String key);

  /// Stores a string value in secure storage
  Future<void> setSecureString(String key, String value);

  /// Retrieves a string value from secure storage
  Future<String?> getSecureString(String key);

  /// Removes a value from secure storage
  Future<void> removeSecure(String key);

  /// Clears all values from secure storage
  Future<void> clearSecureStorage();

  /// Storage Keys
  static const String themeKey = 'theme_mode';
  static const String userTokenKey = 'user_token';
}
