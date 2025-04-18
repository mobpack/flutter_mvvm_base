import 'package:flutter_mvvm_base/di/module.dart';
import 'package:flutter_mvvm_base/features/user/data/repositories/user/user_repository.dart';
import 'package:flutter_mvvm_base/features/user/data/repositories/user/user_repository_impl.dart';
import 'package:flutter_mvvm_base/features/user/domain/usecases/user/fetch_user_data_usecase.dart';
import 'package:flutter_mvvm_base/service/supabase/user/supabase_user_service.dart';
import 'package:flutter_mvvm_base/service/supabase/user/user_service_interface.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Module for registering user-related dependencies
class UserModule extends DIModule {
  UserModule(super.getIt);

  @override
  void register() {
    // Register services
    getIt.registerLazySingleton<UserService>(
      () => SupabaseUserService(client: getIt<SupabaseClient>()),
    );

    // Register repositories
    getIt.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(userService: getIt<UserService>()),
    );

    // Register use cases
    getIt.registerLazySingleton(
      () => FetchUserDataUseCase(userRepository: getIt<UserRepository>()),
    );
  }
}
