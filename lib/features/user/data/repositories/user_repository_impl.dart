import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_mvvm_base/features/user/domain/user_repository.dart';

/// Implementation of [IUserRepository] using Supabase
class SupabaseUserRepositoryImpl implements IUserRepository {
  final SupabaseClient _client;

  SupabaseUserRepositoryImpl({required SupabaseClient client})
      : _client = client;

  @override
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final response =
          await _client.from('users').select().eq('id', userId).single();
      return response;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> updateUserData(
    String userId,
    Map<String, dynamic> data,
  ) async {
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
