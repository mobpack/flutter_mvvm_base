import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/core/widgets/buttons/AppFilledButton.dart';
import 'package:flutter_mvvm_base/core/widgets/buttons/AppOutlinedButton.dart';
import 'package:flutter_mvvm_base/core/widgets/buttons/AppTextButton.dart';

/// A utility class that provides access to all custom button types.
/// 
/// This class is not meant to be instantiated, but rather used as a namespace
/// for accessing the different button types.
class AppButton {
  // Private constructor to prevent instantiation
  AppButton._();
  
  /// Creates a filled button with optional loading state
  static AppFilledButton filled({
    Key? key,
    VoidCallback? onPressed,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    required String text,
    bool isLoading = false,
    Widget? loadingIndicator,
    Color? loadingColor,
    TextStyle? textStyle,
  }) {
    return AppFilledButton(
      key: key,
      onPressed: onPressed,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      text: text,
      isLoading: isLoading,
      loadingIndicator: loadingIndicator,
      loadingColor: loadingColor,
      textStyle: textStyle,
    );
  }
  
  /// Creates a filled button with an icon and text, with optional loading state
  static AppFilledButton filledIcon({
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
    return AppFilledButton.icon(
      key: key,
      onPressed: onPressed,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      text: text,
      icon: icon,
      isLoading: isLoading,
      loadingIndicator: loadingIndicator,
      loadingColor: loadingColor,
      textStyle: textStyle,
      spacing: spacing,
    );
  }
  
  /// Creates an outlined button with optional loading state
  static AppOutlinedButton outlined({
    Key? key,
    VoidCallback? onPressed,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    required String text,
    bool isLoading = false,
    Widget? loadingIndicator,
    Color? loadingColor,
    TextStyle? textStyle,
  }) {
    return AppOutlinedButton(
      key: key,
      onPressed: onPressed,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      text: text,
      isLoading: isLoading,
      loadingIndicator: loadingIndicator,
      loadingColor: loadingColor,
      textStyle: textStyle,
    );
  }
  
  /// Creates an outlined button with an icon and text, with optional loading state
  static AppOutlinedButton outlinedIcon({
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
    return AppOutlinedButton.icon(
      key: key,
      onPressed: onPressed,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      text: text,
      icon: icon,
      isLoading: isLoading,
      loadingIndicator: loadingIndicator,
      loadingColor: loadingColor,
      textStyle: textStyle,
      spacing: spacing,
    );
  }
  
  /// Creates a text button with optional loading state
  static AppTextButton text({
    Key? key,
    VoidCallback? onPressed,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    required String text,
    bool isLoading = false,
    Widget? loadingIndicator,
    Color? loadingColor,
    TextStyle? textStyle,
  }) {
    return AppTextButton(
      key: key,
      onPressed: onPressed,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      text: text,
      isLoading: isLoading,
      loadingIndicator: loadingIndicator,
      loadingColor: loadingColor,
      textStyle: textStyle,
    );
  }
  
  /// Creates a text button with an icon and text, with optional loading state
  static AppTextButton textIcon({
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
    return AppTextButton.icon(
      key: key,
      onPressed: onPressed,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      text: text,
      icon: icon,
      isLoading: isLoading,
      loadingIndicator: loadingIndicator,
      loadingColor: loadingColor,
      textStyle: textStyle,
      spacing: spacing,
    );
  }
}
