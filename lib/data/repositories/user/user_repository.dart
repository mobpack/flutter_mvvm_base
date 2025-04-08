import 'package:flutter_mvvm_base/domain/entities/common/app_error.dart';
import 'package:flutter_mvvm_base/domain/entities/user/user_entity.dart';
import 'package:safe_result/safe_result.dart';

/// Interface for user repository operations
abstract class UserRepository {
  /// Fetches user data from the database by user ID
  Future<Result<UserEntity, AppError>> getUserById(String userId);

  /// Updates user data in the database
  Future<Result<UserEntity, AppError>> updateUser(UserEntity user);

  /// Creates a new user record in the database
  Future<Result<UserEntity, AppError>> createUser(UserEntity user);
}
