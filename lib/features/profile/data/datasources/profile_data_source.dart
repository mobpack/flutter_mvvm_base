import 'dart:io';
import 'package:flutter_mvvm_base/shared/data/supabase/supabase_provider.dart';
import 'package:flutter_mvvm_base/shared/domain/entities/user/user_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

part 'profile_data_source.g.dart';

/// Data source for profile operations using Supabase
class ProfileDataSource {
  final supabase.SupabaseClient _client;

  /// Creates a new [ProfileDataSource] with the given Supabase client
  ProfileDataSource(this._client);

  /// Retrieves a user's profile data from Supabase
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final response =
        await _client.from('users').select().eq('id', userId).single();

    return response;
  }

  /// Updates a user's profile data in Supabase
  Future<Map<String, dynamic>> updateUserProfile(UserEntity user) async {
    final response = await _client
        .from('users')
        .update({
          'email': user.email,
          'name': user.name,
          'role': user.role,
          'avatar': user.avatar,
          'language': user.language,
          'onboarding_completed': user.onboardingCompleted,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', user.id)
        .select()
        .single();

    return response;
  }

  /// Updates a user's avatar in storage and updates the user record
  Future<String> updateUserAvatar(String userId, String avatarPath) async {
    // Upload file to storage
    final fileName = 'avatar_$userId.jpg';
    final file = File(avatarPath);
    final fileBytes = await file.readAsBytes();

    await _client.storage.from('avatars').uploadBinary(fileName, fileBytes);

    // Get public URL
    final avatarUrl = _client.storage.from('avatars').getPublicUrl(fileName);

    // Update user record
    await _client.from('users').update({
      'avatar': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);

    return avatarUrl;
  }

  /// Updates a user's language preference
  Future<String> updateUserLanguage(String userId, String language) async {
    final response = await _client
        .from('users')
        .update({
          'language': language,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId)
        .select('language')
        .single();

    return response['language'] as String;
  }
}

/// Provider for [ProfileDataSource]
@riverpod
ProfileDataSource profileDataSource(ProfileDataSourceRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ProfileDataSource(supabase);
}
