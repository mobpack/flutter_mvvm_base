# Presentation

This directory contains shared presentation components following the MVVM architecture pattern.

## Structure

- **state/**: Shared state management
  - **providers/**: Shared providers
- **theme/**: Theme definitions and styling
- **widgets/**: Reusable UI components
  - **buttons/**: Button components
  - **dialogs/**: Dialog components
  - **feedback/**: Error and feedback components
  - **forms/**: Form components and inputs
  - **layouts/**: Layout components
  - **screens/**: Common screen templates

## Best Practices

1. Use stateless widgets unless state is required
2. Prefer Riverpod for state management
3. Use ConsumerWidget for widgets that require state management
4. Use const constructors for better performance
5. Break UI into small, reusable components
6. Document all widgets with DartDoc comments
7. Follow Material Design guidelines
8. Write widget tests for all components
9. Use meaningful naming that reflects the component's purpose
10. Separate business logic from UI components
11. Use proper error handling and loading states
12. Ensure accessibility compliance
