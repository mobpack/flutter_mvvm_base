import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/features/auth/presentation/login/state/login_state.dart';
import 'package:flutter_mvvm_base/features/auth/usecases/login_use_case.dart';
import 'package:flutter_mvvm_base/shared/core/logging/log_service.dart';
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_viewmodel.g.dart';

@riverpod
class Login extends _$Login {
  late final LoginUseCase _loginUseCase;
  late FormGroup form;

  @override
  LoginState build() {
    _loginUseCase = ref.read(loginUseCaseProvider);
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

  Future<void> login(BuildContext context, {Function()? onLoginSuccess}) async {
    if (!form.valid) {
      form.markAllAsTouched();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    final email = form.control('email').value as String;
    final password = form.control('password').value as String;

    final params = LoginParams(email: email, password: password);
    final result = await _loginUseCase.execute(params).run();

    // Using Dart 3's pattern matching with Either
    switch (result) {
      case Left(value: final error):
        logger.logError(error);

        // Handle validation errors specially to update form
        if (error is ValidationError) {
          final errors = error.errors;
          errors.forEach((field, messages) {
            if (form.controls.containsKey(field)) {
              form
                  .control(field)
                  .setErrors({for (final msg in messages) msg: true});
            }
          });
        }

        // Update state with error
        state = state.copyWith(
          isLoading: false,
          error: error,
          canRetry: error.isRecoverable,
        );

      case Right(value: final user):
        // Update state with user
        state = state.copyWith(
          isLoading: false,
          user: user,
        );

        // Trigger navigation callback if provided
        if (onLoginSuccess != null) {
          onLoginSuccess();
        }
    }
  }

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }

  void retry(BuildContext context, {Function()? onLoginSuccess}) {
    if (state.canRetry) {
      login(context, onLoginSuccess: onLoginSuccess);
    }
  }

  bool get isLoggedIn => state.user != null;
}
