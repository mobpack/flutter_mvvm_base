import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/shared/widgets/dynamic_form/form_field_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Widget that renders a form field based on its type and configuration
class DynamicFormField extends StatelessWidget {
  /// The form field configuration
  final FormFieldModel field;

  /// Optional callback when field value changes
  final Function(String, dynamic)? onValueChanged;

  const DynamicFormField({
    required this.field,
    this.onValueChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Render appropriate field widget based on field type
    return _buildFieldByType(context);
  }

  /// Builds the appropriate form field widget based on field type
  Widget _buildFieldByType(BuildContext context) {
    switch (field.type) {
      case FormFieldType.text:
      case FormFieldType.email:
        return _buildTextField(context);
      case FormFieldType.password:
        return _buildPasswordField(context);
      case FormFieldType.number:
        return _buildNumberField(context);
      // Add cases for other field types as needed
      default:
        return _buildTextField(context); // Default to text field
    }
  }

  /// Builds a standard text field
  Widget _buildTextField(BuildContext context) {
    return ReactiveTextField<String>(
      formControlName: field.id,
      decoration: InputDecoration(
        labelText: field.label,
        hintText: field.placeholder,
        helperText: field.helperText,
        prefixIcon: field.icon != null ? Icon(field.icon, size: 24) : null,
      ),
      keyboardType: field.type == FormFieldType.email
          ? TextInputType.emailAddress
          : TextInputType.text,
      validationMessages: {
        ValidationMessage.required: (_) => '${field.label} is required',
        ValidationMessage.email: (_) => 'Please enter a valid email address',
        ValidationMessage.minLength: (control) {
          final minLength = field.validationRules?['minLength'] as int?;
          return '${field.label} must be at least $minLength characters';
        },
        ValidationMessage.maxLength: (control) {
          final maxLength = field.validationRules?['maxLength'] as int?;
          return '${field.label} must be at most $maxLength characters';
        },
        ValidationMessage.pattern: (_) =>
            field.errorMessage ?? 'Invalid format',
      },
      onChanged: (control) {
        if (onValueChanged != null) {
          onValueChanged!(field.id, control.value);
        }
      },
    );
  }

  /// Builds a password field with toggle for visibility
  Widget _buildPasswordField(BuildContext context) {
    return ReactiveTextField<String>(
      formControlName: field.id,
      obscureText: true, // Password is hidden by default
      decoration: InputDecoration(
        labelText: field.label,
        hintText: field.placeholder,
        helperText: field.helperText,
        prefixIcon: field.icon != null
            ? Icon(field.icon, size: 24)
            : Icon(Icons.lock_outline, size: 24),
        // Could add suffix icon for password visibility toggle in a stateful implementation
      ),
      validationMessages: {
        ValidationMessage.required: (_) => '${field.label} is required',
        ValidationMessage.minLength: (control) {
          final minLength = field.validationRules?['minLength'] as int?;
          return '${field.label} must be at least $minLength characters';
        },
      },
      onChanged: (control) {
        if (onValueChanged != null) {
          onValueChanged!(field.id, control.value);
        }
      },
    );
  }

  /// Builds a number input field
  Widget _buildNumberField(BuildContext context) {
    return ReactiveTextField<num>(
      formControlName: field.id,
      decoration: InputDecoration(
        labelText: field.label,
        hintText: field.placeholder,
        helperText: field.helperText,
        prefixIcon: field.icon != null ? Icon(field.icon, size: 24) : null,
      ),
      keyboardType: TextInputType.number,
      validationMessages: {
        ValidationMessage.required: (_) => '${field.label} is required',
        ValidationMessage.number: (_) => 'Please enter a valid number',
      },
      onChanged: (control) {
        if (onValueChanged != null) {
          onValueChanged!(field.id, control.value);
        }
      },
    );
  }

  // Additional methods for other field types can be added here
  // For example: _buildDropdownField, _buildCheckboxField, _buildRadioField, etc.
}
