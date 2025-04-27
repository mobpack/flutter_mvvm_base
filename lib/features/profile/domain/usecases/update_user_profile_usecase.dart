import 'package:flutter_mvvm_base/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_mvvm_base/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_user_profile_usecase.g.dart';

/// Use case for updating a user's profile data
class UpdateUserProfileUseCase {
  final IProfileRepository _repository;

  /// Creates a new [UpdateUserProfileUseCase] with the given repository
  UpdateUserProfileUseCase(this._repository);

  /// Executes the use case to update a user's profile
  ///
  /// [user] The updated user entity with new values
  /// Returns a [TaskEither] that resolves to either an [AppError] or the updated [UserEntity]
  TaskEither<AppError, UserEntity> execute(UserEntity user) {
    return _repository.updateUserProfile(user);
  }
}

/// Provider for [UpdateUserProfileUseCase]
@riverpod
UpdateUserProfileUseCase updateUserProfileUseCase(
    UpdateUserProfileUseCaseRef ref,) {
  final repository = ref.watch(profileRepositoryProvider);
  return UpdateUserProfileUseCase(repository);
}
