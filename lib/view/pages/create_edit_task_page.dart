import 'package:flutter/material.dart';
import 'package:nova_chrono/application/api/task_create_service.dart';
import 'package:nova_chrono/view/pages/home_page.dart';

import '../../domain/model/task.dart';
import '../../main.dart';
import '../components/create_edit_task_form.dart';

class CreateEditTaskPage extends StatefulWidget {
  const CreateEditTaskPage(
      {super.key,
      this.taskCreateService,
      this.taskId,
      this.taskName,
      this.startTimestamp,
      this.endTimestamp,
      this.details});

  final TaskCreateService? taskCreateService;
  final String? taskId;
  final String? taskName;
  final DateTime? startTimestamp;
  final DateTime? endTimestamp;
  final String? details;

  @override
  State<CreateEditTaskPage> createState() => _CreateEditTaskPageState();
}

class _CreateEditTaskPageState extends State<CreateEditTaskPage> {
  late String title;
  late Future<Task?> task;

  late TaskCreateService _taskCreateService;

  @override
  void initState() {
    super.initState();

    title = "Create Task";
    _taskCreateService = widget.taskCreateService ?? getIt<TaskCreateService>();

    if (widget.taskId != null) {
      title = "Edit Task";
    }
  }

  void save(String taskName, DateTime startTimestamp, DateTime endTimestamp,
      String? details) {
    if (widget.taskId == null) {
      _taskCreateService.createTask(
          taskName, startTimestamp, endTimestamp, details);
    } else {
      // TODO: taskEditService.editTask();
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const HomePage(title: "NovaChrono")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: CreateEditTaskForm(
              onPressedFunction: save,
              taskName: widget.taskName,
              startTimestamp: widget.startTimestamp,
              endTimestamp: widget.endTimestamp,
              details: widget.details,
            ),
          ),
        ));
  }
}
