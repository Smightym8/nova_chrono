import 'package:flutter/material.dart';
import 'package:nova_chrono/application/api/task_list_service.dart';

import '../../application/api/task_create_service.dart';
import '../components/task_list.dart';
import 'create_task_page.dart';

class HomePage extends StatelessWidget {
  const HomePage(
      {super.key,
      required this.title,
      this.taskCreateService,
      this.taskListService});

  final String title;
  final TaskCreateService? taskCreateService;
  final TaskListService? taskListService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: TaskList(
        taskListService: taskListService,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTaskPage(
                      title: title, taskCreateService: taskCreateService)),
          );
        },
        tooltip: 'Add new task',
        child: const Icon(Icons.add),
      ),
    );
  }
}