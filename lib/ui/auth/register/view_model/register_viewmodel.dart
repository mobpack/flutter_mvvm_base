import 'package:flutter_mvvm_base/domain/entities/common/app_error.dart';
import 'package:flutter_mvvm_base/domain/entities/user/user.dart';
import 'package:flutter_mvvm_base/domain/usecases/auth/register_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

final registerViewModelProvider =
    StateNotifierProvider.autoDispose<RegisterViewModel, RegisterState>((ref) {
  return RegisterViewModel();
});

class RegisterState {
  final bool isLoading;
  final AppError? error;
  final User? user;

  RegisterState({
    this.isLoading = false,
    this.error,
    this.user,
  });

  RegisterState copyWith({
    bool? isLoading,
    AppError? error,
    User? user,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
    );
  }
}

class RegisterViewModel extends StateNotifier<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterViewModel({RegisterUseCase? registerUseCase})
      : _registerUseCase = registerUseCase ?? RegisterUseCase(),
        super(RegisterState()) {
    _initForm();
  }

  late final FormGroup form;

  bool get isRegistered => state.user != null;

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
      'confirmPassword': FormControl<String>(
        validators: [
          Validators.required,
        ],
      ),
    });
  }

  Future<void> register() async {
    if (form.invalid) return;

    state = state.copyWith(isLoading: true, error: null);

    final result = await _registerUseCase.execute(
      form.control('email').value as String,
      form.control('password').value as String,
    );

    result.when(
      ok: (user) {
        state = state.copyWith(
          isLoading: false,
          user: user,
          error: null,
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
}
