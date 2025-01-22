import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/core/di/service_locator.dart';
import 'package:flutter_mvvm_base/core/router/app_router.dart';
import 'package:flutter_mvvm_base/core/services/storage_service.dart';
import 'package:flutter_mvvm_base/core/theme/app_theme.dart';
import 'package:flutter_mvvm_base/core/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return MaterialApp.router(
      title: 'Flutter MVVM Base',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
