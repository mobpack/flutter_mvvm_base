import 'package:flutter_mvvm_base/core/di/service_locator.dart';
import 'package:flutter_mvvm_base/domain/entities/user/user.dart';
import 'package:flutter_mvvm_base/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  Auth() : _getCurrentUserUseCase = getIt<GetCurrentUserUseCase>();

  @override
  Future<User?> build() async {
    final result = await _getCurrentUserUseCase.execute();
    await Future.delayed(const Duration(seconds: 1));
    return result.when(
      ok: (user) => user,
      error: (_) => null,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
