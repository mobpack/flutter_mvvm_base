# Supabase Service & Provider Architecture (Riverpod)

This document describes the architecture and usage of the Supabase service layer in this project, following MVVM and Riverpod best practices.

## Overview

- The Supabase integration is modular, testable, and scalable.
- All dependencies are injected via Riverpod providers.
- No reliance on GetIt or global singletons for new code.
- Supports feature-level overrides, multi-environment, and easy testing.

## Providers

### 1. `supabaseClientProvider`
Provides a singleton instance of `SupabaseClient` initialized from `.env` variables.

```dart
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  final url = dotenv.env['SUPABASE_URL'];
  final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
  if (url == null || anonKey == null) {
    throw Exception('Supabase URL and anonymous key must be provided in .env file');
  }
  return SupabaseClient(url, anonKey);
});
```

### 2. `supabaseServiceProvider`
Provides a singleton instance of `SupabaseService` using the client above.

```dart
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseService(client: client);
});
```

### 3. `authServiceProvider`
Provides a singleton instance of `AuthService` (implemented by `SupabaseAuthService`).

```dart
final authServiceProvider = Provider<AuthService>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return SupabaseAuthService(client: supabaseService.client);
});
```

## Usage Example

Inject the service into your ViewModel or Widget via Riverpod:

```dart
final authService = ref.watch(authServiceProvider);
final supabaseService = ref.watch(supabaseServiceProvider);
```

## Overriding for Tests or Multi-Environment

You can override any provider in your tests or in a feature module:

```dart
ProviderContainer(overrides: [
  supabaseClientProvider.overrideWithValue(MockSupabaseClient()),
  supabaseServiceProvider.overrideWithValue(MockSupabaseService()),
  authServiceProvider.overrideWithValue(MockAuthService()),
]);
```

## Best Practices

- Always inject dependencies via providers, never use singletons for new code.
- Use `Provider` for synchronous dependencies, `FutureProvider` for async.
- Use `.env` for secrets/configuration, never hardcode.
- Document all public APIs with DartDoc.
- Write tests for all business logic and UI components.

## References
- [Riverpod Documentation](https://riverpod.dev/)
- [Supabase Dart Client](https://supabase.com/docs/reference/dart/introduction)
- [MVVM Pattern in Flutter](https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple#mvvm)

---

For further questions, see the code comments or contact the maintainers.
