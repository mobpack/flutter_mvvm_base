import 'package:flutter_mvvm_base/core/services/log_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoginState {
  final bool isLoading;
  final String? error;
  final FormGroup form;

  LoginState({
    this.isLoading = false,
    this.error,
    FormGroup? form,
  }) : form = form ??
            fb.group({
              'email': FormControl<String>(
                value: '',
                validators: [
                  Validators.required,
                  Validators.email,
                ],
              ),
              'password': FormControl<String>(
                value: '',
                validators: [
                  Validators.required,
                  Validators.minLength(6),
                ],
              ),
              'rememberMe': FormControl<bool>(
                value: false,
              ),
            });

  LoginState copyWith({
    bool? isLoading,
    String? error,
    FormGroup? form,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      form: form ?? this.form,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(LoginState());

  Future<void> login() async {
    if (!state.form.valid) return;

    state = state.copyWith(isLoading: true);

    try {
      final values = state.form.value;
      // TODO: Implement actual login logic
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simulate network delay
      log.info('Login values: $values');

      // On success, clear form
      state.form.reset();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier();
});
