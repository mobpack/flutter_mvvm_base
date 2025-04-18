import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/service/storage/storage_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class ThemeManager extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final storageService = await ref.watch(storageServiceProvider.future);
    final savedTheme = storageService.getString(themeKey);
    if (savedTheme != null) {
      return ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
    return ThemeMode.system;
  }

  Future<void> toggleTheme() async {
    final storageService = await ref.watch(storageServiceProvider.future);
    final currentTheme = state.valueOrNull ?? ThemeMode.system;
    final nextTheme =
        currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await storageService.setString(themeKey, nextTheme.toString());
    state = AsyncValue.data(nextTheme);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final storageService = await ref.watch(storageServiceProvider.future);
    await storageService.setString(themeKey, mode.toString());
    state = AsyncValue.data(mode);
  }
}

final themeModeProvider =
    AsyncNotifierProvider<ThemeManager, ThemeMode>(ThemeManager.new);

const String themeKey = 'theme_mode';
