import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/di/service_locator.dart';
import 'package:flutter_mvvm_base/services/storage_service.dart';
import 'package:flutter_mvvm_base/shared/router/app_router.dart';
import 'package:flutter_mvvm_base/shared/theme/app_theme.dart';
import 'package:flutter_mvvm_base/shared/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

final themeProvider = StateNotifierProvider<ThemeManager, ThemeMode>((ref) {
  return ThemeManager(
    storageService: getIt<StorageService>(),
  );
});

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);

    // Initialize ScreenUtil with design size
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Base design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Flutter MVVM Base',
          builder: (context, child) {
            // First wrap with ResponsiveBreakpoints
            final Widget responsiveChild = ResponsiveBreakpoints.builder(
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ],
              child: Builder(
                builder: (context) {
                  // Now we can safely use ResponsiveBreakpoints.of(context)
                  // Apply theme after ResponsiveBreakpoints is available
                  if (child != null) {
                    return Theme(
                      data: themeMode == ThemeMode.dark
                          ? AppTheme.getDarkTheme(context)
                          : AppTheme.getLightTheme(context),
                      child: child,
                    );
                  }
                  return const SizedBox();
                },
              ),
            );

            // Apply MediaQuery to ensure proper scaling
            final mediaQuery = MediaQuery.of(context);
            final scale = mediaQuery.textScaler;

            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: scale.clamp(
                  minScaleFactor: 0.8,
                  maxScaleFactor: 1.0,
                ),
              ),
              child: responsiveChild,
            );
          },
          themeMode: themeMode,
          routerConfig: router,
        );
      },
    );
  }
}
