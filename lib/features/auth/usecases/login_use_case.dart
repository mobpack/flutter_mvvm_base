import 'package:flutter_mvvm_base/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_use_case.g.dart';

/// Parameters for the login use case
class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}

/// Use case for user login with input validation
class LoginUseCase {
  final IAuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  /// Execute the login use case with validation
  TaskEither<AppError, UserEntity> execute(LoginParams params) {
    // Validate inputs first
    final validationResult = _validateInputs(params);
    if (validationResult.isLeft()) {
      // Return validation error as TaskEither
      return TaskEither.left(validationResult.getLeft().toNullable()!);
    }

    // If validation passes, call the repository
    return _authRepository.signInWithPassword(
      email: params.email,
      password: params.password,
    );
  }

  /// Alternative implementation using flatMap for composition
  TaskEither<AppError, UserEntity> executeComposed(LoginParams params) {
    return TaskEither.fromEither(_validateInputs(params)).flatMap(
      (_) => _authRepository.signInWithPassword(
        email: params.email,
        password: params.password,
      ),
    );
  }

  /// Validate login inputs
  Either<AppError, Unit> _validateInputs(LoginParams params) {
    final errors = <String, List<String>>{};

    // Validate email
    if (params.email.isEmpty) {
      errors['email'] = ['Email is required'];
    } else if (!_isValidEmail(params.email)) {
      errors['email'] = ['Invalid email format'];
    }

    // Validate password
    if (params.password.isEmpty) {
      errors['password'] = ['Password is required'];
    } else if (params.password.length < 6) {
      errors['password'] = ['Password must be at least 6 characters'];
    }

    // Return validation error if there are any errors
    if (errors.isNotEmpty) {
      return left(AppError.validation(errors: errors));
    }

    // Return success if validation passes
    return right(unit);
  }

  /// Check if email is valid
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

@riverpod
LoginUseCase loginUseCase(LoginUseCaseRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginUseCase(authRepository);
}

@riverpod
IAuthRepository authRepository(AuthRepositoryRef ref) {
  throw UnimplementedError('Provider must be overridden in the main.dart file');
}
