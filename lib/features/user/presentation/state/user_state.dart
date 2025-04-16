import 'package:flutter_mvvm_base/features/user/domain/entities/user/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_state.freezed.dart';

@freezed
sealed class UserState with _$UserState {
  const factory UserState.loading() = Loading;
  const factory UserState.setError([String? message]) = Error;
  const factory UserState.success({
    required UserEntity user,
  }) = Success;
}
