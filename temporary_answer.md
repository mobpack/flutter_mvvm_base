# 1. Current Analysis

- `lib/domain/`
  - **entity/**: shared domain models used across multiple features
  - **repository/**: abstract repository interfaces

- `lib/features/auth/`
  - **domain/**: auth-specific models & interfaces
  - **usecases/**: business logic for authentication
  - **data/** & **presentation/**: layers mapping to domain use cases

- `lib/features/user/`
  - **domain/**: user-specific models & interfaces
  - **usecases/**, **data/**, **presentation/**: feature layers

- `lib/shared/data/`
  - shared data models, DTOs, mappers, sources

- `lib/shared/domain/`
  - truly global domain types (value objects, failures, exceptions)

---

# 2. Migration Plan: Flatten `lib/domain`

1. **Inventory**
   - List all Dart files under `lib/domain/` using:
     ```bash
     find lib/domain -type f -name "*.dart"
     ```
2. **Categorize & Map**
   - **Feature-specific** types → `lib/features/<feature>/domain/`
   - **Shared** types → `lib/shared/domain/`
   - **Specific mappings**:
     - `lib/domain/entity/user/` → `lib/features/user/domain/`
     - `lib/domain/repository/user_repository.dart` → `lib/features/user/domain/user_repository.dart`
     - `lib/domain/repository/storage_repository.dart` → `lib/shared/domain/storage_repository.dart`
3. **Move Files**
   - E.g.:
     ```bash
     git mv lib/domain/entity/user.dart lib/features/user/domain/user.dart
     git mv lib/domain/repository/user_repository.dart lib/features/user/domain/user_repository.dart
     git mv lib/domain/repository/storage_repository.dart lib/shared/domain/storage_repository.dart
     ```
4. **Update Imports**
   - Replace all `package:…/domain/...` imports with new paths.
   - Use IDE refactor or global `sed`/`rg –replace` commands.
5. **Rebuild & Verify**
   - Run codegen:
     ```bash
     flutter pub run build_runner build --delete-conflicting-outputs
     ```
   - Run analyzer:
     ```bash
     flutter analyze
     ```
   - Fix any errors.
6. **Test**
   - Execute unit/widget/integration tests.
7. **Delete Empty Folder**
   - Once all files relocated, remove:
     ```bash
     git rm -r lib/domain
     ```
8. **Commit**
   - Commit with clear message: “chore: flatten lib/domain into feature/shared modules”

---

# 3. New Structure Overview (`lib`)

```
lib/
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   ├── data/
│   │   ├── presentation/
│   │   └── usecases/
│   └── user/
│       ├── domain/
│       ├── data/
│       ├── presentation/
│       └── usecases/
├── shared/
│   ├── domain/
│   └── data/
└── main.dart
```

This plan ensures all domain types are co-located with their features or shared as true globals. Delete `lib/domain` once migration is verified.