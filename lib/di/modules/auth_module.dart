import 'package:flutter_mvvm_base/di/module.dart';
import 'package:flutter_mvvm_base/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_mvvm_base/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_mvvm_base/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_mvvm_base/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_mvvm_base/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_mvvm_base/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_mvvm_base/service/supabase/auth/auth_service_interface.dart';

class AuthModule extends DIModule {
  const AuthModule(super.getIt);

  @override
  void register() {
    _registerRepositories();
    _registerUseCases();
  }

  void _registerRepositories() {
    getIt.registerLazySingleton<IAuthRepository>(
      () => AuthRepositoryImpl(
        authService: getIt<IAuthService>(),
      ),
    );
  }

  void _registerUseCases() {
    // Register all auth-related use cases
    getIt
      ..registerFactory<GetCurrentUserUseCase>(
        () => GetCurrentUserUseCase(authRepository: getIt()),
      )
      ..registerFactory<LoginUseCase>(
        () => LoginUseCase(authRepository: getIt()),
      )
      ..registerFactory<LogoutUseCase>(
        () => LogoutUseCase(authRepository: getIt()),
      )
      ..registerFactory<RegisterUseCase>(
        () => RegisterUseCase(authRepository: getIt()),
      );
  }
}
