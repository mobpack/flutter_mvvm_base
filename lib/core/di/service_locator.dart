import 'package:flutter_mvvm_base/core/services/storage_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<StorageService>(
    StorageService(prefs),
  );

  // Add more service registrations here
}
