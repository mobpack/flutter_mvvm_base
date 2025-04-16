import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/shared/widgets/base_scaffold.dart';
import 'package:flutter_mvvm_base/shared/widgets/dynamic_form/dynamic_form_builder.dart';
import 'package:flutter_mvvm_base/shared/widgets/dynamic_form/form_field_model.dart';
import 'package:flutter_mvvm_base/shared/widgets/dynamic_form/form_schema_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Example provider for form schema
final formSchemaProvider =
    FutureProvider.autoDispose<FormSchemaModel>((ref) async {
  // In a real app, you would fetch this from Supabase using the service with GetIt
  // final formSchemaService = GetIt.instance<FormSchemaService>();
  // final result = await formSchemaService.getFormSchemaById('example-form');
  // if (result.isSuccess) {
  //   return result.value;
  // } else {
  //   throw result.error;
  // }

  // For this example, we'll use a hardcoded schema
  return _getExampleFormSchema();
});

/// Example screen that demonstrates the dynamic form builder
class ExampleFormScreen extends ConsumerWidget {
  const ExampleFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formSchemaAsync = ref.watch(formSchemaProvider);

    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Dynamic Form Example'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: formSchemaAsync.when(
            data: (schema) {
              return SingleChildScrollView(
                child: DynamicFormBuilder(
                  schema: schema,
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
                      child: Icon(
                        Icons.description_outlined,
                        size: 48,
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text(
                'Error loading form: ${error.toString()}',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
        validationRules: {
          'minLength': 2,
          'maxLength': 50,
        },
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
        validationRules: {
          'pattern': r'^\+?[0-9]{10,15}$',
        },
        errorMessage: 'Please enter a valid phone number',
      ),
      FormFieldModel(
        id: 'password',
        type: FormFieldType.password,
        label: 'Password',
        placeholder: 'Enter your password',
        isRequired: true,
        validationRules: {
          'minLength': 8,
        },
        helperText: 'Password must be at least 8 characters long',
      ),
    ],
    submitEndpoint: '/api/submit-form',
  );
}
