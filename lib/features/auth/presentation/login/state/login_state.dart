import 'package:flutter_mvvm_base/shared/domain/common/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'login_state.freezed.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool isLoading,
    User? user,
    Failure? error,
  }) = _LoginState;
}
