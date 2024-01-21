import 'package:flutter/material.dart';
import 'package:nova_chrono/app_state.dart';
import 'package:provider/provider.dart';

import '../../application/api/exception/task_not_found_exception.dart';
import '../../application/api/task/task_delete_service.dart';
import '../../application/api/task/task_list_service.dart';
import '../../domain/model/task.dart';
import '../../injection_container.dart';
import '../components/search_box.dart';
import '../components/task_list.dart';
import '../shared/date_formatter.dart';
import 'create_edit_task_page.dart';
import 'error_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key, required this.title});

  final String title;

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late Future<List<Task>> _tasksFuture;
  late AppState _dateProvider;
  late String _searchTerm;
  late TextEditingController _selectedDateController;
  late TaskListService _taskListService;
  late TaskDeleteService _taskDeleteService;

  @override
  void initState() {
    _searchTerm = "";
    _dateProvider = context.read<AppState>();
    _selectedDateController = TextEditingController(
        text: DateFormatter.formatDateWithoutTime(_dateProvider.selectedDate));
    _taskListService = getIt<TaskListService>();
    _taskDeleteService = getIt<TaskDeleteService>();

    _tasksFuture = _taskListService.getTasksByDate(_dateProvider.selectedDate);

    super.initState();
  }

  @override
  void dispose() {
    _selectedDateController.dispose();

    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime now = DateTime.now();

    await showDatePicker(
        context: context,
        initialDate: _dateProvider.selectedDate,
        firstDate: DateTime(0),
        lastDate: now
    )
        .then((selectedDate) {
      if (selectedDate != null) {
        _dateProvider.selectedDate = selectedDate;

        setState(() {
          _selectedDateController.text = DateFormatter.formatDateWithoutTime(selectedDate);
          _tasksFuture = _taskListService.getTasksByDate(_dateProvider.selectedDate);
        });
      }
    }
    );
  }

  Future<void> delete(String taskId) async {
    try {
      await _taskDeleteService.deleteTask(taskId);
    } on TaskNotFoundException catch (e) {
      navigateToErrorPage(e.cause);
    }

    setState(() {
      _tasksFuture = _taskListService.getTasksByDate(_dateProvider.selectedDate);
    });
  }

  void navigateToErrorPage(String errorMessage) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ErrorPage(errorMessage: errorMessage)
        )
    );
  }

  void setSearchTerm(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SearchBox(
                  onChanged: setSearchTerm,
                ),
              ),
              Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: TextFormField(
                      key: const Key("dateFilterTextFormField"),
                      controller: _selectedDateController,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        filled: true,
                        prefixIcon: Icon(Icons.calendar_today),
                        enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                      readOnly: true,
                      onTap: () {
                        _selectDate();
                      },
                    ),
                  )
              ),
            ],
          ),
          Expanded(
              child: FutureBuilder(
                future: _tasksFuture,
                builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Text(
                        "Loading tasks...",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black,),
                      ),
                    );
                  } else {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "No tasks found",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          "An error occurred",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      );
                    } else {
                      var filteredTasks = snapshot.data!;

                      if (_searchTerm.isNotEmpty) {
                        filteredTasks = filteredTasks.where((task) =>
                            task.name.toLowerCase().contains(_searchTerm.toLowerCase())
                        ).toList();
                      }

                      return TaskList(
                        tasks: filteredTasks,
                        onDeletePressedFunction: delete,
                      );
                    }
                  }
                },
              )
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        key: const Key("createEditTaskPageFloatingActionButton"),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateEditTaskPage()
              )
          );
        },
        tooltip: 'Add new task',
        heroTag: "newTaskButton",
        child: const Icon(Icons.add),
      ),
    );
  }
}