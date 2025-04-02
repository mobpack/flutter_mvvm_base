import 'package:flutter/material.dart';
import 'package:flutter_mvvm_base/ui/common/forms/dynamic_form/dynamic_form_field.dart';
import 'package:flutter_mvvm_base/ui/common/forms/dynamic_form/form_field_model.dart';
import 'package:flutter_mvvm_base/ui/common/forms/dynamic_form/form_schema_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A dynamic form builder widget that creates a form based on a JSON schema
class DynamicFormBuilder extends StatefulWidget {
  /// The form schema configuration
  final FormSchemaModel schema;

  /// Callback when form is submitted
  final Function(Map<String, dynamic>)? onSubmit;

  /// Optional callback when any field value changes
  final Function(String, dynamic)? onFieldValueChanged;

  /// Optional initial values for form fields
  final Map<String, dynamic>? initialValues;

  /// Whether to show a submit button
  final bool showSubmitButton;

  /// Text to display on the submit button
  final String submitButtonText;

  /// Optional custom builder for the submit button
  final Widget Function(BuildContext, VoidCallback)? submitButtonBuilder;

  /// Optional builder for form header
  final Widget Function(BuildContext, FormSchemaModel)? headerBuilder;

  /// Optional builder for form footer
  final Widget Function(BuildContext, FormSchemaModel)? footerBuilder;

  const DynamicFormBuilder({
    required this.schema,
    this.onSubmit,
    this.onFieldValueChanged,
    this.initialValues,
    this.showSubmitButton = true,
    this.submitButtonText = 'Submit',
    this.submitButtonBuilder,
    this.headerBuilder,
    this.footerBuilder,
    super.key,
  });

  @override
  State<DynamicFormBuilder> createState() => _DynamicFormBuilderState();
}

class _DynamicFormBuilderState extends State<DynamicFormBuilder> {
  /// The reactive form group that will hold all form controls
  late final FormGroup _form;

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  /// Initialize the form with controls based on the schema
  void _initForm() {
    final controls = <String, AbstractControl<dynamic>>{};

    // Create a form control for each field in the schema
    for (final field in widget.schema.fields) {
      // Create validation rules based on field configuration
      final validations = <Validator<dynamic>>[];

      // Add required validation if field is required
      if (field.isRequired) {
        validations.add(Validators.required);
      }

      // Add additional validations based on field type and validation rules
      if (field.type == FormFieldType.email) {
        validations.add(Validators.email);
      } else if (field.type == FormFieldType.number) {
        validations.add(Validators.number());
      }

      // Add min length validation if specified
      if (field.validationRules != null &&
          field.validationRules!.containsKey('minLength')) {
        final minLength = field.validationRules!['minLength'] as int;
        validations.add(Validators.minLength(minLength));
      }

      // Add max length validation if specified
      if (field.validationRules != null &&
          field.validationRules!.containsKey('maxLength')) {
        final maxLength = field.validationRules!['maxLength'] as int;
        validations.add(Validators.maxLength(maxLength));
      }

      // Add pattern validation if specified
      if (field.validationRules != null &&
          field.validationRules!.containsKey('pattern')) {
        final pattern = field.validationRules!['pattern'] as String;
        validations.add(Validators.pattern(pattern));
      }

      // Get initial value for this field (if provided)
      final initialValue = widget.initialValues != null &&
              widget.initialValues!.containsKey(field.id)
          ? widget.initialValues![field.id]
          : field.defaultValue;

      // Create and add the form control with appropriate type
      if (field.type == FormFieldType.number) {
        controls[field.id] = FormControl<num>(
          value: initialValue as num?,
          validators: validations,
        );
      } else {
        // For text, email, password, and other string-based fields
        controls[field.id] = FormControl<String>(
          value: initialValue as String?,
          validators: validations,
        );
      }
    }

    // Create the form group with all controls
    _form = FormGroup(controls);
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Optional header
          if (widget.headerBuilder != null)
            widget.headerBuilder!(context, widget.schema),

          // Form title
          if (widget.schema.title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                widget.schema.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

          // Form description
          if (widget.schema.description != null &&
              widget.schema.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                widget.schema.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

          // Form fields
          ...widget.schema.fields.map((field) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: DynamicFormField(
                field: field,
                onValueChanged: widget.onFieldValueChanged,
              ),
            );
          }),

          // Submit button
          if (widget.showSubmitButton)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: widget.submitButtonBuilder != null
                  ? widget.submitButtonBuilder!(context, _handleSubmit)
                  : FilledButton(
                      onPressed: _handleSubmit,
                      child: Text(widget.submitButtonText),
                    ),
            ),

          // Optional footer
          if (widget.footerBuilder != null)
            widget.footerBuilder!(context, widget.schema),
        ],
      ),
    );
  }

  /// Handle form submission
  void _handleSubmit() {
    if (_form.valid) {
      if (widget.onSubmit != null) {
        widget.onSubmit!(_form.value);
      }
    } else {
      // Mark all fields as touched to show validation errors
      _form
        ..markAllAsTouched()
        ..markAsDirty();
    }
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }
}
