import 'package:flutter_mvvm_base/core/di/service_locator.dart';
import 'package:flutter_mvvm_base/core/providers/auth_provider.dart';
import 'package:flutter_mvvm_base/domain/usecases/auth/login_usecase.dart';
import 'package:flutter_mvvm_base/ui/auth/login/state/login_state.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_viewmodel.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  late final FormGroup form;
  late final LoginUseCase _loginUseCase;

  LoginViewModel({LoginUseCase? loginUseCase})
      : _loginUseCase = loginUseCase ?? getIt<LoginUseCase>();

  @override
  LoginState build() {
    _initForm();
    return const LoginState();
  }

  void _initForm() {
    form = FormGroup({
      'email': FormControl<String>(
        validators: [
          Validators.required,
          Validators.email,
        ],
      ),
      'password': FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(6),
        ],
      ),
    });
  }

  Future<void> login() async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    final email = form.control('email').value as String;
    final password = form.control('password').value as String;

    final result = await _loginUseCase.execute(email, password);

    result.when(
      ok: (user) {
        ref.read(authProvider.notifier).refresh();

        state = state.copyWith(
          isLoading: false,
          user: user,
        );
      },
      error: (error) {
        state = state.copyWith(
          isLoading: false,
          error: error,
        );
      },
    );
  }

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }

  bool get isLoggedIn => state.user != null;
}
