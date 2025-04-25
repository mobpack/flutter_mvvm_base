import 'package:flutter_mvvm_base/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_mvvm_base/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_user_profile_usecase.g.dart';

/// Use case for retrieving a user's profile data
class GetUserProfileUseCase {
  final IProfileRepository _repository;

  /// Creates a new [GetUserProfileUseCase] with the given repository
  GetUserProfileUseCase(this._repository);

  /// Executes the use case to retrieve a user's profile
  ///
  /// [userId] The ID of the user to retrieve
  /// Returns a [TaskEither] that resolves to either an [AppError] or a [UserEntity]
  TaskEither<AppError, UserEntity> execute(String userId) {
    return _repository.getUserProfile(userId);
  }
}

/// Provider for [GetUserProfileUseCase]
@riverpod
GetUserProfileUseCase getUserProfileUseCase(GetUserProfileUseCaseRef ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return GetUserProfileUseCase(repository);
}
