import 'package:flutter_mvvm_base/features/auth/usecases/logout_usecase.dart';
import 'package:flutter_mvvm_base/features/settings/presentation/state/settings_state.dart';
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
    final result = _logoutUseCase.execute();

    result.match(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.toString()),
      (success) => state = state.copyWith(isLoading: false),
    );
  }
}
