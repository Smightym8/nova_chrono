import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nova_chrono/application/api/task_list_service.dart';
import 'package:nova_chrono/domain/model/task.dart';

import '../../main.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key, this.taskListService});

  final TaskListService? taskListService;
  static const int color = 600;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late TaskListService _taskListService;
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();

    _taskListService = widget.taskListService ?? getIt<TaskListService>();
    _tasks = _taskListService.getAllTasks();
  }

  static String _formatDate(DateTime date) {
    // TODO: Move this method to somewhere
    // so it can be used in all widgets that need it
    return DateFormat('yyyy-MM-dd - HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: _tasks.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 70,
          color: Colors.amber[TaskList.color],
          child: Center(
              child: Text('Name: ${_tasks[index].name}'
                  '\nFrom: ${_formatDate(_tasks[index].startTimestamp)}'
                  '\nTo: ${_formatDate(_tasks[index].endTimestamp)}')),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
