import 'package:flutter_mvvm_base/service/storage/storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of IStorageService using SharedPreferences and FlutterSecureStorage
class StorageServiceImpl implements IStorageService {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  StorageServiceImpl({required SharedPreferences prefs})
      : _prefs = prefs,
        _secureStorage = const FlutterSecureStorage(
          aOptions: AndroidOptions(),
        );

  // Regular Storage Methods
  @override
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  Future<bool> setBool(String key, {required bool value}) async {
    return await _prefs.setBool(key, value);
  }

  @override
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  @override
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // Secure Storage Methods
  @override
  Future<void> setSecureString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> getSecureString(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<void> removeSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  @override
  Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }
}
