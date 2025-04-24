import 'package:flutter_mvvm_base/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

/// Enhanced login use case that fetches user data from Supabase after successful authentication
class EnhancedLoginUseCase {
  final IAuthRepository _authRepository;

  /// Constructor that takes repositories and use cases
  EnhancedLoginUseCase({
    required IAuthRepository authRepository,
  }) : _authRepository = authRepository;

  TaskEither<AppError, UserEntity> execute(String email, String password) {
    return _authRepository.signInWithPassword(email: email, password: password);
  }
}
