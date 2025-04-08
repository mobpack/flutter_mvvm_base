import 'package:flutter_mvvm_base/core/di/service_locator.dart';
import 'package:flutter_mvvm_base/domain/usecases/user/fetch_user_data_usecase.dart';
import 'package:flutter_mvvm_base/presentation/user/state/user_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_provider.g.dart';

@riverpod
class UsersProvider extends _$UsersProvider {
  final FetchUserDataUseCase _fetchUserDataUseCase;
  UsersProvider({FetchUserDataUseCase? fetchUserDataUseCase})
      : _fetchUserDataUseCase =
            fetchUserDataUseCase ?? getIt<FetchUserDataUseCase>();
  @override
  UserState build() {
    return const UserState.loading();
  }

  Future<void> loadUserProfile(String userId) async {
    final result = await _fetchUserDataUseCase.execute(userId);
    result.when(
      ok: (user) => state = UserState.success(user: user),
      error: (error) => state = UserState.setError(error.message),
    );
  }
}
