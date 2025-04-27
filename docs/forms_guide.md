# Forms Implementation Guide

## Overview

This guide explains the approach to implementing forms in the Flutter MVVM Base project using the [reactive_forms](https://pub.dev/packages/reactive_forms) package. The project adopts a reactive approach to form handling, making form state management and validation more declarative and maintainable.

## Why Reactive Forms?

Traditional form handling in Flutter often involves managing form state manually, which can lead to several issues:

1. **Verbose Code**: Managing form state, validation, and submission can be verbose
2. **Error-Prone**: Manual validation is error-prone and difficult to maintain
3. **Limited Reactivity**: It's challenging to make forms reactive to changes
4. **Complex Validation**: Complex validation rules are difficult to implement

Reactive Forms addresses these issues by:

1. **Declarative Approach**: Forms are defined declaratively
2. **Built-in Validation**: Comprehensive validation system
3. **Reactive State**: Form state is reactive and observable
4. **Form Groups**: Support for nested form groups and arrays
5. **Type Safety**: Strong typing for form controls

## Basic Concepts

### Form Controls

Form controls represent individual form fields:

```dart
final emailControl = FormControl<String>(
  value: '', // Initial value
  validators: [
    Validators.required,
    Validators.email,
  ],
);
```

### Form Groups

Form groups represent a collection of form controls:

```dart
final loginForm = FormGroup({
  'email': FormControl<String>(
    validators: [Validators.required, Validators.email],
  ),
  'password': FormControl<String>(
    validators: [Validators.required, Validators.minLength(8)],
  ),
});
```

### Form Arrays

Form arrays represent a dynamic list of form controls or groups:

```dart
final phoneNumbersForm = FormArray([
  FormControl<String>(validators: [Validators.required]),
]);
```

## Implementation in MVVM

The project integrates reactive_forms with the MVVM architecture pattern:

### ViewModel Layer

ViewModels define and manage form groups:

```dart
@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  AsyncValue<void> build() => const AsyncData(null);
  
  // Define the form
  FormGroup get form => FormGroup({
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    'password': FormControl<String>(
      validators: [Validators.required, Validators.minLength(8)],
    ),
    'rememberMe': FormControl<bool>(
      value: false,
    ),
  });
  
  Future<void> submit() async {
    if (form.invalid) {
      form.markAllAsTouched();
      return;
    }
    
    state = const AsyncLoading();
    
    final email = form.control('email').value as String;
    final password = form.control('password').value as String;
    final rememberMe = form.control('rememberMe').value as bool;
    
    final result = await ref.read(loginUseCaseProvider).call(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );
    
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }
}
```

### UI Layer

The UI layer uses reactive form widgets to connect to the form defined in the ViewModel:

```dart
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(loginViewModelProvider.notifier);
    final loginState = ref.watch(loginViewModelProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: viewModel.form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ReactiveTextField<String>(
                formControlName: 'email',
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                validationMessages: {
                  ValidationMessage.required: (_) => 'Email is required',
                  ValidationMessage.email: (_) => 'Enter a valid email',
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              ReactiveTextField<String>(
                formControlName: 'password',
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                obscureText: true,
                validationMessages: {
                  ValidationMessage.required: (_) => 'Password is required',
                  ValidationMessage.minLength: (_) => 
                      'Password must be at least 8 characters',
                },
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 16),
              ReactiveCheckbox(
                formControlName: 'rememberMe',
                title: const Text('Remember me'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: loginState is AsyncLoading
                    ? null
                    : () => viewModel.submit(),
                child: loginState is AsyncLoading
                    ? const CircularProgressIndicator()
                    : const Text('LOGIN'),
              ),
              if (loginState is AsyncError)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    (loginState as AsyncError).error.toString(),
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Form Validation

### Built-in Validators

Reactive Forms provides several built-in validators:

```dart
FormControl<String>(
  validators: [
    Validators.required,
    Validators.email,
    Validators.minLength(8),
    Validators.maxLength(100),
    Validators.pattern(r'^[a-zA-Z0-9]+$'),
    Validators.mustMatch('password', 'confirmPassword'),
  ],
)
```

### Custom Validators

Custom validators can be created for specific validation rules:

```dart
// Custom validator function
Map<String, dynamic>? passwordStrengthValidator(AbstractControl<dynamic> control) {
  final value = control.value as String?;
  if (value == null || value.isEmpty) {
    return null;
  }
  
  final hasUppercase = value.contains(RegExp(r'[A-Z]'));
  final hasLowercase = value.contains(RegExp(r'[a-z]'));
  final hasDigit = value.contains(RegExp(r'[0-9]'));
  final hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  
  if (hasUppercase && hasLowercase && hasDigit && hasSpecialChar) {
    return null;
  }
  
  return {'passwordStrength': true};
}

// Using the custom validator
FormControl<String>(
  validators: [
    Validators.required,
    Validators.minLength(8),
    passwordStrengthValidator,
  ],
)
```

### Async Validators

Async validators can be used for validation that requires asynchronous operations:

```dart
// Async validator function
Future<Map<String, dynamic>?> emailAvailableValidator(
  AbstractControl<dynamic> control,
) async {
  final value = control.value as String?;
  if (value == null || value.isEmpty) {
    return null;
  }
  
  final isAvailable = await checkEmailAvailability(value);
  
  if (isAvailable) {
    return null;
  }
  
  return {'emailTaken': true};
}

// Using the async validator
FormControl<String>(
  validators: [Validators.required, Validators.email],
  asyncValidators: [emailAvailableValidator],
)
```

## Form Submission

### Handling Form Submission

```dart
Future<void> submit() async {
  if (form.invalid) {
    form.markAllAsTouched();
    return;
  }
  
  state = const AsyncLoading();
  
  final formValue = form.value;
  
  final result = await ref.read(registerUseCaseProvider).call(
    email: formValue['email'] as String,
    password: formValue['password'] as String,
    name: formValue['name'] as String,
  );
  
  state = result.fold(
    (failure) => AsyncError(failure, StackTrace.current),
    (_) => const AsyncData(null),
  );
}
```

### Form Reset

```dart
void resetForm() {
  form.reset();
}
```

## Dynamic Forms

### Form Arrays

Form arrays can be used to create dynamic forms:

```dart
// ViewModel
FormGroup get dynamicForm => FormGroup({
  'name': FormControl<String>(validators: [Validators.required]),
  'phoneNumbers': FormArray<String>([
    FormControl<String>(validators: [Validators.required]),
  ]),
});

void addPhoneNumber() {
  final phoneNumbers = dynamicForm.control('phoneNumbers') as FormArray;
  phoneNumbers.add(FormControl<String>(validators: [Validators.required]));
}

void removePhoneNumber(int index) {
  final phoneNumbers = dynamicForm.control('phoneNumbers') as FormArray;
  phoneNumbers.removeAt(index);
}

// UI
ReactiveForm(
  formGroup: viewModel.dynamicForm,
  child: Column(
    children: [
      ReactiveTextField<String>(
        formControlName: 'name',
        decoration: const InputDecoration(labelText: 'Name'),
      ),
      const SizedBox(height: 16),
      ReactiveFormArray<String>(
        formArrayName: 'phoneNumbers',
        builder: (context, formArray, child) {
          return Column(
            children: [
              ...formArray.controls.asMap().entries.map((entry) {
                final index = entry.key;
                return Row(
                  children: [
                    Expanded(
                      child: ReactiveTextField<String>(
                        formControlName: index.toString(),
                        decoration: InputDecoration(
                          labelText: 'Phone Number ${index + 1}',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed: () => viewModel.removePhoneNumber(index),
                    ),
                  ],
                );
              }).toList(),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Phone Number'),
                onPressed: () => viewModel.addPhoneNumber(),
              ),
            ],
          );
        },
      ),
    ],
  ),
)
```

### Nested Form Groups

Nested form groups can be used for complex forms:

```dart
// ViewModel
FormGroup get addressForm => FormGroup({
  'personalInfo': FormGroup({
    'firstName': FormControl<String>(validators: [Validators.required]),
    'lastName': FormControl<String>(validators: [Validators.required]),
  }),
  'address': FormGroup({
    'street': FormControl<String>(validators: [Validators.required]),
    'city': FormControl<String>(validators: [Validators.required]),
    'state': FormControl<String>(validators: [Validators.required]),
    'zipCode': FormControl<String>(validators: [Validators.required]),
  }),
});

// UI
ReactiveForm(
  formGroup: viewModel.addressForm,
  child: Column(
    children: [
      // Personal Info
      Text('Personal Information', style: Theme.of(context).textTheme.titleLarge),
      ReactiveTextField<String>(
        formControlName: 'personalInfo.firstName',
        decoration: const InputDecoration(labelText: 'First Name'),
      ),
      ReactiveTextField<String>(
        formControlName: 'personalInfo.lastName',
        decoration: const InputDecoration(labelText: 'Last Name'),
      ),
      
      // Address
      Text('Address', style: Theme.of(context).textTheme.titleLarge),
      ReactiveTextField<String>(
        formControlName: 'address.street',
        decoration: const InputDecoration(labelText: 'Street'),
      ),
      ReactiveTextField<String>(
        formControlName: 'address.city',
        decoration: const InputDecoration(labelText: 'City'),
      ),
      ReactiveTextField<String>(
        formControlName: 'address.state',
        decoration: const InputDecoration(labelText: 'State'),
      ),
      ReactiveTextField<String>(
        formControlName: 'address.zipCode',
        decoration: const InputDecoration(labelText: 'Zip Code'),
      ),
    ],
  ),
)
```

## Form State Management

### Listening to Form Changes

```dart
@override
void initState() {
  super.initState();
  
  final form = ref.read(formViewModelProvider).form;
  
  // Listen to value changes
  form.valueChanges.listen((value) {
    print('Form value changed: $value');
  });
  
  // Listen to status changes
  form.statusChanged.listen((status) {
    print('Form status changed: $status');
  });
  
  // Listen to a specific control
  form.control('email').valueChanges.listen((value) {
    print('Email value changed: $value');
  });
}
```

### Conditional Validation

```dart
// ViewModel
FormGroup get registrationForm => FormGroup({
  'email': FormControl<String>(
    validators: [Validators.required, Validators.email],
  ),
  'usePhone': FormControl<bool>(value: false),
  'phone': FormControl<String>(
    validators: [], // Will be updated based on usePhone
  ),
});

void updatePhoneValidation() {
  final usePhone = registrationForm.control('usePhone').value as bool;
  final phoneControl = registrationForm.control('phone');
  
  if (usePhone) {
    phoneControl.setValidators([Validators.required]);
  } else {
    phoneControl.setValidators([]);
  }
  
  phoneControl.updateValueAndValidity();
}

// UI
ReactiveForm(
  formGroup: viewModel.registrationForm,
  child: Column(
    children: [
      ReactiveTextField<String>(
        formControlName: 'email',
        decoration: const InputDecoration(labelText: 'Email'),
      ),
      ReactiveCheckbox(
        formControlName: 'usePhone',
        title: const Text('Use phone for verification'),
        onChanged: (_) => viewModel.updatePhoneValidation(),
      ),
      ReactiveValueListenableBuilder<bool>(
        formControlName: 'usePhone',
        builder: (context, usePhone, child) {
          return Visibility(
            visible: usePhone.value ?? false,
            child: ReactiveTextField<String>(
              formControlName: 'phone',
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
          );
        },
      ),
    ],
  ),
)
```

## Testing Forms

### Testing ViewModels

```dart
void main() {
  group('LoginViewModel', () {
    late LoginViewModel viewModel;
    
    setUp(() {
      final container = ProviderContainer();
      viewModel = container.read(loginViewModelProvider.notifier);
    });
    
    test('form should be invalid initially', () {
      expect(viewModel.form.valid, isFalse);
    });
    
    test('form should be valid with correct inputs', () {
      viewModel.form.control('email').value = 'test@example.com';
      viewModel.form.control('password').value = 'password123';
      
      expect(viewModel.form.valid, isTrue);
    });
    
    test('form should be invalid with incorrect email', () {
      viewModel.form.control('email').value = 'invalid-email';
      viewModel.form.control('password').value = 'password123';
      
      expect(viewModel.form.valid, isFalse);
      expect(viewModel.form.control('email').errors, contains('email'));
    });
  });
}
```

### Testing UI

```dart
void main() {
  group('LoginScreen', () {
    testWidgets('should show validation errors when submitting empty form',
        (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );
      
      // Act
      await tester.tap(find.text('LOGIN'));
      await tester.pump();
      
      // Assert
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });
    
    testWidgets('should call submit when form is valid', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loginViewModelProvider.overrideWith((ref) => MockLoginViewModel()),
          ],
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );
      
      // Act
      await tester.enterText(
        find.byType(ReactiveTextField<String>).first,
        'test@example.com',
      );
      await tester.enterText(
        find.byType(ReactiveTextField<String>).last,
        'password123',
      );
      await tester.tap(find.text('LOGIN'));
      await tester.pump();
      
      // Assert
      verify(mockViewModel.submit()).called(1);
    });
  });
}
```

## Best Practices

### 1. Define Forms in ViewModels

Keep form definitions in ViewModels to separate business logic from UI.

### 2. Use Typed Controls

Use typed form controls to leverage Dart's type system:

```dart
FormControl<String>(validators: [Validators.required])
```

### 3. Group Related Controls

Group related controls together using form groups:

```dart
FormGroup({
  'address': FormGroup({
    'street': FormControl<String>(),
    'city': FormControl<String>(),
    'state': FormControl<String>(),
    'zipCode': FormControl<String>(),
  }),
})
```

### 4. Provide Clear Validation Messages

Provide clear validation messages for each validation rule:

```dart
ReactiveTextField<String>(
  formControlName: 'email',
  validationMessages: {
    ValidationMessage.required: (_) => 'Email is required',
    ValidationMessage.email: (_) => 'Please enter a valid email address',
  },
)
```

### 5. Use Form Builders for Complex Forms

Use form builders for complex forms to improve code organization:

```dart
class RegistrationFormBuilder {
  static FormGroup build() {
    return FormGroup({
      'personalInfo': buildPersonalInfoGroup(),
      'accountInfo': buildAccountInfoGroup(),
      'preferences': buildPreferencesGroup(),
    });
  }
  
  static FormGroup buildPersonalInfoGroup() {
    return FormGroup({
      'firstName': FormControl<String>(validators: [Validators.required]),
      'lastName': FormControl<String>(validators: [Validators.required]),
      // Additional controls...
    });
  }
  
  // Additional builder methods...
}
```

### 6. Handle Form Submission Properly

Always validate the form before submission and handle loading and error states:

```dart
Future<void> submit() async {
  if (form.invalid) {
    form.markAllAsTouched();
    return;
  }
  
  // Proceed with submission...
}
```

### 7. Test Form Validation

Write tests for form validation to ensure it works as expected.

### 8. Use Reactive Widgets

Use reactive widgets to automatically update the UI when form state changes.

### 9. Implement Form Reset

Implement form reset functionality to clear form state:

```dart
void resetForm() {
  form.reset();
}
```

### 10. Document Complex Forms

Document complex forms and validation rules to make them easier to understand and maintain.

## Conclusion

Reactive Forms provides a powerful and flexible approach to form handling in Flutter applications. By following the patterns and best practices outlined in this guide, you can create maintainable, testable, and user-friendly forms for your Flutter MVVM Base project.
