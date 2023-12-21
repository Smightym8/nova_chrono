import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nova_chrono/domain/model/task.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  static List<Task> tasks = <Task>[
    Task('1', 'Task 1', DateTime.now(), DateTime.now(), ''),
    Task('2', 'Task 2', DateTime.now(), DateTime.now(), ''),
    Task('3', 'Task 3', DateTime.now(), DateTime.now(), '')
  ];
  static const int color = 600;

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  static String _formatDate(DateTime date) {
    // TODO: Move this method to somewhere
    // so it can be used in all widgets that need it
    return DateFormat('yyyy-MM-dd - HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: TaskList.tasks.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 70,
          color: Colors.amber[TaskList.color],
          child: Center(
              child: Text('Name: ${TaskList.tasks[index].name}'
                  '\nFrom: ${_formatDate(TaskList.tasks[index].startTimestamp)}'
                  '\nTo: ${_formatDate(TaskList.tasks[index].endTimestamp)}')),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
