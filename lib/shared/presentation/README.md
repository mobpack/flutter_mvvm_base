# Presentation Layer

This directory contains shared presentation components following the MVVM (Model-View-ViewModel) architecture pattern. These components are designed to be reusable across multiple features of the application.

## Directory Structure

```
presentation/
├── state/                  # Shared state management
│   └── providers/         # Shared Riverpod providers
├── theme/                 # Theme definitions and styling
│   ├── app_theme.dart     # Main theme configuration
│   ├── color_schemes.dart # Color schemes for light/dark modes
│   ├── text_styles.dart   # Typography definitions
│   └── theme_manager.dart # Theme state management
└── widgets/               # Reusable UI components
    ├── buttons/           # Button components
    ├── dialogs/           # Dialog components
    ├── feedback/          # Error and feedback components
    ├── forms/             # Form components and inputs
    │   └── dynamic_form/   # Dynamic form generation
    ├── layouts/           # Layout components
    └── screens/           # Common screen templates
```

## Theme System

The theme system provides consistent styling across the application with support for light and dark modes.

### Key Components

- **AppTheme**: Central configuration for the application's visual styling
- **ColorSchemes**: Defines color palettes for light and dark modes
- **TextStyles**: Typography definitions following Material Design guidelines
- **ThemeManager**: Manages theme state and persistence

### Usage

```dart
// Access the current theme mode
final themeMode = ref.watch(themeModeProvider);

// Get the appropriate theme data
final themeData = themeMode == ThemeMode.dark
    ? AppTheme.getDarkTheme(context)
    : AppTheme.getLightTheme(context);

// Toggle theme mode
ref.read(themeModeProvider.notifier).toggleTheme();
```

## Widget Library

The widget library provides reusable UI components that follow consistent design patterns.

### Button Components

- **PrimaryButton**: Main call-to-action button
- **SecondaryButton**: Alternative action button
- **TextButton**: Minimal button for less prominent actions
- **IconButton**: Button with icon only

### Dialog Components

- **AlertDialog**: For important notifications
- **ConfirmationDialog**: For user confirmations
- **BottomSheetDialog**: For additional options or details

### Feedback Components

- **ErrorDisplay**: For showing error messages
- **LoadingIndicator**: For loading states
- **SnackbarManager**: For temporary notifications

### Form Components

- **TextInput**: Standard text input field
- **PasswordInput**: Secure text input with visibility toggle
- **DropdownInput**: Selection from a list of options
- **DatePicker**: Date selection component
- **DynamicForm**: Form generation from a configuration

### Layout Components

- **ResponsiveLayout**: Adapts to different screen sizes
- **PageScaffold**: Standard page layout with app bar
- **ContentCard**: Card container for content sections

## Best Practices

### Widget Design

1. Use stateless widgets unless state is required
2. Prefer `ConsumerWidget` for screens and widgets that require state management
3. Use `const` constructors for better performance
4. Break UI into small, reusable components
5. Follow Material Design guidelines
6. Ensure accessibility compliance (proper contrast, semantic labels)

### State Management

1. Use Riverpod for state management and dependency injection
2. Create providers in the appropriate layer
3. Separate business logic from UI components
4. Use proper error handling and loading states

### Documentation and Testing

1. Document all widgets with DartDoc comments
2. Write widget tests for all components
3. Include usage examples in documentation
4. Use meaningful naming that reflects the component's purpose

### Responsive Design

1. Use `ResponsiveFramework` for adaptive layouts
2. Use `ScreenUtil` for consistent sizing across devices
3. Test UI on multiple screen sizes
4. Design for both portrait and landscape orientations

## Adding New Components

When adding new shared components:

1. Place them in the appropriate directory based on their purpose
2. Follow the existing naming conventions and code style
3. Document the component with DartDoc comments
4. Write tests for the component
5. Add the component to the Widgetbook for showcase
6. Update this README if necessary

