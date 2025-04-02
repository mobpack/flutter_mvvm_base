import 'package:flutter_mvvm_base/core/services/log_service.dart';
import 'package:flutter_mvvm_base/data/services/supabase/supabase_service.dart';
import 'package:flutter_mvvm_base/ui/common/forms/dynamic_form/form_schema_model.dart';
import 'package:safe_result/safe_result.dart';

/// Service responsible for fetching and managing form schemas from Supabase
class FormSchemaService {
  final SupabaseService _supabaseService;

  // Table name in Supabase where form schemas are stored
  static const String _tableName = 'form_schemas';

  FormSchemaService(this._supabaseService);

  /// Fetch a form schema by its ID from Supabase
  Future<Result<FormSchemaModel, Exception>> getFormSchemaById(
    String schemaId,
  ) async {
    try {
      final response = await _supabaseService.client
          .from(_tableName)
          .select()
          .eq('id', schemaId)
          .single();

      return Result.ok(FormSchemaModel.fromJson(response));
    } catch (e, stackTrace) {
      log.error(
        'Failed to fetch form schema with ID: $schemaId',
        e,
        stackTrace,
      );
      return Result.error(
        Exception('Failed to fetch form schema: ${e.toString()}'),
      );
    }
  }

  /// Fetch all form schemas from Supabase
  Future<Result<List<FormSchemaModel>, Exception>> getAllFormSchemas() async {
    try {
      final response = await _supabaseService.client.from(_tableName).select();

      final schemas = (response as List<dynamic>)
          .map((json) => FormSchemaModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Result.ok(schemas);
    } catch (e, stackTrace) {
      log.error('Failed to fetch form schemas', e, stackTrace);
      return Result.error(
        Exception('Failed to fetch form schemas: ${e.toString()}'),
      );
    }
  }

  /// Save a new form schema to Supabase
  Future<Result<FormSchemaModel, Exception>> saveFormSchema(
    FormSchemaModel schema,
  ) async {
    try {
      await _supabaseService.client.from(_tableName).insert(schema.toJson());

      return Result.ok(schema);
    } catch (e, stackTrace) {
      log.error('Failed to save form schema', e, stackTrace);
      return Result.error(
        Exception('Failed to save form schema: ${e.toString()}'),
      );
    }
  }

  /// Update an existing form schema in Supabase
  Future<Result<FormSchemaModel, Exception>> updateFormSchema(
    FormSchemaModel schema,
  ) async {
    try {
      await _supabaseService.client
          .from(_tableName)
          .update(schema.toJson())
          .eq('id', schema.id);

      return Result.ok(schema);
    } catch (e, stackTrace) {
      log.error('Failed to update form schema', e, stackTrace);
      return Result.error(
        Exception('Failed to update form schema: ${e.toString()}'),
      );
    }
  }

  /// Delete a form schema from Supabase
  Future<Result<bool, Exception>> deleteFormSchema(String schemaId) async {
    try {
      await _supabaseService.client
          .from(_tableName)
          .delete()
          .eq('id', schemaId);

      return Result.ok(true);
    } catch (e, stackTrace) {
      log.error('Failed to delete form schema', e, stackTrace);
      return Result.error(
        Exception('Failed to delete form schema: ${e.toString()}'),
      );
    }
  }
}
