import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_mvvm_base/features/auth/data/providers.dart';

/// Auth state stream provider for router guards
final authStateProvider = StreamProvider<User?>(
  (ref) {
    final repo = ref.watch(authRepositoryProvider);
    return repo.onAuthStateChange.map((evt) => evt.session?.user);
  },
);
