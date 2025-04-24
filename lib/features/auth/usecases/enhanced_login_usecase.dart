import 'package:fpdart/fpdart.dart';
import 'package:flutter_mvvm_base/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_mvvm_base/features/user/domain/user_entity.dart';
import 'package:flutter_mvvm_base/features/user/usecases/fetch_user_data_usecase.dart';
import 'package:flutter_mvvm_base/shared/domain/common/failure.dart';

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
  TaskEither<Failure, UserEntity> execute(String email, String password) {
    return _authRepository
        .signInWithPassword(email: email, password: password)
        .flatMap((response) {
          final user = response.user;
          if (user == null) {
            return TaskEither.left(Failure.mapping('User not found'));
          }
          final basicUser = UserEntity(id: user.id, email: user.email ?? '');
          
          return TaskEither.tryCatch(
            () async {
              final result = await _fetchUserDataUseCase.execute(user.id).run();
              return result.match(
                (_) => basicUser,
                (updated) => updated
              );
            },
            (error, _) => Failure.unknown(error.toString())
          ).orElse((_) => TaskEither.right(basicUser)); // Fallback to basic user if fetch fails
        });
  }
}
