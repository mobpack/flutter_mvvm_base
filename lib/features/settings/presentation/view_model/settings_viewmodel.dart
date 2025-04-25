import 'package:flutter_mvvm_base/features/auth/usecases/logout_usecase.dart';
import 'package:flutter_mvvm_base/features/settings/presentation/state/settings_state.dart';
import 'package:flutter_mvvm_base/shared/auth/domain/notifiers/auth_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_viewmodel.g.dart';

@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  late final LogoutUseCase _logoutUseCase;

  @override
  SettingsState build() {
    _logoutUseCase = ref.read(logoutUseCaseProvider);
    return const SettingsState();
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    final result = await _logoutUseCase.execute().run();
    
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.toString());
      },
      (_) {
        // Explicitly notify the auth notifier about the logout
        final authNotifier = ref.read(authNotifierProvider.notifier);
        authNotifier.signOut();
        
        state = state.copyWith(isLoading: false);
      },
    );
  }
}
