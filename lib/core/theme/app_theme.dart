import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/core/theme/app_text_theme.dart';

class AppTheme {
  static ThemeData getTheme(BuildContext context, {bool isDark = false}) {
    final textTheme = AppTextTheme.getResponsiveTextTheme(context);
    
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: isDark ? Colors.deepPurple[200] : Colors.deepPurple,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: textTheme.bodyMedium,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? Colors.grey[400] : Colors.grey,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: textTheme.labelLarge,
        ),
      ),
    );
  }

  static ThemeData getLightTheme(BuildContext context) {
    return getTheme(context, isDark: false);
  }

  static ThemeData getDarkTheme(BuildContext context) {
    return getTheme(context, isDark: true);
  }
}
