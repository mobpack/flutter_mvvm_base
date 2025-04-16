import 'package:flutter_mvvm_base/features/forms/data/form_schema_repository.dart';
import 'package:flutter_mvvm_base/shared/widgets/dynamic_form/form_schema_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Use case for fetching the onboarding form schema
@injectable
class GetOnboardingFormSchemaUseCase {
  final FormSchemaRepository _repository;

  GetOnboardingFormSchemaUseCase(this._repository);

  /// Executes the use case to fetch the onboarding form schema
  Future<FormSchemaModel?> execute() async {
    try {
      return await _repository.getOnboardingFormSchema();
    } catch (e) {
      // Handle error as needed
      return null;
    }
  }
}
