import 'package:flutter_mvvm_base/shared/domain/entity/common/app_error.dart';
import 'package:flutter_mvvm_base/domain/entity/user/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool isLoading,
    UserEntity? user,
    AppError? error,
  }) = _LoginState;
}
