import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nova_chrono/domain/model/task.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key, required this.tasks});

  final List<Task> tasks;
  static const int color = 600;

  static String _formatDate(DateTime date) {
    // TODO: Move this method to somewhere
    // so it can be used in all widgets that need it
    return DateFormat('yyyy-MM-dd - HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 70,
          color: Colors.amber[TaskList.color],
          child: Center(
              child: Text('Name: ${tasks[index].name}'
                  '\nFrom: ${_formatDate(tasks[index].startTimestamp)}'
                  '\nTo: ${_formatDate(tasks[index].endTimestamp)}')),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}