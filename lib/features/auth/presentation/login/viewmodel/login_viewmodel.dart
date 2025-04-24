import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/features/auth/domain/usecases/providers.dart';
import 'package:flutter_mvvm_base/features/auth/presentation/login/state/login_state.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';

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

  Future<void> login(BuildContext context) async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    final email = form.control('email').value as String;
    final password = form.control('password').value as String;

    final result = await ref.read(loginUseCaseProvider)
        .execute(email, password)
        .run();
    result.match(
      (failure) => state = state.copyWith(isLoading: false, error: failure),
      (user) {
        state = state.copyWith(isLoading: false, user: user);
        context.go('/');
        return null; // match requires a return value
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
