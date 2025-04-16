import 'package:flutter_mvvm_base/services/supabase/auth/auth_interface.dart';
import 'package:flutter_mvvm_base/services/supabase/auth/auth_service.dart';
import 'package:flutter_mvvm_base/services/supabase/supabase_service.dart';
import 'package:get_it/get_it.dart';

class AuthProvider {
  static void register() {
    final getIt = GetIt.instance;

    if (!getIt.isRegistered<AuthService>()) {
      getIt.registerLazySingleton<AuthService>(
        () => SupabaseAuthService(
          client: getIt<SupabaseService>().client,
        ),
      );
    }
  }

  static AuthService getService() {
    return GetIt.instance<AuthService>();
  }
}
