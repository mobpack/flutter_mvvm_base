import 'package:get_it/get_it.dart';
import 'package:flutter_mvvm_base/core/theme/theme_manager.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register Supabase client
  // final supabase = Supabase.instance.client;
  // getIt.registerSingleton<SupabaseClient>(supabase);

  // Register Theme Manager
  getIt.registerSingleton<ThemeManager>(ThemeManager());

  // Add more service registrations here
}
