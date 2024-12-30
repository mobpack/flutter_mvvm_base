import 'package:flutter_mvvm_base/core/services/log_service.dart';
import 'package:flutter_mvvm_base/core/services/storage_service.dart';
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

  // Wait for async singletons to be ready
  await getIt.allReady();
  log.info('Service locator setup complete');
}
