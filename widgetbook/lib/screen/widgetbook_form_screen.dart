import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/ui/common/forms/dynamic_form/dynamic_form_builder.dart';
import 'package:flutter_mvvm_base/ui/common/forms/dynamic_form/example_form_screen.dart';
import 'package:flutter_mvvm_base/ui/common/forms/dynamic_form/form_field_model.dart';
import 'package:flutter_mvvm_base/ui/common/forms/dynamic_form/form_schema_model.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:logger/logger.dart';

/// Helper method to get an example form schema
FormSchemaModel _getExampleFormSchema() {
  // This is an example schema that would typically come from Supabase
  return FormSchemaModel(
    id: 'example-form',
    title: 'Contact Information',
    description: 'Please fill out your contact information below.',
    fields: [
      FormFieldModel(
        id: 'name',
        type: FormFieldType.text,
        label: 'Full Name',
        placeholder: 'Enter your full name',
        isRequired: true,
        icon: Icons.person_outline,
        validationRules: {'minLength': 2, 'maxLength': 50},
      ),
      FormFieldModel(
        id: 'email',
        type: FormFieldType.email,
        label: 'Email Address',
        placeholder: 'Enter your email address',
        isRequired: true,
        icon: Icons.email_outlined,
        helperText: 'We\'ll never share your email with anyone else.',
      ),
      FormFieldModel(
        id: 'phone',
        type: FormFieldType.text,
        label: 'Phone Number',
        placeholder: 'Enter your phone number',
        isRequired: false,
        icon: Icons.phone_outlined,
        validationRules: {'pattern': r'^\+?[0-9]{10,15}$'},
        errorMessage: 'Please enter a valid phone number',
      ),
      FormFieldModel(
        id: 'password',
        type: FormFieldType.password,
        label: 'Password',
        placeholder: 'Enter your password',
        isRequired: true,
        validationRules: {'minLength': 8},
        helperText: 'Password must be at least 8 characters long',
      ),
    ],
    submitEndpoint: '/api/submit-form',
  );
}

@widgetbook.UseCase(name: 'Default', type: ExampleFormScreen)
Widget buildWidgetbookFormUseCase(BuildContext context) {
  return SingleChildScrollView(
    child: DynamicFormBuilder(
      schema: _getExampleFormSchema(),
      onSubmit: (formData) {
        // Handle form submission
        Logger().d('Form submitted with data: $formData');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Form submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      },
      onFieldValueChanged: (fieldId, value) {
        // Handle field value changes if needed
        Logger().d('Field $fieldId changed to: $value');
      },
      headerBuilder: (context, schema) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 24.0),
          child: Icon(Icons.description_outlined, size: 48),
        );
      },
    ),
  );
}
