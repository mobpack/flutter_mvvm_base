# Riverpod Async Dependency Pattern for ThemeManager

## Problem Recap
- Your `storageServiceProvider` is an **async** provider (returns `AsyncValue<IStorageService>`).
- Your current `themeManagerProvider` ([see snippet](#L9-14)) is a **sync** provider, but it depends on `storageServiceProvider`:
  ```dart
  @riverpod
  ThemeManager themeManager(ThemeManagerRef ref) {
    final storageService = ref.watch(storageServiceProvider);
    return ThemeManager(storageService: storageService);
  }
  ```
- This causes a problem: on app start, the theme is not available until storageService is ready, so you must wait (show splash/loading) in `app.dart`.

## Senior Riverpod Approach: Async ThemeManager

### 1. Make ThemeManager Async
Use a `FutureProvider<ThemeManager>` or (preferably) a `StateNotifierProvider<AsyncValue<ThemeMode>>`:

#### **A. AsyncNotifier (Recommended)**
- Use `AsyncNotifier<ThemeMode>` (with `@riverpod` codegen) for the theme manager.
- This lets you `await` storage service in the build/init method, and expose loading/error states directly to the UI.

**Example:**
```dart
// theme_service_provider.dart
@riverpod
class ThemeManager extends _$ThemeManager {
  @override
  FutureOr<ThemeMode> build() async {
    final storageService = await ref.watch(storageServiceProvider.future);
    final savedTheme = storageService.getString(themeKey);
    if (savedTheme != null) {
      return ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
    return ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final storageService = await ref.watch(storageServiceProvider.future);
    await storageService.setString(themeKey, mode.toString());
    state = AsyncValue.data(mode);
  }
}

final themeModeProvider = AsyncNotifierProvider<ThemeManager, ThemeMode>(ThemeManager.new);
```

#### **B. Usage in app.dart**
```dart
final themeModeAsync = ref.watch(themeModeProvider);
return themeModeAsync.when(
  data: (themeMode) => MaterialApp.router(themeMode: themeMode, ...),
  loading: () => SplashScreen(),
  error: (e, st) => ErrorScreen(error: e),
);
```
- This **eliminates the need for a manual loading state** and ensures the theme is always correct as soon as storage is ready.

### 2. Why Not Use .maybeWhen/.whenData?
- Using an async provider pattern makes the theme state explicit and robust, and is the Riverpod best practice for async dependencies.
- You avoid race conditions and ensure the theme is never null or incorrect.

### 3. Further Tips
- You can still expose actions (toggle, setThemeMode) via methods on the notifier.
- For even snappier UX, cache the last theme in memory or use a splash screen that matches the previous theme.
- Always document the async flow for future maintainers.

---

## Summary Table
| Pattern                | Loading Handling | Best for                 |
|------------------------|-----------------|--------------------------|
| Sync Provider (current)| Manual in UI    | Synchronous dependencies |
| **AsyncNotifier (rec)**| Built-in        | Async dependencies       |

---

**Recommendation:** Refactor your ThemeManager to an AsyncNotifier as above. This will minimize theme loading delay and follow Riverpod best practices for async dependency injection.
