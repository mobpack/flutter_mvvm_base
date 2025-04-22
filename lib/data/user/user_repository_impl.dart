import 'package:flutter_mvvm_base/domain/repository/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implementation of [IUserRepository] using Supabase.
///
/// Use [supabaseUserDataSource] (see supabase_user_data_source.dart) to inject this service via Riverpod.
class SupabaseUserRepositoryImpl implements IUserRepository {
  final SupabaseClient _client;

  /// Creates a [SupabaseUserRepositoryImpl] with the given [SupabaseClient].
  SupabaseUserRepositoryImpl({required SupabaseClient client})
      : _client = client;

  /// Fetches user data from the Supabase 'users' table by user ID.
  /// Returns a map of user data or null if not found.
  @override
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final response =
          await _client.from('users').select().eq('id', userId).single();

      return response;
    } catch (e) {
      // Return null if the user doesn't exist or there's an error
      return null;
    }
  }

  /// Updates user data in the Supabase 'users' table.
  /// Returns the updated user data as a map.
  @override
  Future<Map<String, dynamic>> updateUserData(
    String userId,
    Map<String, dynamic> data,
  ) async {
    // Add updated_at timestamp
    final dataWithTimestamp = {
      ...data,
      'updated_at': DateTime.now().toIso8601String(),
    };

    final response = await _client
        .from('users')
        .update(dataWithTimestamp)
        .eq('id', userId)
        .select()
        .single();

    return response;
  }

  /// Creates a new user record in the Supabase 'users' table.
  /// Returns the created user data as a map.
  @override
  Future<Map<String, dynamic>> createUserData(
    String userId,
    Map<String, dynamic> data,
  ) async {
    // Add timestamps
    final now = DateTime.now().toIso8601String();
    final dataWithTimestamps = {
      ...data,
      'id': userId,
      'created_at': now,
      'updated_at': now,
    };

    final response = await _client
        .from('users')
        .insert(dataWithTimestamps)
        .select()
        .single();

    return response;
  }
}
