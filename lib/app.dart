import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/shared/infrastructure/auth/providers/auth_notifier.dart';
import 'package:flutter_mvvm_base/shared/infrastructure/navigation/services/app_router.dart';
import 'package:flutter_mvvm_base/shared/presentation/theme/app_theme.dart';
import 'package:flutter_mvvm_base/shared/presentation/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    // Check authentication state when app starts
    Future.microtask(() {
      ref.read(authNotifierProvider.notifier).checkAuthState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeModeAsync = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);

    return themeModeAsync.when(
      data: (themeMode) => ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return ScreenUtilInit(
            designSize: const Size(360, 690), // Base design size
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Flutter MVVM Base',
                builder: (context, child) {
                  // First wrap with ResponsiveBreakpoints
                  final Widget responsiveChild = ResponsiveBreakpoints.builder(
                    breakpoints: [
                      const Breakpoint(start: 0, end: 450, name: MOBILE),
                      const Breakpoint(start: 451, end: 800, name: TABLET),
                      const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                      const Breakpoint(
                        start: 1921,
                        end: double.infinity,
                        name: '4K',
                      ),
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
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Theme error: $e')),
        ),
      ),
    );
  }
}
