import 'package:flutter_mvvm_base/shared/presentation/widgets/forms/form_field_model.dart';

/// Represents a section within a dynamic form
class FormSectionModel {
  final String id;
  final String title;
  final String? description;
  final List<FormFieldModel> fields;

  const FormSectionModel({
    required this.id,
    required this.title,
    required this.fields,
    this.description,
  });

  factory FormSectionModel.fromJson(Map<String, dynamic> json) {
    return FormSectionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      fields: (json['fields'] as List<dynamic>)
          .map(
            (fieldJson) =>
                FormFieldModel.fromJson(fieldJson as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (description != null) 'description': description,
      'fields': fields.map((field) => field.toJson()).toList(),
    };
  }
}
