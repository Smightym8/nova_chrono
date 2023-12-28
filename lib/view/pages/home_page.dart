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
  late List<Task> _tasks;
  late List<Task> _filteredTasks;
  late TaskListService _taskListService;
  late TaskDeleteService _taskDeleteService;

  @override
  void initState() {
    super.initState();

    _tasks = [];
    _filteredTasks = [];
    _taskListService = widget.taskListService ?? getIt<TaskListService>();
    _taskDeleteService = widget.taskDeleteService ?? getIt<TaskDeleteService>();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    var tasks = await _taskListService.getAllTasks();

    setState(() {
      _tasks = tasks;
      _filteredTasks = tasks;
    });
  }

  void delete(String taskId) {
    setState(() {
      _taskDeleteService.deleteTask(taskId);
    });
  }

  void filterTasksByName(String searchTerm) {
    List<Task> filteredTasks = [];

    if (searchTerm.isEmpty) {
      filteredTasks = _tasks;
    } else {
      filteredTasks = _tasks
          .where((task) =>
              task.name.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredTasks = filteredTasks;
    });
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
            child: TaskList(
              tasks: _filteredTasks,
              onDeletePressedFunction: delete,
            ),
          )
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
