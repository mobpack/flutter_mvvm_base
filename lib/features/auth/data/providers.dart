import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mvvm_base/shared/data/supabase/supabase_provider.dart';
import 'package:flutter_mvvm_base/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_mvvm_base/features/auth/domain/repository/auth_repository.dart';

/// Provides a singleton IAuthRepository instance for Auth feature.
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthRepositoryImpl(client: client);
});
