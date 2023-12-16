import 'package:flutter/material.dart';
import 'package:nova_chrono/application/api/task_create_service.dart';

import '../../main.dart';
import '../components/create_task_form.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage(
      {super.key, required this.title, this.taskCreateService});

  final String title;
  final TaskCreateService? taskCreateService;

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  late TaskCreateService _taskCreateService;

  @override
  void initState() {
    super.initState();

    _taskCreateService = widget.taskCreateService ?? getIt<TaskCreateService>();
  }

  void save(String taskName, DateTime startTimestamp, DateTime endTimestamp, String? details) {
    _taskCreateService.createTask(
        taskName, startTimestamp, endTimestamp, details);
    Navigator.pop(context);
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