import 'package:flutter_mvvm_base/ui/common/forms/dynamic_form/form_field_model.dart';

/// Model class representing the entire form schema
class FormSchemaModel {
  /// Unique identifier for the form
  final String id;

  /// Title of the form
  final String title;

  /// Optional description of the form
  final String? description;

  /// List of form fields
  final List<FormFieldModel> fields;

  /// Optional submission endpoint
  final String? submitEndpoint;

  /// Additional form-level properties
  final Map<String, dynamic>? properties;

  const FormSchemaModel({
    required this.id,
    required this.title,
    required this.fields,
    this.description,
    this.submitEndpoint,
    this.properties,
  });

  /// Factory method to create a FormSchemaModel from JSON
  factory FormSchemaModel.fromJson(Map<String, dynamic> json) {
    return FormSchemaModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      fields: (json['fields'] as List<dynamic>)
          .map(
            (fieldJson) =>
                FormFieldModel.fromJson(fieldJson as Map<String, dynamic>),
          )
          .toList(),
      submitEndpoint: json['submitEndpoint'] as String?,
      properties: json['properties'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON representation
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (description != null) 'description': description,
      'fields': fields.map((field) => field.toJson()).toList(),
      if (submitEndpoint != null) 'submitEndpoint': submitEndpoint,
      if (properties != null) 'properties': properties,
    };
  }
}
