import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nova_chrono/application/api/task_create_service.dart';
import 'package:nova_chrono/application/api/task_list_service.dart';
import 'package:nova_chrono/application/impl/task_create_service_impl.dart';
import 'package:nova_chrono/application/impl/task_list_service_impl.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/infrastructure/database_provider.dart';
import 'package:nova_chrono/infrastructure/task_repository_impl.dart';
import 'package:nova_chrono/view/pages/home_page.dart';

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;
DatabaseProvider databaseProvider = DatabaseProvider.instance;

void main() async {
  getIt.registerSingleton<TaskRepository>(TaskRepositoryImpl());
  getIt.registerSingleton<TaskCreateService>(TaskCreateServiceImpl());
  getIt.registerSingleton<TaskListService>(TaskListServiceImpl());
  await databaseProvider.initDatabase();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  final String title = 'NovaChrono';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: "NovaChrono"),
    );
  }
}