import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to handle both regular storage (SharedPreferences) and secure storage (FlutterSecureStorage)
class StorageService {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  StorageService(this._prefs)
      : _secureStorage = const FlutterSecureStorage(
          aOptions: AndroidOptions(),
        );

  // Regular Storage Methods
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> setBool(String key, {required bool value}) async {
    return await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // Secure Storage Methods
  Future<void> setSecureString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecureString(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> removeSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }

  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String userTokenKey = 'user_token';
}
