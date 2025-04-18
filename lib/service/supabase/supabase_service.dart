import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mvvm_base/service/logging/log_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  late final SupabaseClient _client;
  bool _initialized = false;

  SupabaseService();

  Future<void> init() async {
    if (_initialized) return;

    final url = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (url == null || anonKey == null) {
      throw Exception(
        'Supabase URL and anonymous key must be provided in .env file',
      );
    }

    try {
      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
      );
      _client = Supabase.instance.client;
      _initialized = true;
      logger.info('Supabase initialized successfully');
    } catch (e, stackTrace) {
      logger.error('Failed to initialize Supabase', e, stackTrace);
      rethrow;
    }
  }

  SupabaseClient get client {
    _ensureInitialized();
    return _client;
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('SupabaseService must be initialized before use');
    }
  }

  Future<void> dispose() async {
    if (_initialized) {
      await Supabase.instance.dispose();
      _initialized = false;
      logger.info('Supabase disposed successfully');
    }
  }
}
