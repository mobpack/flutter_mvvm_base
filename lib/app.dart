import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/core/di/service_locator.dart';
import 'package:flutter_mvvm_base/core/router/app_router.dart';
import 'package:flutter_mvvm_base/core/theme/app_theme.dart';
import 'package:flutter_mvvm_base/core/theme/theme_manager.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: getIt<ThemeManager>(),
      builder: (context, _) {
        return MaterialApp.router(
          title: 'Flutter MVVM Base',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: getIt<ThemeManager>().themeMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
