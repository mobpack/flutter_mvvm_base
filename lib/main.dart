import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mvvm_base/app.dart';
import 'package:flutter_mvvm_base/features/auth/data/providers.dart' as auth_providers;
import 'package:flutter_mvvm_base/features/auth/usecases/login_use_case.dart';
import 'package:flutter_mvvm_base/shared/logging/log_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  logger.init();
  logger.info('Starting app...');

  // Load environment variables
  await dotenv.load();
  logger.debug('Environment variables loaded');

  runApp(
    ProviderScope(
      overrides: [
        // Override the generated authRepository provider with the actual implementation
        authRepositoryProvider.overrideWith((ref) => ref.read(auth_providers.authRepositoryProvider)),
      ],
      child: const App(),
    ),
  );
}
