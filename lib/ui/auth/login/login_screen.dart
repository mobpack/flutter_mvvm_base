import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/core/widgets/base_scaffold.dart';
import 'package:flutter_mvvm_base/ui/auth/login/view_model/login_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);

    // Redirect to home if already authenticated
    if (state.user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/');
      });
    }

    return BaseScaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
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
                    padding: EdgeInsets.all(16.w),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Center(
                      child: Container(
                        width: contentWidth,
                        constraints: BoxConstraints(maxWidth: 500.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 0.05.sh),
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Icon(
                                Icons.lock_outline,
                                size: 48.w,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 32.h),
                            if (state.error != null)
                              Container(
                                margin: EdgeInsets.only(bottom: 16.h),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 24.w,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onErrorContainer,
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        state.error!.message,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onErrorContainer,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ReactiveTextField<String>(
                              formControlName: 'email',
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                                prefixIcon:
                                    Icon(Icons.email_outlined, size: 24.w),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.surface,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                              ),
                              validationMessages: {
                                ValidationMessage.required: (_) =>
                                    'Email is required',
                                ValidationMessage.email: (_) =>
                                    'Enter a valid email',
                              },
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            SizedBox(height: 16.h),
                            ReactiveTextField<String>(
                              formControlName: 'password',
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                                prefixIcon:
                                    Icon(Icons.lock_outline, size: 24.w),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.surface,
                              ),
                              validationMessages: {
                                ValidationMessage.required: (_) =>
                                    'Password is required',
                                ValidationMessage.minLength: (_) =>
                                    'Password must be at least 6 characters',
                              },
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _onSubmit(viewModel, context),
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            SizedBox(height: 8.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // TODO: Implement forgot password
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            FilledButton(
                              onPressed: () => _onSubmit(viewModel, context),
                              style: FilledButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: state.isLoading
                                  ? SizedBox(
                                      height: 20.h,
                                      width: 20.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      'Login',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                            ),
                            if (isWideScreen) SizedBox(height: 32.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.push('/register');
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ),
                              ],
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

  void _onSubmit(LoginViewModel viewModel, BuildContext context) {
    if (viewModel.form.valid) {
      viewModel.login();
    } else {
      viewModel.form.markAllAsTouched();
    }
  }
}
