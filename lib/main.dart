import 'package:flutter/material.dart';
import 'package:nova_chrono/app_state.dart';
import 'package:nova_chrono/infrastructure/database_provider/database_provider.dart';
import 'package:nova_chrono/view/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'injection_container.dart';


int key = 0x42;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WindowManager.instance.setMinimumSize(const Size(1200, 600));
  await initializeDependencies();
  await getIt<DatabaseProvider>().initDatabase();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  final String title = 'NovaChrono';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
          title: title,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: HomePage(title: title)
      )
    );
  }
}