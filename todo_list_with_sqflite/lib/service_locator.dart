import 'package:get_it/get_it.dart';
import 'package:todo_list_with_sqflite/database_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<DatabaseService>(DatabaseService());
}
