import 'package:flutter_mvvm_base/di/service_locator.dart';
import 'package:flutter_mvvm_base/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_mvvm_base/features/user/domain/entities/user/user_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  Auth() : _getCurrentUserUseCase = getIt<GetCurrentUserUseCase>();

  @override
  Future<UserEntity?> build() async {
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
