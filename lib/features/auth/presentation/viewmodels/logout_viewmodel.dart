import 'package:flutter_mvvm_base/features/auth/usecases/logout_usecase.dart';
import 'package:flutter_mvvm_base/shared/infrastructure/auth/providers/auth_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logout_viewmodel.g.dart';

/// ViewModel for handling logout functionality
@riverpod
class LogoutViewModel extends _$LogoutViewModel {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  /// Performs the logout operation and notifies the auth notifier
  Future<void> logout() async {
    state = const AsyncValue.loading();

    try {
      // Execute the logout use case
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      final result = await logoutUseCase.execute().run();

      result.fold(
        (error) {
          state = AsyncValue.error(error, StackTrace.current);
        },
        (_) {
          // Explicitly notify the auth notifier about the logout
          final authNotifier = ref.read(authNotifierProvider.notifier);
          authNotifier.signOut();

          state = const AsyncValue.data(null);
        },
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
