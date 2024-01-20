import 'package:flutter/material.dart';
import 'package:nova_chrono/application/api/task/task_create_service.dart';
import 'package:nova_chrono/application/api/task/task_delete_service.dart';
import 'package:nova_chrono/application/api/task/task_edit_service.dart';
import 'package:nova_chrono/application/api/task/task_list_service.dart';
import 'package:nova_chrono/infrastructure/database_provider/database_provider.dart';
import 'package:nova_chrono/view/pages/home_page.dart';
import 'package:nova_chrono/view/providers/selected_page_provider.dart';
import 'package:nova_chrono/view/providers/task_filter_date_provider.dart';
import 'package:provider/provider.dart';

import 'injection_container.dart';


int key = 0x42;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await getIt<DatabaseProvider>().initDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskFilterDateProvider()),
        ChangeNotifierProvider(create: (context) => SelectedPageProvider()),
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