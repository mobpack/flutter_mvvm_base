import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

/// State for the profile screen
@freezed
abstract class ProfileState with _$ProfileState {
  /// Creates a new [ProfileState]
  const factory ProfileState({
    /// Whether the profile is currently loading
    @Default(false) bool isLoading,

    /// Whether the profile is currently being updated
    @Default(false) bool isUpdating,

    /// The user entity containing profile data
    UserEntity? user,

    /// Any error that occurred during loading or updating
    AppError? error,
  }) = _ProfileState;

  /// Creates an initial empty state
  factory ProfileState.initial() => const ProfileState();
}
