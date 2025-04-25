# Profile Feature Implementation Updates

## 1. Updated ProfileScreen to extend ConsumerWidget

The ProfileScreen has been updated to extend ConsumerWidget following the pattern of LoginScreen. Here's the fixed implementation:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/features/profile/presentation/profile/viewmodels/profile_viewmodel.dart';
import 'package:flutter_mvvm_base/features/profile/presentation/profile/widgets/profile_avatar_widget.dart';
import 'package:flutter_mvvm_base/features/profile/presentation/profile/widgets/profile_info_section.dart';
import 'package:flutter_mvvm_base/shared/widgets/base_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen that displays the user's profile information
class ProfileScreen extends ConsumerWidget {
  /// Creates a new [ProfileScreen]
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);

    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/profile/edit'),
          ),
        ],
      ),
      body: _buildBody(context, state, ref),
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state, WidgetRef ref) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.error}',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Refresh the profile by rebuilding the viewmodel
                ref.invalidate(profileViewModelProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.user == null) {
      return const Center(
        child: Text('User not found'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ProfileAvatarWidget(
              avatarUrl: state.user!.avatar,
              userName: state.user!.name ?? state.user!.email,
            ),
          ),
          const SizedBox(height: 24),
          ProfileInfoSection(user: state.user!),
          const SizedBox(height: 24),
          // Language selector and other settings
          const Text(
            'Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(state.user!.language),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to language settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to change password
            },
          ),
        ],
      ),
    );
  }
}
```

## 2. Added Profile Screen to App Router

The ProfileScreen has been added to the app router in `lib/shared/router/app_router.dart`:

```dart
// Add this import at the top of the file
import 'package:flutter_mvvm_base/features/profile/presentation/profile/screens/profile_screen.dart';

// Add this route to the _routes list in RouterNotifier class
GoRoute(
  path: '/profile',
  name: 'profile',
  builder: (context, state) => const ProfileScreen(),
),
```

## 3. Navigation Button in Home Page

The home page already has a button to navigate to the profile screen:

```dart
ElevatedButton(
  onPressed: () => context.go('/profile'),
  child: const Text('Go to User Profile'),
),
```

This button is correctly implemented and will navigate to the profile screen when clicked.

## 2. Profile Feature Implementation Steps

### Step 1: Create Folder Structure

```
lib/features/profile/
├── data/
│   ├── datasources/
│   │   └── profile_data_source.dart
│   └── repositories/
│       └── profile_repository_impl.dart
├── domain/
│   ├── repositories/
│   │   └── profile_repository.dart
│   └── usecases/
│       ├── get_user_profile_usecase.dart
│       └── update_user_profile_usecase.dart
└── presentation/
    ├── profile/
    │   ├── screens/
    │   │   └── profile_screen.dart
    │   ├── state/
    │   │   └── profile_state.dart
    │   ├── viewmodels/
    │   │   └── profile_viewmodel.dart
    │   └── widgets/
    │       ├── profile_avatar_widget.dart
    │       └── profile_info_section.dart
    └── edit_profile/
        ├── screens/
        │   └── edit_profile_screen.dart
        ├── state/
        │   └── edit_profile_state.dart
        └── viewmodels/
            └── edit_profile_viewmodel.dart
```

### Step 2: Implement Domain Layer

#### profile_repository.dart
```dart
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:fpdart/fpdart.dart';

/// Repository interface for profile operations
abstract class IProfileRepository {
  /// Get user profile data
  TaskEither<AppError, UserEntity> getUserProfile(String userId);
  
  /// Update user profile data
  TaskEither<AppError, UserEntity> updateUserProfile(UserEntity user);
  
  /// Update user avatar
  TaskEither<AppError, String> updateUserAvatar(String userId, String avatarPath);
  
  /// Update user language preference
  TaskEither<AppError, String> updateUserLanguage(String userId, String language);
}
```

#### get_user_profile_usecase.dart
```dart
import 'package:flutter_mvvm_base/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_user_profile_usecase.g.dart';

class GetUserProfileUseCase {
  final IProfileRepository _repository;
  
  GetUserProfileUseCase(this._repository);
  
  TaskEither<AppError, UserEntity> execute(String userId) {
    return _repository.getUserProfile(userId);
  }
}

