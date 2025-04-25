import 'package:flutter_mvvm_base/features/auth/data/providers.dart';
import 'package:flutter_mvvm_base/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:flutter_mvvm_base/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:flutter_mvvm_base/features/profile/presentation/profile/state/profile_state.dart';
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_viewmodel.g.dart';

/// ViewModel for the profile screen following MVVM architecture
@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  late final GetUserProfileUseCase _getUserProfileUseCase;
  late final UpdateUserProfileUseCase _updateUserProfileUseCase;

  @override
  ProfileState build() {
    _getUserProfileUseCase = ref.watch(getUserProfileUseCaseProvider);
    _updateUserProfileUseCase = ref.watch(updateUserProfileUseCaseProvider);

    // Get the auth repository to access the current user
    final authRepository = ref.watch(authRepositoryProvider);

    // Initialize with loading state
    final initialState = ProfileState.initial().copyWith(isLoading: true);

    // Load the current user profile if authenticated
    if (authRepository.isAuthenticated) {
      // Use Future.microtask to avoid calling async code directly in build
      Future.microtask(() async {
        final currentUserResult = await authRepository.getCurrentUser().run();

        currentUserResult.fold(
          (error) => state = ProfileState.initial().copyWith(error: error),
          (user) {
            if (user != null) {
              loadUserProfile(user.id);
            } else {
              state = ProfileState.initial().copyWith(
                error: const AppError.auth(message: 'User not authenticated'),
              );
            }
          },
        );
      });
    }

    return initialState;
  }

  /// Loads the user profile for the given user ID
  Future<void> loadUserProfile(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getUserProfileUseCase.execute(userId).run();

    result.fold(
      (error) => state = state.copyWith(isLoading: false, error: error),
      (user) => state = state.copyWith(isLoading: false, user: user),
    );
  }

  /// Updates the user profile with the provided user entity
  Future<void> updateProfile(UserEntity updatedUser) async {
    state = state.copyWith(isUpdating: true, error: null);

    final result = await _updateUserProfileUseCase.execute(updatedUser).run();

    result.fold(
      (error) => state = state.copyWith(isUpdating: false, error: error),
      (user) => state = state.copyWith(isUpdating: false, user: user),
    );
  }
}
