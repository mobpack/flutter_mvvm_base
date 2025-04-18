import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/shared/widgets/base_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Redirect to home if already authenticated

    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: ReactiveForm(
          formGroup: FormGroup({
            'email': FormControl<String>(
              validators: [
                Validators.required,
                Validators.email,
              ],
            ),
            'password': FormControl<String>(
              validators: [
                Validators.required,
                Validators.minLength(6),
              ],
            ),
            'confirmPassword': FormControl<String>(
              validators: [
                Validators.required,
              ],
            ),
          }),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Icon(
                      Icons.person_add_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 32),
                    ReactiveTextField<String>(
                      formControlName: 'email',
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
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
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                      validationMessages: {
                        ValidationMessage.required: (_) =>
                            'Password is required',
                        ValidationMessage.minLength: (_) =>
                            'Password must be at least 6 characters',
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    ReactiveTextField<String>(
                      formControlName: 'confirmPassword',
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                      validationMessages: {
                        ValidationMessage.required: (_) =>
                            'Confirm password is required',
                        ValidationMessage.mustMatch: (_) =>
                            'Passwords must match',
                      },
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) {},
                    ),
                    const SizedBox(height: 24),
                    ReactiveFormConsumer(
                      builder: (context, form, child) {
                        return FilledButton(
                          onPressed: () {},
                          child: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('REGISTER'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