@riverpod
GetUserProfileUseCase getUserProfileUseCase(GetUserProfileUseCaseRef ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return GetUserProfileUseCase(repository);
}
```

#### update_user_profile_usecase.dart
```dart
import 'package:flutter_mvvm_base/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_user_profile_usecase.g.dart';

class UpdateUserProfileUseCase {
  final IProfileRepository _repository;
  
  UpdateUserProfileUseCase(this._repository);
  
  TaskEither<AppError, UserEntity> execute(UserEntity user) {
    return _repository.updateUserProfile(user);
  }
}

@riverpod
UpdateUserProfileUseCase updateUserProfileUseCase(UpdateUserProfileUseCaseRef ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return UpdateUserProfileUseCase(repository);
}
```

### Step 3: Implement Data Layer

#### profile_data_source.dart
```dart
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

part 'profile_data_source.g.dart';

class ProfileDataSource {
  final supabase.SupabaseClient _client;
  
  ProfileDataSource(this._client);
  
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .single();
    
    return response;
  }
  
  Future<Map<String, dynamic>> updateUserProfile(UserEntity user) async {
    final response = await _client
        .from('users')
        .update({
          'email': user.email,
          'name': user.name,
          'role': user.role,
          'avatar': user.avatar,
          'language': user.language,
          'onboarding_completed': user.onboardingCompleted,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', user.id)
        .select()
        .single();
    
    return response;
  }
  
  Future<String> updateUserAvatar(String userId, String avatarPath) async {
    // Upload file to storage
    final fileName = 'avatar_$userId.jpg';
    final storageResponse = await _client.storage
        .from('avatars')
        .upload(fileName, await supabase.File.fromPath(avatarPath));
    
    // Get public URL
    final avatarUrl = _client.storage.from('avatars').getPublicUrl(fileName);
    
    // Update user record
    await _client
        .from('users')
        .update({
          'avatar': avatarUrl,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId);
    
    return avatarUrl;
  }
  
  Future<String> updateUserLanguage(String userId, String language) async {
    final response = await _client
        .from('users')
        .update({
          'language': language,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId)
        .select('language')
        .single();
    
    return response['language'];
  }
}

@riverpod
ProfileDataSource profileDataSource(ProfileDataSourceRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ProfileDataSource(supabase);
}
```

#### profile_repository_impl.dart
```dart
import 'package:flutter_mvvm_base/features/profile/data/datasources/profile_data_source.dart';
import 'package:flutter_mvvm_base/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:flutter_mvvm_base/shared/domain/mappers/error_mapper.dart';
import 'package:flutter_mvvm_base/shared/logging/log_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository_impl.g.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileDataSource _dataSource;
  
  ProfileRepositoryImpl(this._dataSource);
  
  @override
  TaskEither<AppError, UserEntity> getUserProfile(String userId) {
    return TaskEither.tryCatch(
      () async {
        final userData = await _dataSource.getUserProfile(userId);
        return UserEntity.mergeWithSupabaseData(UserEntity.empty(), userData);
      },
      (error, stackTrace) {
        LogService.e('Error getting user profile', error, stackTrace);
        return ErrorMapper.mapToAppError(error);
      },
    );
  }
  
  @override
  TaskEither<AppError, UserEntity> updateUserProfile(UserEntity user) {
    return TaskEither.tryCatch(
      () async {
        final userData = await _dataSource.updateUserProfile(user);
        return UserEntity.mergeWithSupabaseData(user, userData);
      },
      (error, stackTrace) {
        LogService.e('Error updating user profile', error, stackTrace);
        return ErrorMapper.mapToAppError(error);
      },
    );
  }
  
  @override
  TaskEither<AppError, String> updateUserAvatar(String userId, String avatarPath) {
    return TaskEither.tryCatch(
      () => _dataSource.updateUserAvatar(userId, avatarPath),
      (error, stackTrace) {
        LogService.e('Error updating user avatar', error, stackTrace);
        return ErrorMapper.mapToAppError(error);
      },
    );
  }
  
  @override
  TaskEither<AppError, String> updateUserLanguage(String userId, String language) {
    return TaskEither.tryCatch(
      () => _dataSource.updateUserLanguage(userId, language),
      (error, stackTrace) {
        LogService.e('Error updating user language', error, stackTrace);
        return ErrorMapper.mapToAppError(error);
      },
    );
  }
}

@riverpod
IProfileRepository profileRepository(ProfileRepositoryRef ref) {
  final dataSource = ref.watch(profileDataSourceProvider);
  return ProfileRepositoryImpl(dataSource);
}
```

### Step 4: Implement Presentation Layer

#### profile_state.dart
```dart
import 'package:flutter_mvvm_base/shared/domain/common/app_error.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoading,
    @Default(false) bool isUpdating,
    UserEntity? user,
    AppError? error,
  }) = _ProfileState;
  
  factory ProfileState.initial() => const ProfileState();
}
```

#### profile_viewmodel.dart
```dart
import 'package:flutter_mvvm_base/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:flutter_mvvm_base/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:flutter_mvvm_base/features/profile/presentation/profile/state/profile_state.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_viewmodel.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  late final GetUserProfileUseCase _getUserProfileUseCase;
  late final UpdateUserProfileUseCase _updateUserProfileUseCase;
  
  @override
  ProfileState build() {
    _getUserProfileUseCase = ref.watch(getUserProfileUseCaseProvider);
    _updateUserProfileUseCase = ref.watch(updateUserProfileUseCaseProvider);
    return ProfileState.initial();
  }
  
  Future<void> loadUserProfile(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _getUserProfileUseCase.execute(userId).run();
    
    result.fold(
      (error) => state = state.copyWith(isLoading: false, error: error),
      (user) => state = state.copyWith(isLoading: false, user: user),
    );
  }
  
  Future<void> updateProfile(UserEntity updatedUser) async {
    state = state.copyWith(isUpdating: true, error: null);
    
    final result = await _updateUserProfileUseCase.execute(updatedUser).run();
    
    result.fold(
      (error) => state = state.copyWith(isUpdating: false, error: error),
      (user) => state = state.copyWith(isUpdating: false, user: user),
    );
  }
}
```

#### profile_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/features/profile/presentation/profile/state/profile_state.dart';
import 'package:flutter_mvvm_base/features/profile/presentation/profile/viewmodels/profile_viewmodel.dart';
import 'package:flutter_mvvm_base/features/profile/presentation/profile/widgets/profile_avatar_widget.dart';
import 'package:flutter_mvvm_base/features/profile/presentation/profile/widgets/profile_info_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(context, '/profile/edit'),
          ),
        ],
      ),
      body: Consumer(builder: (context, ref, _) {
        final state = ref.watch(profileViewModelProvider);
        
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state.error != null) {
          return Center(
            child: Text('Error: ${state.error!.message}'),
          );
        }
        
        if (state.user == null) {
          return const Center(
            child: Text('User not found'),
          );
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ProfileAvatarWidget(
                  avatarUrl: state.user!.avatar,
                  userName: state.user!.name ?? state.user!.email,
                ),
              ),
              const SizedBox(height: 24),
              ProfileInfoSection(user: state.user!),
              const SizedBox(height: 24),
              // Language selector and other settings
              const Text(
                'Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                subtitle: Text(state.user!.language),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to language settings
                },
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Change Password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to change password
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
```

