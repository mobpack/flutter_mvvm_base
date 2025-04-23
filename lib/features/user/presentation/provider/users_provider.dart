import 'package:flutter_mvvm_base/di/service_locator.dart';
import 'package:flutter_mvvm_base/features/user/usecases/fetch_user_data_usecase.dart';
import 'package:flutter_mvvm_base/features/user/presentation/state/user_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_provider.g.dart';

@riverpod
class UsersProvider extends _$UsersProvider {
  @override
  UserState build() {
    return const UserState.loading();
  }

  Future<void> loadUserProfile(String userId) async {
    // final result = await ref.read(fetchUserDataUseCaseProvider).execute(userId);
    // result.when(
    //   ok: (user) => state = UserState.success(user: user),
    //   error: (error) => state = UserState.setError(error.message),
    // );
  }
}
