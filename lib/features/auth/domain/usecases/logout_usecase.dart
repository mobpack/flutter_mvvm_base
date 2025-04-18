import 'package:flutter_mvvm_base/features/auth/data/repositories/auth_repository.dart';
import 'package:safe_result/safe_result.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<Result<void, Exception>> execute() async {
    return _authRepository.signOut();
  }
}
