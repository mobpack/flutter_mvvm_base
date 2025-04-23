import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mvvm_base/shared/data/supabase/supabase_provider.dart';
import 'package:flutter_mvvm_base/features/user/data/repositories/user_repository_impl.dart';
import 'package:flutter_mvvm_base/domain/repository/user_repository.dart';

/// Provides a singleton instance of IUserRepository for User feature.
final userRepositoryProvider = Provider<IUserRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseUserRepositoryImpl(client: client);
});
