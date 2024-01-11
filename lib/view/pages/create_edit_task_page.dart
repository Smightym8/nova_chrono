import 'package:flutter/material.dart';
import 'package:nova_chrono/application/api/task_create_service.dart';
import 'package:nova_chrono/application/api/task_delete_service.dart';
import 'package:nova_chrono/application/api/task_edit_service.dart';
import 'package:nova_chrono/view/pages/home_page.dart';
import 'package:provider/provider.dart';

import '../../application/api/task_list_service.dart';
import '../../domain/model/task.dart';
import '../../main.dart';
import '../components/create_edit_task_form.dart';
import '../providers/task_filter_date_provider.dart';

class CreateEditTaskPage extends StatefulWidget {
  const CreateEditTaskPage({
    super.key,
    this.taskCreateService,
    this.taskEditService,
    this.taskListService,
    this.taskDeleteService,
    this.taskId,
    this.taskName,
    this.startTimestamp,
    this.endTimestamp,
    this.details
  });

  final TaskCreateService? taskCreateService;
  final TaskEditService? taskEditService;
  final TaskListService? taskListService;  // Only for passing mock to homepage
  final TaskDeleteService? taskDeleteService; // Only for passing mock to homepage
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
  late TaskEditService _taskEditService;

  @override
  void initState() {
    super.initState();

    title = "Create Task";
    _taskCreateService = widget.taskCreateService ?? getIt<TaskCreateService>();
    _taskEditService = widget.taskEditService ?? getIt<TaskEditService>();

    if (widget.taskId != null) {
      title = "Edit Task";
    }
  }

  Future<void> save(String taskName, DateTime startTimestamp, DateTime endTimestamp,
      String? details) async {

    if (widget.taskId == null) {
      TaskFilterDateProvider dateProvider = context.read<TaskFilterDateProvider>();
      dateProvider.selectedDate = startTimestamp;

      await _taskCreateService.createTask(
          taskName, startTimestamp, endTimestamp, details);
    } else {
      await _taskEditService.editTask(
          widget.taskId!, taskName, startTimestamp, endTimestamp, details);
    }

    navigateToHomePage();
  }

  void navigateToHomePage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
              title: "NovaChrono",
              taskListService: widget.taskListService,
              taskDeleteService: widget.taskDeleteService,
            )
        )
    );
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
              onSavePressed: save,
              taskName: widget.taskName,
              startTimestamp: widget.startTimestamp,
              endTimestamp: widget.endTimestamp,
              details: widget.details,
            ),
          ),
        )
    );
  }
}
