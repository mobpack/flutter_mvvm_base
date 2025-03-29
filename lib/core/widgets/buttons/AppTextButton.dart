import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextButton extends TextButton {
  /// Whether the button is in loading state
  final bool isLoading;

  /// Custom loading indicator to show when [isLoading] is true
  final Widget? loadingIndicator;

  /// Default loading indicator color
  final Color? loadingColor;

  /// Creates a text button with optional loading state.
  /// 
  /// If [isLoading] is true, the button will be disabled and show a loading indicator.
  /// You can customize the loading indicator with [loadingIndicator].
  AppTextButton({
    super.key,
    VoidCallback? onPressed,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior,
    required String text,
    this.isLoading = false,
    this.loadingIndicator,
    this.loadingColor,
    TextStyle? textStyle,
  }) : super(
          onPressed: isLoading ? null : onPressed,
          child: isLoading 
              ? loadingIndicator ?? SizedBox(
                  width: 20.w, 
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: loadingColor,
                  ),
                )
              : Text(
                  text,
                  style: textStyle,
                ),
        );

  /// Creates a text button with an icon and text, with optional loading state.
  /// 
  /// The [icon] is displayed before the [text].
  /// If [isLoading] is true, the button will be disabled and show a loading indicator.
  static AppTextButton icon({
    Key? key,
    VoidCallback? onPressed,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    required String text,
    required Widget icon,
    bool isLoading = false,
    Widget? loadingIndicator,
    Color? loadingColor,
    TextStyle? textStyle,
    double spacing = 8.0,
  }) {
    return AppTextButton.custom(
      key: key,
      onPressed: onPressed,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      isLoading: isLoading,
      loadingIndicator: loadingIndicator,
      loadingColor: loadingColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: spacing.w),
          Text(text, style: textStyle),
        ],
      ),
    );
  }

  /// Creates a text button with a custom child, with optional loading state.
  /// 
  /// This constructor allows you to provide a completely custom [child] widget.
  /// If [isLoading] is true, the button will be disabled and show a loading indicator.
  AppTextButton.custom({
    super.key,
    VoidCallback? onPressed,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior,
    required Widget child,
    this.isLoading = false,
    this.loadingIndicator,
    this.loadingColor,
  }) : super(
          onPressed: isLoading ? null : onPressed,
          child: isLoading 
              ? loadingIndicator ?? SizedBox(
                  width: 20.w, 
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: loadingColor,
                  ),
                )
              : child,
        );
}
