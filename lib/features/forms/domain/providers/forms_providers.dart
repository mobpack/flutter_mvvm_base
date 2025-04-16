import 'package:flutter_mvvm_base/features/forms/data/form_schema_repository.dart';
import 'package:flutter_mvvm_base/features/forms/domain/usecases/get_onboarding_form_schema_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the form schema repository
final formSchemaRepositoryProvider = Provider<FormSchemaRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return FormSchemaRepository(supabase);
});

/// Provider for the get onboarding form schema use case
final getOnboardingFormSchemaUseCaseProvider =
    Provider<GetOnboardingFormSchemaUseCase>((ref) {
  final repository = ref.watch(formSchemaRepositoryProvider);
  return GetOnboardingFormSchemaUseCase(repository);
});
