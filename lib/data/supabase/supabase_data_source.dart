import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provides a singleton instance of [SupabaseClient] initialized from .env.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  final url = dotenv.env['SUPABASE_URL'];
  final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
  if (url == null || anonKey == null) {
    throw Exception(
      'Supabase URL and anonymous key must be provided in .env file',
    );
  }
  return SupabaseClient(url, anonKey);
});

/// Service wrapper for SupabaseClient, providing higher-level methods and lifecycle.
class SupabaseService {
  final SupabaseClient client;

  /// Creates a [SupabaseService] with the given [SupabaseClient].
  SupabaseService({required this.client});

  /// Example method: check connection (customize as needed).
  Future<bool> isConnected() async {
    try {
      // Example: fetch current user (adjust to your needs)
      final user = client.auth.currentUser;
      return user != null;
    } catch (_) {
      return false;
    }
  }
}

/// Provides a singleton instance of [SupabaseService] using [supabaseClientProvider].
final supabaseDataSource = Provider<SupabaseService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseService(client: client);
});
