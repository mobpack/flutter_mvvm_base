import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/shared/theme/app_text_theme.dart';

var defaultBorderRadius = BorderRadius.circular(8);

var defaultShape = RoundedRectangleBorder(
  borderRadius: defaultBorderRadius,
);

var defaultHorizontalPadding = EdgeInsets.symmetric(horizontal: 16);
var defaultVerticalPadding = EdgeInsets.symmetric(vertical: 16);

class AppTheme {
  static ThemeData getTheme(BuildContext context, {bool isDark = false}) {
    final textTheme = AppTextTheme.getResponsiveTextTheme(context);

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: isDark ? Colors.teal[200] : Colors.teal,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: textTheme.bodyMedium,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? Colors.grey[400] : Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: defaultBorderRadius,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: defaultShape,
          visualDensity: VisualDensity.compact,
        ),
      ),
      buttonTheme: ButtonThemeData(
        minWidth: 120,
        shape: defaultShape,
        padding: defaultHorizontalPadding,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: defaultShape,
          minimumSize: const Size(120, 40),
          padding: defaultHorizontalPadding,
          visualDensity: VisualDensity.standard,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: defaultShape,
          minimumSize: const Size(40, 40),
          visualDensity: VisualDensity.standard,
          padding: defaultHorizontalPadding,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: defaultShape,
          minimumSize: const Size(120, 40),
          padding: defaultHorizontalPadding,
          visualDensity: VisualDensity.standard,
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
