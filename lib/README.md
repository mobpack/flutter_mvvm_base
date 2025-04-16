# lib/ Structure

This directory follows a feature-first, layered architecture inspired by Clean Architecture and industry best practices.

- `core/`: Dependency injection, routing, theming, utilities, and config/constants.
- `features/`: Each app feature contains its own data, domain, and presentation layers.
- `shared/`: Widgets, services, and utilities used across multiple features.

## Adding a New Feature
1. Create a folder in `features/` (e.g., `features/profile/`).
2. Inside, add `data/`, `domain/`, and `presentation/` as needed.
3. Add tests in `test/features/feature_name/`.

## Shared Code
- Place reusable widgets in `shared/widgets/`.
- Place shared services in `shared/services/`.
- Place utilities in `shared/utils/`.

## Config/Constants
- Use `core/config/` for app-wide constants and configuration.
