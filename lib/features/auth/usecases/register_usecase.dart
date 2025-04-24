import 'package:flutter_mvvm_base/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_mvvm_base/features/user/domain/user_entity.dart';
import 'package:flutter_mvvm_base/shared/domain/common/failure.dart';
import 'package:fpdart/fpdart.dart';

class RegisterUseCase {
  final IAuthRepository _authRepository;

  RegisterUseCase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  TaskEither<Failure, UserEntity> execute(String email, String password) {
    return _authRepository
        .signUpWithPassword(email: email, password: password)
        .flatMap((response) {
          final user = response.user;
          if (user == null) {
            return TaskEither.left(Failure.mapping('User not found'));
          }
          return TaskEither.right(UserEntity(id: user.id, email: user.email ?? ''));
        });
  }
}
