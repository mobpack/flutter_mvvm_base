import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/features/auth/presentation/login/viewmodels/login_viewmodel.dart';
import 'package:flutter_mvvm_base/shared/widgets/base_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginProvider);
    final viewModel = ref.read(loginProvider.notifier);

    // Redirect to home if already authenticated
    if (state.user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/');
      });
    }

    return BaseScaffold(
      body: SafeArea(
        child: ReactiveForm(
          formGroup: viewModel.form,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = ResponsiveBreakpoints.of(context).isDesktop;
              final contentWidth = isWideScreen ? 500.0 : constraints.maxWidth;

              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Center(
                      child: Container(
                        width: contentWidth,
                        constraints: BoxConstraints(maxWidth: 500),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 0.05),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              constraints: BoxConstraints(
                                maxWidth: 200,
                              ),
                              child: Icon(
                                Icons.lock_outline,
                                size: 48,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 32),
                            if (state.error != null)
                              LoginErrorContainer(error: state.error?.message),
                            ReactiveTextField<String>(
                              formControlName: 'email',
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon:
                                    Icon(Icons.email_outlined, size: 24),
                              ),
                              validationMessages: {
                                ValidationMessage.required: (_) =>
                                    'Email is required',
                                ValidationMessage.email: (_) =>
                                    'Enter a valid email',
                              },
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 16),
                            ReactiveTextField<String>(
                              formControlName: 'password',
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                                prefixIcon: Icon(Icons.lock_outline, size: 24),
                              ),
                              validationMessages: {
                                ValidationMessage.required: (_) =>
                                    'Password is required',
                                ValidationMessage.minLength: (_) =>
                                    'Password must be at least 6 characters',
                              },
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _onSubmit(viewModel, context),
                            ),
                            SizedBox(height: 8),
                            LoginForgotPassword(),
                            SizedBox(height: 24),
                            FilledButton(
                              onPressed: state.isLoading
                                  ? null
                                  : () => _onSubmit(viewModel, context),
                              child: Text(
                                'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                            if (isWideScreen) SizedBox(height: 32),
                            Text(
                              "Don't have an account?",
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                              onPressed: () {
                                context.push('/register');
                              },
                              child: Text(
                                'Sign Up',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (state.isLoading)
                    const Positioned.fill(
                      child: ColoredBox(
                        color: Color(0x80FFFFFF),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _onSubmit(Login viewModel, BuildContext context) {
    if (viewModel.form.valid) {
      viewModel.login();
    } else {
      viewModel.form.markAllAsTouched();
    }
  }
}

class LoginForgotPassword extends StatelessWidget {
  const LoginForgotPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Implement forgot password
        },
        child: Text(
          'Forgot Password?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ),
    );
  }
}

class LoginErrorContainer extends StatelessWidget {
  const LoginErrorContainer({
    required this.error,
    super.key,
  });

  final String? error;

  @override
  Widget build(BuildContext context) {
    if (error == null) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 24,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
