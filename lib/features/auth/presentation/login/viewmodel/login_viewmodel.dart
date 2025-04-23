import 'package:flutter_mvvm_base/data/auth/supabase_auth_provider.dart';
import 'package:flutter_mvvm_base/features/auth/presentation/login/state/login_state.dart';
import 'package:flutter_mvvm_base/features/auth/usecases/login_usecase.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_viewmodel.g.dart';

@riverpod
class Login extends _$Login {
  late final FormGroup form;

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
        ref.read(supabaseAuthProvider);

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
