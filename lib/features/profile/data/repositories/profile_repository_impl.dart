import 'package:flutter_mvvm_base/features/profile/data/datasources/profile_data_source.dart';
import 'package:flutter_mvvm_base/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:flutter_mvvm_base/shared/domain/mappers/error_mapper.dart';
import 'package:flutter_mvvm_base/shared/logging/log_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository_impl.g.dart';

/// Implementation of [IProfileRepository] that uses Supabase as a data source
class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileDataSource _dataSource;

  /// Creates a new [ProfileRepositoryImpl] with the given data source
  ProfileRepositoryImpl(this._dataSource);

  @override
  TaskEither<AppError, UserEntity> getUserProfile(String userId) {
    return TaskEither.tryCatch(
      () async {
        final userData = await _dataSource.getUserProfile(userId);
        return UserEntity.mergeWithSupabaseData(UserEntity.empty(), userData);
      },
      (error, stackTrace) {
        logger.error('Error getting user profile', error, stackTrace);
        return ErrorMapper.mapException(error);
      },
    );
  }

  @override
  TaskEither<AppError, UserEntity> updateUserProfile(UserEntity user) {
    return TaskEither.tryCatch(
      () async {
        final userData = await _dataSource.updateUserProfile(user);
        return UserEntity.mergeWithSupabaseData(user, userData);
      },
      (error, stackTrace) {
        logger.error('Error updating user profile', error, stackTrace);
        return ErrorMapper.mapException(error);
      },
    );
  }

  @override
  TaskEither<AppError, String> updateUserAvatar(
    String userId,
    String avatarPath,
  ) {
    return TaskEither.tryCatch(
      () => _dataSource.updateUserAvatar(userId, avatarPath),
      (error, stackTrace) {
        logger.error('Error updating user avatar', error, stackTrace);
        return ErrorMapper.mapException(error);
      },
    );
  }

  @override
  TaskEither<AppError, String> updateUserLanguage(
    String userId,
    String language,
  ) {
    return TaskEither.tryCatch(
      () => _dataSource.updateUserLanguage(userId, language),
      (error, stackTrace) {
        logger.error('Error updating user language', error, stackTrace);
        return ErrorMapper.mapException(error);
      },
    );
  }
}

/// Provider for [IProfileRepository]
@riverpod
IProfileRepository profileRepository(ProfileRepositoryRef ref) {
  final dataSource = ref.watch(profileDataSourceProvider);
  return ProfileRepositoryImpl(dataSource);
}
