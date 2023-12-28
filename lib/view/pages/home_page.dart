import 'package:flutter/material.dart';
import 'package:nova_chrono/application/api/task_delete_service.dart';
import 'package:nova_chrono/application/api/task_edit_service.dart';
import 'package:nova_chrono/application/api/task_list_service.dart';
import 'package:nova_chrono/view/components/search_box.dart';

import '../../application/api/task_create_service.dart';
import '../../domain/model/task.dart';
import '../../main.dart';
import '../components/task_list.dart';
import 'create_edit_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      required this.title,
      this.taskCreateService,
      this.taskListService,
      this.taskEditService,
      this.taskDeleteService});

  final String title;
  final TaskCreateService? taskCreateService;
  final TaskListService? taskListService;
  final TaskEditService? taskEditService;
  final TaskDeleteService? taskDeleteService;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Task>> _tasks;
  late TaskListService _taskListService;
  late TaskDeleteService _taskDeleteService;

  @override
  void initState() {
    super.initState();

    _taskListService = widget.taskListService ?? getIt<TaskListService>();
    _taskDeleteService = widget.taskDeleteService ?? getIt<TaskDeleteService>();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    _tasks = _taskListService.getAllTasks();
  }

  void delete(String taskId) {
    setState(() {
      _taskDeleteService.deleteTask(taskId);
    });
  }

  void filterTasksByName(String searchTerm) {
    if (searchTerm.isEmpty) {
      print("Nothing searched");
    } else {
      print("Searched for $searchTerm");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SearchBox(
            onChanged: filterTasksByName,
          ),
          Expanded(
              child: FutureBuilder(
            future: _tasks,
            builder: (context, AsyncSnapshot<List<Task>> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.isEmpty) {
                return const Center(
                    child: Text(
                  "No tasks found",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ));
              } else {
                return TaskList(
                  tasks: snapshot.data!,
                  onDeletePressedFunction: delete,
                );
              }
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateEditTaskPage(
                        taskCreateService: widget.taskCreateService,
                        taskEditService: widget.taskEditService,
                      )));
        },
        tooltip: 'Add new task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
