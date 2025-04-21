import 'package:flutter_mvvm_base/service/supabase/supabase_service.dart';
import 'package:flutter_mvvm_base/service/supabase/user/user_service_impl.dart';
import 'package:flutter_mvvm_base/service/supabase/user/user_service_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides a singleton instance of [IUserService] using [supabaseClientProvider].
final userServiceProvider = Provider<IUserService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseUserService(client: client);
});
