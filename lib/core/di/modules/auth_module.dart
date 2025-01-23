import 'package:flutter_mvvm_base/core/di/module.dart';
import 'package:flutter_mvvm_base/data/repositories/auth/auth_repository.dart';
import 'package:flutter_mvvm_base/data/repositories/auth/auth_repository_impl.dart';
import 'package:flutter_mvvm_base/data/services/supabase/auth/auth_interface.dart';
import 'package:flutter_mvvm_base/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:flutter_mvvm_base/domain/usecases/auth/login_usecase.dart';
import 'package:flutter_mvvm_base/domain/usecases/auth/logout_usecase.dart';
import 'package:flutter_mvvm_base/domain/usecases/auth/register_usecase.dart';

class AuthModule extends DIModule {
  const AuthModule(super.getIt);

  @override
  void register() {
    _registerRepositories();
    _registerUseCases();
  }

  void _registerRepositories() {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        authService: getIt<AuthService>(),
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
