import 'package:flutter_mvvm_base/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:fpdart/fpdart.dart';

class RegisterUseCase {
  final IAuthRepository _authRepository;

  RegisterUseCase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  TaskEither<AppError, UserEntity> execute(String email, String password) {
    return _authRepository.signUpWithPassword(email: email, password: password);
  }
}
