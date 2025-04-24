import 'package:flutter_mvvm_base/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_mvvm_base/features/auth/domain/repository/auth_repository.dart';
import 'package:safe_result/safe_result.dart';

class LogoutUseCase {
  final IAuthRepository _authRepository;

  LogoutUseCase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  Future<Result<void, Exception>> execute() async {
    return _authRepository.signOut();
  }
}
