import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mvvm_base/features/forms/domain/usecases/get_onboarding_form_schema_use_case.dart';
import 'package:flutter_mvvm_base/shared/widgets/dynamic_form/form_schema_model.dart';

/// State for the onboarding form
@immutable
class OnboardingFormState {
  final FormSchemaModel? formSchema;
  final bool isLoading;
  final String? error;

  const OnboardingFormState({
    this.formSchema,
    this.isLoading = false,
    this.error,
  });

  OnboardingFormState copyWith({
    FormSchemaModel? formSchema,
    bool? isLoading,
    String? error,
  }) {
    return OnboardingFormState(
      formSchema: formSchema ?? this.formSchema,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// ViewModel for managing the onboarding form state
class OnboardingFormViewModel extends StateNotifier<OnboardingFormState> {
  final GetOnboardingFormSchemaUseCase _getOnboardingFormSchemaUseCase;

  OnboardingFormViewModel(this._getOnboardingFormSchemaUseCase)
      : super(const OnboardingFormState(isLoading: false));

  /// Fetches the onboarding form schema
  Future<void> fetchOnboardingForm() async {
    state = state.copyWith(isLoading: true);
    try {
      final formSchema = await _getOnboardingFormSchemaUseCase.execute();
      state = state.copyWith(
        formSchema: formSchema,
        isLoading: false,
        error: formSchema == null ? 'Failed to load form' : null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'An error occurred while loading the form',
      );
    }
  }
}

/// Provider for the OnboardingFormViewModel
final onboardingFormViewModelProvider = StateNotifierProvider<
    OnboardingFormViewModel, OnboardingFormState>((ref) {
  final useCase = ref.watch(getOnboardingFormSchemaUseCaseProvider);
  return OnboardingFormViewModel(useCase);
});
