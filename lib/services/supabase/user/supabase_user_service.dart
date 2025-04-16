import 'package:flutter_mvvm_base/services/supabase/user/user_service_interface.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implementation of UserService using Supabase
class SupabaseUserService implements UserService {
  final SupabaseClient _client;

  /// Constructor that takes a Supabase client
  SupabaseUserService({required SupabaseClient client}) : _client = client;

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
