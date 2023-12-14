import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nova_chrono/application/api/task_create_service.dart';
import 'package:nova_chrono/application/impl/task_create_service_impl.dart';
import 'package:nova_chrono/view/pages/home_page.dart';

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<TaskCreateService>(TaskCreateServiceImpl());

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