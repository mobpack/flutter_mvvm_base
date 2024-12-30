import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mvvm_base/app.dart';
import 'package:flutter_mvvm_base/core/di/service_locator.dart';
import 'package:flutter_mvvm_base/core/services/log_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  log.init();
  log.info('Starting app...');

  // Load environment variables
  await dotenv.load();
  log.debug('Environment variables loaded');

  // Setup service locator
  await setupServiceLocator();
  log.debug('Service locator initialized');

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
