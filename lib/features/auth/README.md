# Authentication Feature

This feature module handles user authentication, including login, registration, password reset, and session management. It follows the MVVM architecture pattern and Clean Architecture principles.

## Directory Structure

```
auth/
├── data/                  # Data layer
│   ├── providers/         # Riverpod providers for data sources
│   └── repositories/      # Repository implementations
├── domain/                # Domain layer
│   └── repositories/      # Repository interfaces
├── presentation/          # Presentation layer
│   ├── screens/           # UI screens
│   ├── viewmodels/        # ViewModels
│   └── widgets/           # UI components
└── usecases/              # Use cases/interactors
```

## Key Components

### Data Layer
- **AuthRepository**: Implements authentication operations using Supabase
- **Providers**: Riverpod providers for dependency injection

### Domain Layer
- **Repository Interfaces**: Defines contracts for authentication operations

### Presentation Layer
- **Login Screen**: User login interface
- **Register Screen**: User registration interface
- **Password Reset**: Password recovery workflow
- **ViewModels**: Manages UI state and business logic

### Use Cases
- **Login Use Case**: Handles user login logic
- **Register Use Case**: Handles user registration logic
- **Reset Password Use Case**: Handles password reset logic
- **Check Auth State Use Case**: Verifies current authentication state

## Usage

### Authentication Flow

1. The app initializes by checking the current authentication state
2. Users can log in with email/password or register a new account
3. Upon successful authentication, the user is redirected to the home screen
4. The auth state is maintained across app restarts using secure storage

### Example: Login

```dart
final loginResult = await ref.read(loginUseCaseProvider).call(
  email: email,
  password: password,
);

leftResult.fold(
  (failure) => // Handle error,
  (user) => // Handle successful login,
);
```

## Integration with Other Features

The authentication feature integrates with:

- **Profile Feature**: For user profile management after authentication
- **Home Feature**: For redirecting authenticated users
- **Settings Feature**: For account management options

## Testing

All authentication components should have corresponding tests:

- Unit tests for repositories and use cases
- Widget tests for UI components
- Integration tests for authentication flows
