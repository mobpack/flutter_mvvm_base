# Switching from Dartz to FPDart for Functional Error Handling

## Implementation Changes

We've successfully switched from dartz to fpdart, which provides a more modern and cleaner API for functional programming in Dart. Here's what we did:

### 1. Updated Dependencies

```yaml
# Before
dependencies:
  dartz: ^0.10.1

# After
dependencies:
  fpdart: ^1.1.0
```

### 2. Repository Methods

```dart
// Before (dartz style):
Task<Either<Failure, AuthResponse>> signInWithPassword({
  required String email,
  required String password,
}) => Task(() async {
  try {
    final response = await _auth.signInWithPassword(
      email: email,
      password: password,
    );
    return Right(response);
  } catch (error) {
    return Left(Failure.network(error.toString()));
  }
});

// After (fpdart style):
TaskEither<Failure, AuthResponse> signInWithPassword({
  required String email,
  required String password,
}) => TaskEither.tryCatch(
  () => _auth.signInWithPassword(
    email: email,
    password: password,
  ),
  (error, _) => Failure.network(error.toString()),
);
```

### 3. UseCase Methods

```dart
// Before (dartz style):
Task<Either<Failure, UserEntity>> execute(String email, String password) {
  return _authRepository
      .signInWithPassword(email: email, password: password)
      .map((either) => either.fold(
            (failure) => Left(failure),
            (response) {
              // ...
              return Right(UserEntity(...));
            },
          ));
}

// After (fpdart style):
TaskEither<Failure, UserEntity> execute(String email, String password) {
  return _authRepository
      .signInWithPassword(email: email, password: password)
      .flatMap((response) {
        final user = response.user;
        if (user == null) {
          return TaskEither.left(Failure.mapping('User not found'));
        }
        return TaskEither.right(UserEntity(id: user.id, email: user.email ?? ''));
      });
}
```

### 4. ViewModel Usage

```dart
// Before (dartz style):
final either = await ref.read(loginUseCaseProvider)
    .execute(email, password)
    .run();

either.fold(
  (failure) => state = state.copyWith(isLoading: false, error: failure),
  (user) => state = state.copyWith(isLoading: false, user: user),
);

// After (fpdart style):
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
```

## Benefits of Using FPDart

1. **Cleaner API**: Built-in `TaskEither<L, R>` type for better composability
2. **Better Type Safety**: Improved type inference with Dart 3
3. **More Active Maintenance**: Regular updates and improvements
4. **Simpler Error Handling**: More intuitive API for handling errors
5. **Improved Readability**: Less boilerplate code

## Next Steps

1. Run tests to ensure everything works as expected
2. Update any remaining code that might still be using dartz patterns
3. Consider using other fpdart features like `Option<A>` and `IO<A>` for additional functional programming patterns