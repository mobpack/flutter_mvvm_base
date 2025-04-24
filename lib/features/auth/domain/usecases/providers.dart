import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mvvm_base/features/auth/data/providers.dart';
import 'package:flutter_mvvm_base/features/auth/usecases/login_usecase.dart';
import 'package:flutter_mvvm_base/features/auth/usecases/register_usecase.dart';
import 'package:flutter_mvvm_base/features/auth/usecases/logout_usecase.dart';
import 'package:flutter_mvvm_base/features/auth/usecases/get_current_user_usecase.dart';

/// Providers for Auth feature use-cases
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LoginUseCase(authRepository: repo);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return RegisterUseCase(authRepository: repo);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LogoutUseCase(authRepository: repo);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(authRepository: repo);
});
