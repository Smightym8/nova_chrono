import 'package:flutter/material.dart';
import 'package:nova_chrono/application/api/task_delete_service.dart';
import 'package:nova_chrono/application/api/task_edit_service.dart';
import 'package:nova_chrono/application/api/task_list_service.dart';
import 'package:nova_chrono/view/components/search_box.dart';
import 'package:nova_chrono/view/providers/task_filter_date_provider.dart';
import 'package:provider/provider.dart';

import '../../application/api/task_create_service.dart';
import '../../domain/model/task.dart';
import '../../main.dart';
import '../components/task_list.dart';
import '../shared/date_formatter.dart';
import 'create_edit_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,
    this.taskCreateService,
    this.taskListService,
    this.taskEditService,
    this.taskDeleteService
  });

  final String title;
  final TaskCreateService? taskCreateService;
  final TaskListService? taskListService;
  final TaskEditService? taskEditService;
  final TaskDeleteService? taskDeleteService;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Task>> _tasksFuture;
  late TaskFilterDateProvider _dateProvider;
  late String _searchTerm;
  late TextEditingController _selectedDateController;
  late TaskListService _taskListService;
  late TaskDeleteService _taskDeleteService;

  @override
  void initState() {
    _searchTerm = "";
    _dateProvider = context.read<TaskFilterDateProvider>();
    _selectedDateController = TextEditingController(
        text: DateFormatter.formatDateWithoutTime(_dateProvider.selectedDate));
    _taskListService = widget.taskListService ?? getIt<TaskListService>();
    _taskDeleteService = widget.taskDeleteService ?? getIt<TaskDeleteService>();

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
    await _taskDeleteService.deleteTask(taskId);

    setState(() {
      _tasksFuture = _taskListService.getTasksByDate(_dateProvider.selectedDate);
    });
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
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
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
                      taskCreateService: widget.taskCreateService,
                      taskEditService: widget.taskEditService,
                      taskListService: _taskListService,
                      taskDeleteService: _taskDeleteService,
                    );
                  }
                }
              },
            )
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
                        taskListService: _taskListService,
                        taskDeleteService: _taskDeleteService,
                      )
              )
          );
        },
        tooltip: 'Add new task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
