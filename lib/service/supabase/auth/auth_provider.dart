import 'package:flutter_mvvm_base/service/supabase/auth/auth_service_impl.dart';
import 'package:flutter_mvvm_base/service/supabase/auth/auth_service_interface.dart';
import 'package:flutter_mvvm_base/service/supabase/supabase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides a singleton instance of [IAuthService] using [supabaseServiceProvider].
final authServiceProvider = Provider<IAuthService>((ref) {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return SupabaseAuthServiceImpl(client: supabaseService.client);
});
