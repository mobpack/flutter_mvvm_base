import 'package:flutter/material.dart';

/// Enum representing different types of form fields
enum FormFieldType {
  text,
  number,
  email,
  password,
  dropdown,
  checkbox,
  radio,
  date,
  time,
  slider,
  // Add more field types as needed
}

/// Model class representing a single form field configuration
class FormFieldModel {
  /// Unique identifier for the field
  final String id;

  /// The type of form field
  final FormFieldType type;

  /// Label to display for the field
  final String label;

  /// Optional placeholder text
  final String? placeholder;

  /// Whether the field is required
  final bool isRequired;

  /// Default value for the field
  final dynamic defaultValue;

  /// Additional validation rules as a map
  final Map<String, dynamic>? validationRules;

  /// Additional properties specific to field types (e.g., min/max for sliders)
  final Map<String, dynamic>? properties;

  /// Optional helper text to display below the field
  final String? helperText;

  /// Optional error message to override default validation messages
  final String? errorMessage;

  /// Optional icon to display with the field
  final IconData? icon;

  const FormFieldModel({
    required this.id,
    required this.type,
    required this.label,
    this.placeholder,
    this.isRequired = false,
    this.defaultValue,
    this.validationRules,
    this.properties,
    this.helperText,
    this.errorMessage,
    this.icon,
  });

  /// Factory method to create a FormFieldModel from JSON
  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    return FormFieldModel(
      id: json['id'] as String,
      type: _parseFieldType(json['type'] as String),
      label: json['label'] as String,
      placeholder: json['placeholder'] as String?,
      isRequired: json['isRequired'] as bool? ?? false,
      defaultValue: json['defaultValue'],
      validationRules: json['validationRules'] as Map<String, dynamic>?,
      properties: json['properties'] as Map<String, dynamic>?,
      helperText: json['helperText'] as String?,
      errorMessage: json['errorMessage'] as String?,
      icon:
          json['icon'] != null ? _parseIconData(json['icon'] as String) : null,
    );
  }

  /// Helper method to parse field type from string
  static FormFieldType _parseFieldType(String typeStr) {
    return FormFieldType.values.firstWhere(
      (type) => type.name == typeStr,
      orElse: () => FormFieldType.text, // Default to text if type not found
    );
  }

  /// Helper method to parse icon data from string
  /// Note: In a real implementation, you would need a more sophisticated approach
  static IconData? _parseIconData(String iconStr) {
    // Simple mapping of common icons - in a real app you'd want a more complete solution
    final iconMap = {
      'email': Icons.email_outlined,
      'lock': Icons.lock_outline,
      'person': Icons.person_outline,
      'phone': Icons.phone_outlined,
      'calendar': Icons.calendar_today_outlined,
      'time': Icons.access_time_outlined,
      'dropdown': Icons.arrow_drop_down,
      'checkbox': Icons.check_box_outline_blank,
      'radio': Icons.radio_button_unchecked,
      'slider': Icons.linear_scale,
    };

    return iconMap[iconStr];
  }

  /// Convert to JSON representation
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'label': label,
      if (placeholder != null) 'placeholder': placeholder,
      'isRequired': isRequired,
      if (defaultValue != null) 'defaultValue': defaultValue,
      if (validationRules != null) 'validationRules': validationRules,
      if (properties != null) 'properties': properties,
      if (helperText != null) 'helperText': helperText,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (icon != null) 'icon': _iconDataToString(icon!),
    };
  }

  /// Helper method to convert IconData to string
  /// Note: This is a simplified implementation
  static String _iconDataToString(IconData icon) {
    // This is a placeholder - in a real app you'd need a more sophisticated approach
    return 'icon';
  }
}
