import 'package:flutter_mvvm_base/shared/presentation/widgets/forms/form_schema_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository for fetching form schemas from Supabase
class FormSchemaRepository {
  final SupabaseClient supabase;

  FormSchemaRepository(this.supabase);

  /// Fetches the onboarding form schema with tag 'onboarding' and status 'published'
  Future<FormSchemaModel?> getOnboardingFormSchema() async {
    final response = await supabase
        .from('form_schemas')
        .select()
        .eq('tag', 'onboarding')
        .eq('status', 'published')
        .single();
    return FormSchemaModel.fromJson(response);
  }
}
