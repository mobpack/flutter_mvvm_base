import 'package:flutter_mvvm_base/core/di/service_locator.dart';
import 'package:flutter_mvvm_base/data/repositories/user/user_repository.dart';
import 'package:flutter_mvvm_base/data/services/supabase/user/user_service_interface.dart';
import 'package:flutter_mvvm_base/domain/entities/common/app_error.dart';
import 'package:flutter_mvvm_base/domain/entities/user/user_entity.dart';
import 'package:flutter_mvvm_base/domain/mappers/error_mapper.dart';
import 'package:safe_result/safe_result.dart';

/// Implementation of UserRepository
class UserRepositoryImpl implements UserRepository {
  final UserService _userService;

  /// Constructor that takes a UserService
  UserRepositoryImpl({UserService? userService})
      : _userService = userService ?? getIt<UserService>();

  @override
  Future<Result<UserEntity, AppError>> getUserById(String userId) async {
    try {
      final userData = await _userService.getUserData(userId);

      if (userData == null) {
        return Result.error(
          ErrorMapper.mapError(Exception('User not found')),
        );
      }

      // Create UserEntity from the fetched data
      return Result.ok(UserEntity.fromJson(userData));
    } catch (e) {
      return Result.error(ErrorMapper.mapError(e));
    }
  }

  @override
  Future<Result<UserEntity, AppError>> updateUser(UserEntity user) async {
    try {
      // Convert UserEntity to Map for the service
      final userData = user.toJson();

      // Remove id from the data to be updated
      final dataToUpdate = Map<String, dynamic>.from(userData)..remove('id');

      final updatedData =
          await _userService.updateUserData(user.id, dataToUpdate);

      // Create UserEntity from the updated data
      return Result.ok(UserEntity.fromJson(updatedData));
    } catch (e) {
      return Result.error(ErrorMapper.mapError(e));
    }
  }

  @override
  Future<Result<UserEntity, AppError>> createUser(UserEntity user) async {
    try {
      // Convert UserEntity to Map for the service
      final userData = user.toJson();

      // Remove id from the data as it will be provided separately
      final dataToCreate = Map<String, dynamic>.from(userData)..remove('id');

      final createdData =
          await _userService.createUserData(user.id, dataToCreate);

      // Create UserEntity from the created data
      return Result.ok(UserEntity.fromJson(createdData));
    } catch (e) {
      return Result.error(ErrorMapper.mapError(e));
    }
  }
}
