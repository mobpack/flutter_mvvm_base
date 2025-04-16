import 'package:get_it/get_it.dart';

abstract class DIModule {
  final GetIt getIt;

  const DIModule(this.getIt);
  
  void register();
}
