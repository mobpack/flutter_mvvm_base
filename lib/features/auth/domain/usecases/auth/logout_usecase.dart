import 'package:flutter_mvvm_base/di/service_locator.dart';
import 'package:flutter_mvvm_base/features/auth/data/repositories/auth/auth_repository.dart';
import 'package:safe_result/safe_result.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase({AuthRepository? authRepository})
      : _authRepository = authRepository ?? getIt<AuthRepository>();

  Future<Result<void, Exception>> execute() async {
    return _authRepository.signOut();
  }
}
