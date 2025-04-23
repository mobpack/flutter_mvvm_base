import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_mvvm_base/shared/domain/repository/storage_repository.dart';
import 'package:flutter_mvvm_base/shared/data/storage/storage_repository_impl.dart';

/// Provides SharedPreferences instance
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Provides IStorageRepository using StorageRepositoryImpl
final storageRepositoryProvider = Provider<IStorageRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).maybeWhen(
    data: (p) => p,
    orElse: () => throw Exception('Prefs not initialized'),
  );
  return StorageRepositoryImpl(prefs: prefs);
});
