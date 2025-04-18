import 'package:flutter_mvvm_base/domain/entities/common/app_error.dart';
import 'package:flutter_mvvm_base/domain/mappers/error_mapper.dart';
import 'package:flutter_mvvm_base/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_mvvm_base/features/user/domain/entities/user/user_entity.dart';
import 'package:safe_result/safe_result.dart';

class RegisterUseCase {
  final IAuthRepository _authRepository;

  RegisterUseCase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  Future<Result<UserEntity, AppError>> execute(
    String email,
    String password,
  ) async {
    final result = await _authRepository.signUpWithPassword(
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
