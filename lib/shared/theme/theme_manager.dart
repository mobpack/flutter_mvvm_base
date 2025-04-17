import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/services/storage/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeManager extends StateNotifier<ThemeMode> {
  final StorageService _storageService;

  ThemeManager({
    required StorageService storageService,
  })  : _storageService = storageService,
        super(ThemeMode.system) {
    _loadTheme();
  }

  bool get isDarkMode => state == ThemeMode.dark;

  void _loadTheme() {
    final savedTheme = _storageService.getString(StorageService.themeKey);
    if (savedTheme != null) {
      state = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _storageService.setString(StorageService.themeKey, state.toString());
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    _storageService.setString(StorageService.themeKey, state.toString());
  }
}
