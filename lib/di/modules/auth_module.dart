import 'package:flutter_mvvm_base/di/module.dart';
import 'package:flutter_mvvm_base/features/auth/data/repositories/auth/auth_repository.dart';
import 'package:flutter_mvvm_base/features/auth/data/repositories/auth/auth_repository_impl.dart';
import 'package:flutter_mvvm_base/features/auth/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:flutter_mvvm_base/features/auth/domain/usecases/auth/login_usecase.dart';
import 'package:flutter_mvvm_base/features/auth/domain/usecases/auth/logout_usecase.dart';
import 'package:flutter_mvvm_base/features/auth/domain/usecases/auth/register_usecase.dart';
import 'package:flutter_mvvm_base/services/supabase/auth/auth_interface.dart';

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
