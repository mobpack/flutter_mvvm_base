import 'package:fpdart/fpdart.dart';
import 'package:flutter_mvvm_base/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_mvvm_base/features/user/domain/user_entity.dart';
import 'package:flutter_mvvm_base/shared/domain/common/failure.dart';

class GetCurrentUserUseCase {
  final IAuthRepository _authRepository;

  GetCurrentUserUseCase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  TaskEither<Failure, UserEntity> execute() {
    final user = _authRepository.currentUser;
    if (user == null) {
      return TaskEither.left(Failure.mapping('User not found'));
    }
    return TaskEither.right(UserEntity(id: user.id, email: user.email ?? ''));
  }
}
