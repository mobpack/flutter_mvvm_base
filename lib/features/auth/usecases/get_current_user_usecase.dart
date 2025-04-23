import 'package:flutter_mvvm_base/shared/domain/entity/common/app_error.dart';
import 'package:flutter_mvvm_base/shared/domain/mappers/error_mapper.dart';
import 'package:flutter_mvvm_base/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_mvvm_base/domain/entity/user/user_entity.dart';
import 'package:safe_result/safe_result.dart';

class GetCurrentUserUseCase {
  final IAuthRepository _authRepository;

  GetCurrentUserUseCase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  Future<Result<UserEntity, AppError>> execute() async {
    final result = await _authRepository.getCurrentUser();
    return result.fold(
      onOk: (value) {
        if (value == null) {
          throw ErrorMapper.mapError(Exception('User not found'));
        }
        return Result.ok(
          UserEntity(
            id: value.id,
            email: value.email ?? '',
          ),
        );
      },
      onError: (error) => Result.error(ErrorMapper.mapError(error)),
    );
  }
}
