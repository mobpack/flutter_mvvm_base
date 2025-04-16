import 'package:flutter_mvvm_base/shared/widgets/dynamic_form/form_section_model.dart';

/// Model class representing the entire form schema
class FormSchemaModel {
  /// Unique identifier for the form
  final String id;

  /// Title of the form
  final String title;

  /// Optional description of the form
  final String? description;

  /// List of form sections (each with its own fields)
  final List<FormSectionModel> sections;

  /// Optional submission endpoint
  final String? submitEndpoint;

  /// Additional form-level properties
  final Map<String, dynamic>? properties;

  const FormSchemaModel({
    required this.id,
    required this.title,
    required this.sections,
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
      sections: (json['sections'] as List<dynamic>)
          .map(
            (sectionJson) =>
                FormSectionModel.fromJson(sectionJson as Map<String, dynamic>),
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
      'sections': sections.map((section) => section.toJson()).toList(),
      if (submitEndpoint != null) 'submitEndpoint': submitEndpoint,
      if (properties != null) 'properties': properties,
    };
  }
}
