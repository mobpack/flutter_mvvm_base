import 'package:flutter_mvvm_base/di/modules/auth_module.dart';
import 'package:flutter_mvvm_base/di/modules/user_module.dart';
import 'package:flutter_mvvm_base/features/auth/domain/usecases/enhanced_login_usecase.dart';
import 'package:flutter_mvvm_base/shared/utils/log_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Initialize logger first
  logger.init();
  logger.info('Setting up service locator...');

  // Register modules
  final modules = [
    AuthModule(getIt),
    UserModule(getIt),
  ];

  // Initialize all modules
  for (final module in modules) {
    module.register();
  }

  // Register enhanced login use case
  getIt.registerFactory(
    () => EnhancedLoginUseCase(
      authRepository: getIt(),
      fetchUserDataUseCase: getIt(),
    ),
  );

  // Wait for async singletons to be ready
  await getIt.allReady();
  logger.info('Service locator setup complete');
}