#### profile_avatar_widget.dart
```dart
import 'package:flutter/material.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String? avatarUrl;
  final String userName;
  final double size;

  const ProfileAvatarWidget({
    super.key,
    this.avatarUrl,
    required this.userName,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (avatarUrl != null && avatarUrl!.isNotEmpty)
          CircleAvatar(
            radius: size / 2,
            backgroundImage: NetworkImage(avatarUrl!),
          )
        else
          CircleAvatar(
            radius: size / 2,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              _getInitials(userName),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: size / 3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          userName,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else {
      return name[0].toUpperCase();
    }
  }
}
```

### Step 5: Register Routes and Providers

Add the following to your app's router configuration:

```dart
// In your router configuration file
GoRoute(
  path: '/profile',
  builder: (context, state) => const ProfileScreen(),
),
GoRoute(
  path: '/profile/edit',
  builder: (context, state) => const EditProfileScreen(),
),
```

## 3. Testing the Profile Feature

Create tests for each layer:

1. **Repository Tests**: Test the repository implementation with mocked data source
2. **Use Case Tests**: Test the use cases with mocked repository
3. **ViewModel Tests**: Test the view models with mocked use cases
4. **Widget Tests**: Test the UI components
5. **Integration Tests**: Test the feature end-to-end

## 4. Next Steps

1. Implement the Edit Profile screen and functionality
2. Add language settings screen
3. Implement avatar upload functionality with image picker
4. Add change password functionality
5. Implement proper error handling and user feedback
6. Add analytics tracking for profile actions

