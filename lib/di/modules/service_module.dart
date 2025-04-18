import 'package:flutter_mvvm_base/di/module.dart';
import 'package:flutter_mvvm_base/service/storage/storage_service.dart';
import 'package:flutter_mvvm_base/service/supabase/auth/auth_interface.dart';
import 'package:flutter_mvvm_base/service/supabase/auth/auth_service.dart';
import 'package:flutter_mvvm_base/service/supabase/supabase_service.dart';
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
