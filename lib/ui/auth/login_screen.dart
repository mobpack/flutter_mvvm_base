import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/core/widgets/base_scaffold.dart';
import 'package:flutter_mvvm_base/ui/auth/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginProvider);

    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: ReactiveForm(
          formGroup: state.form,
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
                      Icons.lock_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 32),
                    if (state.error != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          state.error!,
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
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
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) => _onSubmit(ref, context),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ReactiveCheckbox(
                          formControlName: 'rememberMe',
                        ),
                        const Text('Remember me'),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // TODO: Implement forgot password
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ReactiveFormConsumer(
                      builder: (context, form, child) {
                        return FilledButton(
                          onPressed: state.isLoading || !form.valid
                              ? null
                              : () => _onSubmit(ref, context),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: state.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('LOGIN'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to sign up
                          },
                          child: const Text('Sign Up'),
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

  Future<void> _onSubmit(WidgetRef ref, BuildContext context) async {
    await ref.read(loginProvider.notifier).login();
    if (!context.mounted) return;

    // Navigate to home on success
    if (ref.read(loginProvider).error == null) {
      context.go('/');
    }
  }
}
