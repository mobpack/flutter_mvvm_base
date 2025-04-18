import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mvvm_base/app.dart';
import 'package:flutter_mvvm_base/di/service_locator.dart';
import 'package:flutter_mvvm_base/service/logging/log_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  logger.init();
  logger.info('Starting app...');

  // Load environment variables
  await dotenv.load();
  logger.debug('Environment variables loaded');

  // Setup service locator
  await setupServiceLocator();
  logger.debug('Service locator initialized');

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
