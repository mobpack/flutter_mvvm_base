import 'package:flutter_mvvm_base/features/auth/usecases/logout_usecase.dart';
import 'package:flutter_mvvm_base/features/settings/presentation/state/settings_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_viewmodel.g.dart';

@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  late final LogoutUseCase _logoutUseCase;

  @override
  SettingsState build() {
    return const SettingsState();
  }

  Future<void> logout() async {
    if (state.isLoading) return; // prevent multiple calls while loading

    state = state.copyWith(isLoading: true);
    final result = await _logoutUseCase.execute();

    result.when(
      ok: (_) {
        // Refresh auth state to trigger router redirect
        // ref.read(supabaseAuthProvider.notifier).refresh();
      },
      error: (_) {
        // Handle error if needed
        state = state.copyWith(isLoading: false);
      },
    );
  }
}
