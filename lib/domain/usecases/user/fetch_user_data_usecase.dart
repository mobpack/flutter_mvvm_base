import 'package:flutter_mvvm_base/core/di/service_locator.dart';
import 'package:flutter_mvvm_base/data/repositories/user/user_repository.dart';
import 'package:flutter_mvvm_base/domain/entities/common/app_error.dart';
import 'package:flutter_mvvm_base/domain/entities/user/user_entity.dart';
import 'package:flutter_mvvm_base/domain/mappers/error_mapper.dart';
import 'package:safe_result/safe_result.dart';

/// UseCase for fetching user data from Supabase after login
class FetchUserDataUseCase {
  final UserRepository _userRepository;

  /// Constructor that takes a UserRepository
  FetchUserDataUseCase({UserRepository? userRepository})
      : _userRepository = userRepository ?? getIt<UserRepository>();

  /// Fetches user data from Supabase and merges it with the current UserEntity
  ///
  /// This is typically called after a successful login to ensure the app
  /// has the most up-to-date user information from the database
  Future<Result<UserEntity, AppError>> execute(UserEntity currentUser) async {
    try {
      // Fetch the latest user data from the repository
      final result = await _userRepository.getUserById(currentUser.id);

      return result.fold(
        onOk: (updatedUser) {
          // If the user exists in the database, return it
          return Result.ok(updatedUser);
        },
        onError: (error) {
          // For other errors, propagate them
          return Result.error(error);
        },
      );
    } catch (e) {
      return Result.error(ErrorMapper.mapError(e));
    }
  }
}
