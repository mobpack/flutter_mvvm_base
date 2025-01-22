import 'package:flutter_mvvm_base/core/di/service_locator.dart';
import 'package:flutter_mvvm_base/data/repositories/auth/auth_repository.dart';
import 'package:safe_result/safe_result.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase({AuthRepository? authRepository})
      : _authRepository = authRepository ?? getIt<AuthRepository>();

  Future<Result<void, Exception>> execute() async {
    return _authRepository.signOut();
  }
}
