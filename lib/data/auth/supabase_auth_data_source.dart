import 'package:flutter_mvvm_base/data/auth/auth_repository_impl.dart';
import 'package:flutter_mvvm_base/data/supabase/supabase_data_source.dart';
import 'package:flutter_mvvm_base/domain/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides a singleton instance of [IAuthRepository] using [supabaseClientProvider].
final supabaseAuthDataSource = Provider<IAuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthRepositoryImpl(client: client);
});
