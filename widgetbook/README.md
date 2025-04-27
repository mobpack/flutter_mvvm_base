# Widgetbook

This directory contains a [Widgetbook](https://widgetbook.io/) implementation for the Flutter MVVM Base project. Widgetbook provides a dedicated environment to showcase, develop, and test UI components in isolation.

## Purpose

The Widgetbook serves as a component library and design system documentation for the project, allowing developers and designers to:

1. View all UI components in isolation
2. Test components with different states and configurations
3. Document component usage and properties
4. Ensure consistent design implementation
5. Facilitate collaboration between designers and developers

## Structure

```
widgetbook/
├── lib/
│   ├── main.dart                  # Entry point for the Widgetbook app
│   ├── main.directories.g.dart    # Generated directory structure
│   ├── widgets/                  # Widget showcases
│   └── use_cases/                # Component use cases
├── pubspec.yaml                # Dependencies for Widgetbook
└── analysis_options.yaml       # Linting rules for Widgetbook
```

## Usage

### Running the Widgetbook

To launch the Widgetbook:

```bash
cd widgetbook
flutter run -d chrome
```

The Widgetbook is optimized for viewing in a web browser, but can also be run on other platforms.

### Adding New Components

1. Create a new file in the appropriate directory under `lib/widgets/`
2. Use the `@widgetbook.UseCase()` annotation to define component showcases
3. Run code generation to update the directory structure

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Example Component Showcase

```dart
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:flutter_mvvm_base/shared/presentation/widgets/buttons/primary_button.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: PrimaryButton,
)
Widget defaultPrimaryButton(BuildContext context) {
  return PrimaryButton(
    label: 'Primary Button',
    onPressed: () {},
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: PrimaryButton,
)
Widget disabledPrimaryButton(BuildContext context) {
  return PrimaryButton(
    label: 'Disabled Button',
    onPressed: null,
  );
}
```

## Integration with Main Project

The Widgetbook imports components directly from the main project, ensuring that any changes to the components are immediately reflected in the Widgetbook.

## Development Guidelines

1. **Do not modify** files in the `/widgetbook` directory as part of main app development
2. Keep the Widgetbook up-to-date with all UI components
3. Document component variants, states, and usage examples
4. Use the Widgetbook for visual testing before implementing components in the main app
5. Consider the Widgetbook as the source of truth for UI component implementation
