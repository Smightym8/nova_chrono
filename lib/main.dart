import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nova_chrono/application/api/task/task_create_service.dart';
import 'package:nova_chrono/application/api/task/task_delete_service.dart';
import 'package:nova_chrono/application/api/task/task_edit_service.dart';
import 'package:nova_chrono/application/api/task/task_list_service.dart';
import 'package:nova_chrono/application/impl/common_task_name/common_task_name_create_service_impl.dart';
import 'package:nova_chrono/application/impl/task/task_create_service_impl.dart';
import 'package:nova_chrono/application/impl/task/task_delete_service_impl.dart';
import 'package:nova_chrono/application/impl/task/task_edit_service_impl.dart';
import 'package:nova_chrono/application/impl/task/task_list_service_impl.dart';
import 'package:nova_chrono/domain/repository/common_task_name_repository.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/infrastructure/common_task_name_repository_impl.dart';
import 'package:nova_chrono/infrastructure/database_provider.dart';
import 'package:nova_chrono/infrastructure/task_repository_impl.dart';
import 'package:nova_chrono/view/pages/home_page.dart';
import 'package:nova_chrono/view/providers/task_filter_date_provider.dart';
import 'package:provider/provider.dart';

import 'application/api/common_task_name/common_task_name_create_service.dart';
import 'application/api/common_task_name/common_task_name_delete_service.dart';
import 'application/api/common_task_name/common_task_name_edit_service.dart';
import 'application/api/common_task_name/common_task_name_list_service.dart';
import 'application/impl/common_task_name/common_task_name_delete_service_impl.dart';
import 'application/impl/common_task_name/common_task_name_edit_service_impl.dart';
import 'application/impl/common_task_name/common_task_name_list_service_impl.dart';

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;
DatabaseProvider databaseProvider = DatabaseProvider.instance;

void main() async {
  await databaseProvider.initDatabase();

  getIt.registerSingleton<TaskRepository>(TaskRepositoryImpl());
  getIt.registerSingleton<TaskCreateService>(TaskCreateServiceImpl());
  getIt.registerSingleton<TaskListService>(TaskListServiceImpl());
  getIt.registerSingleton<TaskEditService>(TaskEditServiceImpl());
  getIt.registerSingleton<TaskDeleteService>(TaskDeleteServiceImpl());
  getIt.registerSingleton<CommonTaskNameRepository>(CommonTaskNameRepositoryImpl());
  getIt.registerSingleton<CommonTaskNameCreateService>(CommonTaskNameCreateServiceImpl());
  getIt.registerSingleton<CommonTaskNameEditService>(CommonTaskNameEditServiceImpl());
  getIt.registerSingleton<CommonTaskNameListService>(CommonTaskNameListServiceImpl());
  getIt.registerSingleton<CommonTaskNameDeleteService>(CommonTaskNameDeleteServiceImpl());

  await databaseProvider.initDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskFilterDateProvider()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({
    super.key,
    this.taskCreateService,
    this.taskListService,
    this.taskEditService,
    this.taskDeleteService
  });

  final String title = 'NovaChrono';
  final TaskCreateService? taskCreateService;
  final TaskListService? taskListService;
  final TaskEditService? taskEditService;
  final TaskDeleteService? taskDeleteService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(
        title: title,
        taskCreateService: taskCreateService,
        taskListService: taskListService,
        taskEditService: taskEditService,
        taskDeleteService: taskDeleteService,
      ),
    );
  }
}