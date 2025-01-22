import 'package:flutter_mvvm_base/domain/entities/user/user.dart';
import 'package:flutter_mvvm_base/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  Future<User?> build() async {
    final useCase = GetCurrentUserUseCase();
    final result = await useCase.execute();
    await Future.delayed(const Duration(seconds: 3));
    return result.when(
      ok: (user) => user,
      error: (_) => null,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
