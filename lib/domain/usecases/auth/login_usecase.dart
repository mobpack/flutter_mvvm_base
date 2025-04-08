import 'package:flutter_mvvm_base/core/di/service_locator.dart';
import 'package:flutter_mvvm_base/data/repositories/auth/auth_repository.dart';
import 'package:flutter_mvvm_base/domain/entities/common/app_error.dart';
import 'package:flutter_mvvm_base/domain/entities/user/user_entity.dart';
import 'package:flutter_mvvm_base/domain/mappers/error_mapper.dart';
import 'package:safe_result/safe_result.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase({AuthRepository? authRepository})
      : _authRepository = authRepository ?? getIt<AuthRepository>();

  Future<Result<UserEntity, AppError>> execute(
      String email, String password,) async {
    final result = await _authRepository.signInWithPassword(
      email: email,
      password: password,
    );
    return result.fold(
      onOk: (response) {
        if (response.user == null) {
          return Result.error(
            ErrorMapper.mapError(Exception('User not found')),
          );
        }
        return Result.ok(
          UserEntity(
            id: response.user!.id, 
            email: response.user!.email ?? '',
          ),
        );
      },
      onError: (error) => Result.error(ErrorMapper.mapError(error)),
    );
  }
}
