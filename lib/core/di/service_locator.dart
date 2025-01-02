import 'package:flutter_mvvm_base/core/services/log_service.dart';
import 'package:flutter_mvvm_base/core/services/storage_service.dart';
import 'package:flutter_mvvm_base/data/repository/auth/auth_repository_interface.dart';
import 'package:flutter_mvvm_base/data/repository/auth/offline_auth_repository.dart';
import 'package:flutter_mvvm_base/data/repository/auth/online_auth_repository.dart';
import 'package:flutter_mvvm_base/data/services/supabase/auth/auth_interface.dart';
import 'package:flutter_mvvm_base/data/services/supabase/auth/auth_service.dart';
import 'package:flutter_mvvm_base/data/services/supabase/supabase_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Initialize logger first
  log.init();
  log.info('Setting up service locator...');

  // Services
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<StorageService>(
    StorageService(prefs),
  );

  // Register Supabase as async singleton
  getIt.registerSingletonAsync<SupabaseService>(() async {
    final service = SupabaseService();
    await service.init();
    return service;
  });

  // Register AuthService as lazy singleton
  getIt.registerLazySingleton<AuthService>(
    () => SupabaseAuthService(
      client: getIt<SupabaseService>().client,
    ),
  );

  // Register Auth Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => OnlineAuthRepository(
      authService: getIt<AuthService>(),
    ),
    instanceName: 'online',
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => OfflineAuthRepository(
      storageService: getIt<StorageService>(),
    ),
    instanceName: 'offline',
  );

  // Wait for async singletons to be ready
  await getIt.allReady();
  log.info('Service locator setup complete');
}
