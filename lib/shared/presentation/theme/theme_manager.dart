import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/shared/infrastructure/storage/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class ThemeManager extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final storage = ref.watch(storageRepositoryProvider);
    final savedTheme = storage.getString(themeKey);
    if (savedTheme != null) {
      return ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
    return ThemeMode.system;
  }

  Future<void> toggleTheme() async {
    final storage = ref.watch(storageRepositoryProvider);
    final currentTheme = state.valueOrNull ?? ThemeMode.system;
    final nextTheme =
        currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await storage.setString(themeKey, nextTheme.toString());
    state = AsyncValue.data(nextTheme);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final storage = ref.watch(storageRepositoryProvider);
    await storage.setString(themeKey, mode.toString());
    state = AsyncValue.data(mode);
  }
}

final themeModeProvider =
    AsyncNotifierProvider<ThemeManager, ThemeMode>(ThemeManager.new);

const String themeKey = 'theme_mode';
