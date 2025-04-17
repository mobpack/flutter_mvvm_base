import 'package:flutter_mvvm_base/services/storage/storage_service.dart';
import 'package:flutter_mvvm_base/services/storage/storage_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'storage_service_provider.g.dart';

/// Provider for SharedPreferences instance (async)
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Provider for IStorageService using StorageServiceImpl
@riverpod
// ignore: deprecated_member_use_from_same_package
Future<IStorageService> storageService(StorageServiceRef ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return StorageServiceImpl(prefs: prefs);
}
