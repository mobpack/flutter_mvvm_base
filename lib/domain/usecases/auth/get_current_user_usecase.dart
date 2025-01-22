import 'package:flutter_mvvm_base/core/di/service_locator.dart';
import 'package:flutter_mvvm_base/data/repositories/auth/auth_repository.dart';
import 'package:flutter_mvvm_base/domain/entities/common/app_error.dart';
import 'package:flutter_mvvm_base/domain/entities/user/user.dart';
import 'package:flutter_mvvm_base/domain/mappers/error_mapper.dart';
import 'package:safe_result/safe_result.dart';

class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  GetCurrentUserUseCase({AuthRepository? authRepository})
      : _authRepository = authRepository ?? getIt<AuthRepository>();

  Future<Result<User, AppError>> execute() async {
    final result = await _authRepository.getCurrentUser();
    return result.fold(
      onOk: (value) {
        if (value == null) {
          throw ErrorMapper.mapError(Exception('User not found'));
        }
        return Result.ok(User(id: value.id, email: value.email));
      },
      onError: (error) => Result.error(ErrorMapper.mapError(error)),
    );
  }
}
