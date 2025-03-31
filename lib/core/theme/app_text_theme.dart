import 'package:flutter/material.dart';

class AppTextTheme {
  static double _getAdaptiveFontSize(BuildContext context, double size) {
    return size; // Original size for mobile
  }

  static TextTheme getResponsiveTextTheme(BuildContext context) {
    return TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 40),
        fontWeight: FontWeight.normal,
      ),
      displayMedium: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 32),
        fontWeight: FontWeight.normal,
      ),
      displaySmall: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 28),
        fontWeight: FontWeight.normal,
      ),

      // Headline styles
      headlineLarge: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 24),
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 20),
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 18),
        fontWeight: FontWeight.w600,
      ),

      // Title styles
      titleLarge: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 16),
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 14),
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 12),
        fontWeight: FontWeight.w500,
      ),

      // Label styles
      labelLarge: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 14),
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 12),
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 10),
        fontWeight: FontWeight.w500,
      ),

      // Body styles
      bodyLarge: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 16),
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 14),
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 12),
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
