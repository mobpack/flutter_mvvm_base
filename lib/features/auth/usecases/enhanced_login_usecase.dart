import 'package:dartz/dartz.dart';
import 'package:flutter_mvvm_base/domain/entity/common/app_error.dart';
import 'package:flutter_mvvm_base/domain/mappers/error_mapper.dart';
import 'package:flutter_mvvm_base/domain/repository/auth_repository.dart';
import 'package:flutter_mvvm_base/domain/entity/user/user_entity.dart';
import 'package:flutter_mvvm_base/features/user/usecases/fetch_user_data_usecase.dart';
import 'package:safe_result/safe_result.dart';

/// Enhanced login use case that fetches user data from Supabase after successful authentication
class EnhancedLoginUseCase {
  final IAuthRepository _authRepository;
  final FetchUserDataUseCase _fetchUserDataUseCase;

  /// Constructor that takes repositories and use cases
  EnhancedLoginUseCase({
    required IAuthRepository authRepository,
    required FetchUserDataUseCase fetchUserDataUseCase,
  })  : _authRepository = authRepository,
        _fetchUserDataUseCase = fetchUserDataUseCase;

  /// Executes the login process and fetches user data
  ///
  /// This method:
  /// 1. Authenticates the user with email and password
  /// 2. If authentication is successful, fetches additional user data from the 'users' table
  /// 3. Merges the authentication data with the user profile data
  ///
  /// Using dartz for the complex nested error handling case
  Future<Result<UserEntity, AppError>> execute(
    String email,
    String password,
  ) async {
    try {
      // Step 1: Authenticate the user and handle with dartz
      final Either<AppError, UserEntity> result =
          await _authenticateAndGetUserData(
        email: email,
        password: password,
      );

      // Convert dartz Either to safe_result Result
      return result.fold(
        Result.error,
        Result.ok,
      );
    } catch (e) {
      return Result.error(ErrorMapper.mapError(e));
    }
  }

  /// Helper method that uses dartz's Either for better handling of the nested error case
  Future<Either<AppError, UserEntity>> _authenticateAndGetUserData({
    required String email,
    required String password,
  }) async {
    // Step 1: Authenticate the user
    final authResult = await _authRepository.signInWithPassword(
      email: email,
      password: password,
    );

    // Handle authentication error
    if (authResult.isLeft()) {
      return Left(ErrorMapper.mapError(authResult.error));
    }

    final response = authResult.value;
    if (response.user == null) {
      return Left(ErrorMapper.mapError(Exception('User not found')));
    }

    // Step 2: Create a basic UserEntity from auth data
    final basicUser = UserEntity(
      id: response.user!.id,
      email: response.user!.email ?? '',
    );

    // Step 3: Fetch additional user data from Supabase
    try {
      final userDataResult = await _fetchUserDataUseCase.execute(basicUser.id);

      if (userDataResult.isOk) {
        // Return the complete user with all data from the database
        return Right(userDataResult.value);
      } else {
        // If there was an error fetching additional data, return the basic user
        // This ensures the user can still log in even if profile data is unavailable
        return Right(basicUser);
      }
    } catch (_) {
      // If there was an exception fetching user data, still allow login with basic user
      return Right(basicUser);
    }
  }
}
