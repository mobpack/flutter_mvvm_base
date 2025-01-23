import 'package:flutter_mvvm_base/core/di/modules/auth_module.dart';
import 'package:flutter_mvvm_base/core/di/modules/service_module.dart';
import 'package:flutter_mvvm_base/core/services/log_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Initialize logger first
  log.init();
  log.info('Setting up service locator...');

  // Get SharedPreferences instance
  final prefs = await SharedPreferences.getInstance();

  // Register modules
  final modules = [
    ServiceModule(getIt, prefs),
    AuthModule(getIt),
  ];

  // Initialize all modules
  for (final module in modules) {
    module.register();
  }

  // Wait for async singletons to be ready
  await getIt.allReady();
  log.info('Service locator setup complete');
}
