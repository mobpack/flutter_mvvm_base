# Improvement Plan for Flutter MVVM Base

## 1. High-Level Plan to Improve Codebase
1. Enforce feature-first, fully encapsulated structure for each domain.
2. Align project README with actual directories (`core/` vs `shared/`).
3. Standardize layering: data, domain, presentation inside each feature.
4. Provide Riverpod providers for repositories and usecases.
5. Enforce DI with `riverpod_annotation` and `freezed` for data classes.
6. Organize tests under `test/` mirroring `lib/` structure.
7. Integrate `flutter analyze` and `flutter format` in CI.

## 2. Auth Feature Analysis

**Problems:**
- Global `lib/data/auth` and `lib/domain` instead of feature-local.
- Missing `Provider<LoginUseCase>`; `_loginUseCase` not injected.
- No navigation or global auth state update on login.
- README mentions `core/` but folder absent.
- Layers not co-located, decreasing maintainability.

**Best Practices:**
- Co-locate data/domain/usecases under `features/auth/`.
- Define `providers.dart` in each layer for DI.
- Inject dependencies via Riverpod in ViewModel.
- Update auth state in a dedicated notifier, not directly in ViewModel.
- Reflect folder conventions in README.

## 3. Best-Practice Feature Structure

```
lib/
└ features/
  └ auth/
    ├ data/
    │  ├ repositories/
    │  │  └ auth_repository_impl.dart
    │  └ providers.dart
    ├ domain/
    │  ├ entities/
    │  │  └ user_entity.dart
    │  ├ repository/
    │  │  └ auth_repository.dart
    │  └ usecases/
    │     └ login_usecase.dart
    ├ presentation/
    │  ├ login/
    │  │  ├ login_screen.dart
    │  │  ├ login_viewmodel.dart
    │  │  └ providers.dart
    │  └ register/
    └ README.md
```

### Example: features/auth/data/providers.dart

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mvvm_base/data/supabase/supabase_provider.dart';
import 'package:flutter_mvvm_base/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_mvvm_base/features/auth/domain/repository/auth_repository.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthRepositoryImpl(client: client);
});
```

### Example: features/auth/presentation/login/providers.dart

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mvvm_base/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_mvvm_base/features/auth/data/providers.dart';

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LoginUseCase(authRepository: repo);
});
```

## 4. Handling Auth Redirect with go_router

### 4.1 Auth State Provider
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mvvm_base/features/auth/data/providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authStateProvider = StreamProvider<User?>(
  (ref) {
    final repo = ref.watch(authRepositoryProvider);
    return repo.onAuthStateChange.map((evt) => evt.session?.user);
  },
);
```

### 4.2 app_router.dart Changes
```diff
GoRouter(
-  // redirect: router._redirect,
+  redirect: router._redirect,
   refreshListenable: router,
   routes: router._routes,
)
```

```dart
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, __) => notifyListeners());
  }

  String? _redirect(BuildContext context, GoRouterState state) {
    final user = _ref.read(authStateProvider).maybeWhen(
      data: (u) => u,
      orElse: () => null,
    );
    final isAuth = user != null;
    final isLogin = state.subloc == '/login';

    if (!isAuth && !isLogin) {
      return '/login';
    }
    if (isAuth && isLogin) {
      return '/';
    }
    return null;
  }
}
```

## 5. Implementation Steps
1. Restructure feature:
   - Move `lib/data/auth/*` → `lib/features/auth/data/`.
   - Move `lib/domain/repository/auth_repository.dart` → `lib/features/auth/domain/repository/`.
   - Remove global data/domain folders.
2. Create providers:
   - `features/auth/data/providers.dart` → `authRepositoryProvider`.
   - `features/auth/domain/usecases/providers.dart` → `loginUseCaseProvider`.
   - `features/auth/presentation/login/providers.dart` → `loginViewModelProvider` if needed.
   - `shared/router/providers.dart` or inline → `authStateProvider`.
3. Update `login_viewmodel.dart`:
   - Inject usecase via `ref.read(loginUseCaseProvider)`.
   - On success: call `context.go('/')` (pass BuildContext to VM or handle via callback).
4. Enable router guard:
   - Un‑comment `redirect` in `GoRouter`.
   - Use `authStateProvider` in `RouterNotifier._redirect`.
5. Testing & docs:
   - Write unit tests for `LoginUseCase` and widget tests for `LoginScreen`.
   - Update `README.md` with new feature structure.
6. CI integration:
   - Add `flutter analyze`, `flutter format`, and test commands.

## 6. Shared/Common Entities
Place domain entities that are used across multiple features in a shared folder under `lib/shared`:

```text
lib/
└ shared/
  └ domain/
    └ entities/
      └ user_entity.dart
      └ product_entity.dart
```

Define with Freezed for consistency:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_entity.freezed.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String email,
  }) = _UserEntity;
}
```

This keeps common models centralized and reusable.

## 7. Migrate Supabase & Storage Data Modules

Both Supabase and storage are cross-cutting services → move into `shared/data`:

1. Move `lib/data/supabase/` → `lib/shared/data/supabase/` (we already did).
2. Move `lib/data/storage/` → `lib/shared/data/storage/`:
   - `storage_repository_impl.dart`
   - `storage_provider.dart` → rename to `providers.dart`.
3. Create `lib/shared/data/storage/providers.dart`:
   ```dart
   import 'package:flutter_riverpod/flutter_riverpod.dart';
   import 'package:shared_preferences/shared_preferences.dart';
   import 'package:flutter_secure_storage/flutter_secure_storage.dart';
   import 'package:flutter_mvvm_base/shared/domain/repository/storage_repository.dart';
   import 'package:flutter_mvvm_base/shared/data/storage/storage_repository_impl.dart';

   final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
     return await SharedPreferences.getInstance();
   });

   final storageRepositoryProvider = Provider<IStorageRepository>((ref) {
     final prefs = ref.watch(sharedPreferencesProvider).maybeWhen(
       data: (p) => p,
       orElse: () => throw Exception('Prefs not initialized'),
     );
     return StorageRepositoryImpl(prefs: prefs);
   });
   ```
4. Update all imports from `package:flutter_mvvm_base/data/storage/...` to `package:flutter_mvvm_base/shared/data/storage/...`.
5. Delete old `lib/data/storage/` directory.

## 8. Implementation Checklist

- **1. Restructure feature**
  - [x] Move `lib/data/auth/*` → `lib/features/auth/data/`
  - [x] Move `lib/domain/repository/auth_repository.dart` → `lib/features/auth/domain/repository/`
  - [x] Remove global `lib/data/auth` & old domain folder

- **2. Create providers**
  - [x] `features/auth/data/providers.dart`
  - [ ] `features/auth/domain/usecases/providers.dart`
  - [x] `features/auth/presentation/login/providers.dart`
  - [ ] `shared/router/providers.dart` (or inline `authStateProvider`)

- **3. Update `login_viewmodel.dart`**
  - [ ] Inject usecase via `ref.read(loginUseCaseProvider)`
  - [ ] On success: call `context.go('/')`

- **4. Enable router guard**
  - [ ] Un-comment `redirect` in `GoRouter`
  - [ ] Use `authStateProvider` in `RouterNotifier._redirect`

- **5. Testing & docs**
  - [ ] Unit tests for `LoginUseCase`
  - [ ] Widget tests for `LoginScreen`
  - [ ] Update `README.md` with new feature structure

- **6. CI integration**
  - [ ] Add `flutter analyze` command in CI
  - [ ] Add `flutter format` command in CI
  - [ ] Add `flutter test` command in CI