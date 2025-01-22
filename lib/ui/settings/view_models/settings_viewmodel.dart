import 'package:flutter_mvvm_base/core/providers/auth_provider.dart';
import 'package:flutter_mvvm_base/domain/usecases/auth/logout_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_viewmodel.g.dart';

@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  late final LogoutUseCase _logoutUseCase;

  @override
  bool build() {
    _logoutUseCase = LogoutUseCase();
    return false; // isLoading state
  }

  Future<void> logout() async {
    if (state) return; // prevent multiple calls while loading

    state = true; // start loading
    final result = await _logoutUseCase.execute();
    
    result.when(
      ok: (_) {
        // Refresh auth state to trigger router redirect
        ref.read(authProvider.notifier).refresh();
      },
      error: (_) {
        // Handle error if needed
        state = false;
      },
    );
  }
}
