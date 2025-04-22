import 'package:flutter_mvvm_base/data/user/user_repository_impl.dart';
import 'package:flutter_mvvm_base/data/supabase/supabase_data_source.dart';
import 'package:flutter_mvvm_base/domain/repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides a singleton instance of [IUserRepository] using [supabaseClientProvider].
final supabaseUserDataSource = Provider<IUserRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseUserRepositoryImpl(client: client);
});
