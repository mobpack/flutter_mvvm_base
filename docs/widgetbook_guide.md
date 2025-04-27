# Widgetbook Guide

## Overview

This guide explains how to use and maintain the [Widgetbook](https://widgetbook.io/) implementation in the Flutter MVVM Base project. Widgetbook provides a dedicated environment to showcase, develop, and test UI components in isolation, serving as a living design system documentation.

## Purpose

The Widgetbook serves several important purposes in the development workflow:

1. **Component Showcase**: Displays all UI components in isolation
2. **Visual Testing**: Allows testing components with different states and configurations
3. **Design Documentation**: Documents component usage and properties
4. **Design Consistency**: Ensures consistent implementation across the application
5. **Designer-Developer Collaboration**: Facilitates communication between designers and developers

## Project Structure

The Widgetbook is implemented as a separate Flutter application within the project:

```
widgetbook/
├── lib/
│   ├── main.dart                  # Entry point for the Widgetbook app
│   ├── main.directories.g.dart    # Generated directory structure
│   ├── widgets/                   # Widget showcases
│   └── use_cases/                 # Component use cases
├── pubspec.yaml                   # Dependencies for Widgetbook
└── analysis_options.yaml          # Linting rules for Widgetbook
```

## Running the Widgetbook

To launch the Widgetbook:

```bash
cd widgetbook
flutter run -d chrome
```

The Widgetbook is optimized for viewing in a web browser, but can also be run on other platforms.

## Main Components

### Main App Structure

The Widgetbook app is defined in `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_base/shared/presentation/theme/app_theme.dart';

// Generated file with directory structure
import 'main.directories.g.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      // Use the generated directories
      directories: directories,
      
      // Add app themes
      themes: [
        WidgetbookTheme(
          name: 'Light',
          data: AppTheme.getLightTheme(context),
        ),
        WidgetbookTheme(
          name: 'Dark',
          data: AppTheme.getDarkTheme(context),
        ),
      ],
      
      // Add device frames
      devices: [
        Apple.iPhone13,
        Samsung.s21ultra,
        Desktop.desktop1080p,
      ],
      
      // Add text scale factors
      textScaleFactors: [
        1.0,
        1.5,
        2.0,
      ],
      
      // Add app builder for ScreenUtil
      appBuilder: (context, child) {
        return ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, __) => child,
        );
      },
    );
  }
}
```

### Component Showcase

Components are showcased using the `@widgetbook.UseCase()` annotation:

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

## Adding New Components

### 1. Create Component Showcase

Create a new file in the appropriate directory under `widgetbook/lib/widgets/`:

```dart
// widgetbook/lib/widgets/buttons/secondary_button.dart
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:flutter_mvvm_base/shared/presentation/widgets/buttons/secondary_button.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: SecondaryButton,
)
Widget defaultSecondaryButton(BuildContext context) {
  return SecondaryButton(
    label: 'Secondary Button',
    onPressed: () {},
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: SecondaryButton,
)
Widget disabledSecondaryButton(BuildContext context) {
  return SecondaryButton(
    label: 'Disabled Button',
    onPressed: null,
  );
}

@widgetbook.UseCase(
  name: 'With Icon',
  type: SecondaryButton,
)
Widget iconSecondaryButton(BuildContext context) {
  return SecondaryButton(
    label: 'Button with Icon',
    icon: Icons.add,
    onPressed: () {},
  );
}
```

### 2. Generate Directory Structure

Run code generation to update the directory structure:

```bash
cd widgetbook
flutter pub run build_runner build --delete-conflicting-outputs
```

This will update the `main.directories.g.dart` file with the new component.

### 3. Organize Components

Components should be organized in a logical structure that mirrors the main application's widget organization:

```
widgetbook/lib/widgets/
├── buttons/                # Button components
├── dialogs/                # Dialog components
├── feedback/               # Error and feedback components
├── forms/                  # Form components
├── layouts/                # Layout components
└── screens/                # Screen templates
```

## Advanced Features

### Component Properties

Use `WidgetbookContainer` to display components with adjustable properties:

```dart
@widgetbook.UseCase(
  name: 'Customizable',
  type: PrimaryButton,
)
Widget customizablePrimaryButton(BuildContext context) {
  return WidgetbookContainer(
    child: PrimaryButton(
      label: context.knobs.text(
        label: 'Button Text',
        initialValue: 'Primary Button',
      ),
      icon: context.knobs.options(
        label: 'Icon',
        options: [
          Option(label: 'None', value: null),
          Option(label: 'Add', value: Icons.add),
          Option(label: 'Edit', value: Icons.edit),
          Option(label: 'Delete', value: Icons.delete),
        ],
      ),
      onPressed: context.knobs.boolean(
        label: 'Enabled',
        initialValue: true,
      ) ? () {} : null,
    ),
  );
}
```

### Component Documentation

Add documentation to component showcases:

```dart
@widgetbook.UseCase(
  name: 'Default',
  type: PrimaryButton,
  designLink: 'https://www.figma.com/file/...',
)
Widget defaultPrimaryButton(BuildContext context) {
  return Column(
    children: [
      const Text(
        'Primary Button is used for main call-to-action elements.',
        style: TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 16),
      PrimaryButton(
        label: 'Primary Button',
        onPressed: () {},
      ),
    ],
  );
}
```

### Component Stories

Create multiple variations of a component to show different states and configurations:

```dart
@widgetbook.UseCase(
  name: 'States',
  type: PrimaryButton,
)
Widget primaryButtonStates(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Default'),
      PrimaryButton(
        label: 'Primary Button',
        onPressed: () {},
      ),
      const SizedBox(height: 16),
      
      const Text('Disabled'),
      PrimaryButton(
        label: 'Disabled Button',
        onPressed: null,
      ),
      const SizedBox(height: 16),
      
      const Text('Loading'),
      PrimaryButton(
        label: 'Loading Button',
        isLoading: true,
        onPressed: () {},
      ),
      const SizedBox(height: 16),
      
      const Text('With Icon'),
      PrimaryButton(
        label: 'Button with Icon',
        icon: Icons.add,
        onPressed: () {},
      ),
    ],
  );
}
```

## Integration with Main Project

The Widgetbook imports components directly from the main project, ensuring that any changes to the components are immediately reflected in the Widgetbook.

### Component Implementation

When implementing components in the main project, consider how they will be displayed in the Widgetbook:

1. **Flexibility**: Design components to be flexible and reusable
2. **Documentation**: Add DartDoc comments to component classes
3. **Default Values**: Provide sensible default values for optional parameters
4. **Responsive Design**: Ensure components work well in different screen sizes

## Best Practices

### 1. Keep Widgetbook Updated

Whenever a new UI component is added or an existing one is modified, update the Widgetbook accordingly.

### 2. Use Real Data

Use realistic data in component showcases to better represent how components will look in the actual application.

### 3. Show Multiple States

Showcase components in different states (default, disabled, loading, error, etc.) to ensure they handle all scenarios correctly.

### 4. Test Responsiveness

Test components at different screen sizes using the device frames provided by Widgetbook.

### 5. Add Documentation

Include documentation for each component to explain its purpose, usage, and any special considerations.

### 6. Organize Logically

Organize components in a logical structure that makes it easy to find specific components.

### 7. Use Consistent Naming

Use consistent naming conventions for component showcases.

### 8. Link to Design Files

Include links to design files (e.g., Figma) where applicable to provide reference to the original design.

## Development Guidelines

As per the project rules:

1. **Do not modify** files in the `/widgetbook` directory as part of main app development
2. Keep the Widgetbook up-to-date with all UI components
3. Document component variants, states, and usage examples
4. Use the Widgetbook for visual testing before implementing components in the main app
5. Consider the Widgetbook as the source of truth for UI component implementation

## Conclusion

The Widgetbook is an essential tool for maintaining a consistent and well-documented UI component library. By following the guidelines in this document, you can ensure that your UI components are well-designed, thoroughly tested, and properly documented.
