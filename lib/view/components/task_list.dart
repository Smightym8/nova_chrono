import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nova_chrono/domain/model/task.dart';

import '../pages/create_edit_task_page.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key, required this.tasks});

  final List<Task> tasks;
  static const int color = 600;

  static String _formatDate(DateTime date) {
    // TODO: Move this method to somewhere
    // so it can be used in all widgets that need it
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        var taskId = tasks[index].id;
        var taskName = tasks[index].name;
        var startTimestamp = tasks[index].startTimestamp;
        var endTimestamp = tasks[index].endTimestamp;
        var startTimestampStr = _formatDate(tasks[index].startTimestamp);
        var endTimestampStr = _formatDate(tasks[index].endTimestamp);
        var details = tasks[index].details;

        return Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.yellow.shade300,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 12, spreadRadius: 1),
            ],
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(10),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    taskName,
                    style: const TextStyle(fontSize: 19),
                  ),
                ),
                subtitle: Text(
                  details,
                  style: const TextStyle(fontSize: 17),
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 0.8,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$startTimestampStr - $endTimestampStr",
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateEditTaskPage(
                                      taskId: taskId,
                                      taskName: taskName,
                                      startTimestamp: startTimestamp,
                                      endTimestamp: endTimestamp,
                                      details: details,
                                    )));
                      },
                      child: const Icon(
                        Icons.edit,
                        size: 28,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}