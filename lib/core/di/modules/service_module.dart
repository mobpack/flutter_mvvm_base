import 'package:flutter_mvvm_base/core/di/module.dart';
import 'package:flutter_mvvm_base/core/services/storage_service.dart';
import 'package:flutter_mvvm_base/data/services/supabase/auth/auth_interface.dart';
import 'package:flutter_mvvm_base/data/services/supabase/auth/auth_service.dart';
import 'package:flutter_mvvm_base/data/services/supabase/supabase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceModule extends DIModule {
  final SharedPreferences prefs;

  const ServiceModule(super.getIt, this.prefs);

  @override
  void register() {
    _registerCoreServices();
    _registerSupabaseServices();
  }

  void _registerCoreServices() {
    getIt.registerSingleton<StorageService>(
      StorageService(prefs),
    );
  }

  void _registerSupabaseServices() {
    // Register Supabase as async singleton
    getIt.registerSingletonAsync<SupabaseService>(() async {
      final service = SupabaseService();
      await service.init();
      return service;
    });

    // Register SupabaseClient as a factory that gets the client from SupabaseService
    getIt.registerFactory<SupabaseClient>(
      () => getIt<SupabaseService>().client,
    );

    // Register AuthService as lazy singleton
    getIt.registerLazySingleton<AuthService>(
      () => SupabaseAuthService(
        client: getIt<SupabaseService>().client,
      ),
    );
  }
}
