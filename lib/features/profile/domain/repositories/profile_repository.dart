import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:fpdart/fpdart.dart';

/// Repository interface for profile operations
abstract class IProfileRepository {
  /// Get user profile data
  TaskEither<AppError, UserEntity> getUserProfile(String userId);
  
  /// Update user profile data
  TaskEither<AppError, UserEntity> updateUserProfile(UserEntity user);
  
  /// Update user avatar
  TaskEither<AppError, String> updateUserAvatar(String userId, String avatarPath);
  
  /// Update user language preference
  TaskEither<AppError, String> updateUserLanguage(String userId, String language);
}
