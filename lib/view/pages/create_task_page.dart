import 'package:flutter/material.dart';
import 'package:nova_chrono/application/api/task_create_service.dart';

import '../../main.dart';
import '../components/create_task_form.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key, required this.title});

  final String title;

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final TaskCreateService taskCreateService = getIt<TaskCreateService>();

  void save(String taskName, String startTimestamp, String endTimestamp, String? details) {
    taskCreateService.createTask(taskName, startTimestamp, endTimestamp, details);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: CreateTaskForm(onPressedFunction: save),
      )
    );
  }
}