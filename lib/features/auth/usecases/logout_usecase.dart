import 'package:flutter_mvvm_base/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_mvvm_base/shared/domain/common/failure.dart';

class LogoutUseCase {
  final IAuthRepository _authRepository;

  LogoutUseCase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  TaskEither<Failure, void> execute() {
    return _authRepository.signOut();
  }
}
