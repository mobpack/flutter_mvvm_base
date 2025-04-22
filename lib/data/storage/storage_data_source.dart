import 'package:flutter_mvvm_base/data/storage/storage_repository_impl.dart';
import 'package:flutter_mvvm_base/domain/repository/storage_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for SharedPreferences instance (async)
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Provider for IStorageRepository using StorageRepositoryImpl
final storageDataSource = FutureProvider<IStorageRepository>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return StorageRepositoryImpl(prefs: prefs);
});
