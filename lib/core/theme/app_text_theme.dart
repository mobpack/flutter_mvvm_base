import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppTextTheme {
  static double _getAdaptiveFontSize(BuildContext context, double size) {
    if (ResponsiveBreakpoints.of(context).isDesktop) {
      return size * 0.1; // 20% smaller for desktop
    } else if (ResponsiveBreakpoints.of(context).isTablet) {
      return size * 0.9; // 10% smaller for tablet
    }
    return size; // Original size for mobile
  }

  static TextTheme getResponsiveTextTheme(BuildContext context) {
    return TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 40.sp).sp,
        fontWeight: FontWeight.normal,
      ),
      displayMedium: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 32.sp).sp,
        fontWeight: FontWeight.normal,
      ),
      displaySmall: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 28.sp).sp,
        fontWeight: FontWeight.normal,
      ),

      // Headline styles
      headlineLarge: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 24.sp).sp,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 20.sp).sp,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 18.sp).sp,
        fontWeight: FontWeight.w600,
      ),

      // Title styles
      titleLarge: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 16.sp).sp,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 14.sp).sp,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 12.sp).sp,
        fontWeight: FontWeight.w500,
      ),

      // Label styles
      labelLarge: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 14.sp).sp,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 12.sp).sp,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 10.sp).sp,
        fontWeight: FontWeight.w500,
      ),

      // Body styles
      bodyLarge: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 16.sp).sp,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 14.sp).sp,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        fontSize: _getAdaptiveFontSize(context, 12.sp).sp,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
