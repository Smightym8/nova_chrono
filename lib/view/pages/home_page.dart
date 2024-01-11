import 'package:flutter/material.dart';
import 'package:nova_chrono/application/api/common_task_name_create_service.dart';
import 'package:nova_chrono/application/api/task_delete_service.dart';
import 'package:nova_chrono/application/api/task_edit_service.dart';
import 'package:nova_chrono/application/api/task_list_service.dart';
import 'package:nova_chrono/view/components/search_box.dart';
import 'package:nova_chrono/view/pages/create_edit_common_task_name_page.dart';
import 'package:nova_chrono/view/providers/task_filter_date_provider.dart';
import 'package:provider/provider.dart';

import '../../application/api/common_task_name_edit_service.dart';
import '../../application/api/task_create_service.dart';
import '../../domain/model/task.dart';
import '../../main.dart';
import '../components/task_list.dart';
import '../shared/date_formatter.dart';
import 'create_edit_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      required this.title,
      this.taskCreateService,
      this.taskListService,
      this.taskEditService,
      this.taskDeleteService,
      this.commonTaskNameCreateService,
      this.commonTaskNameEditService});

  final String title;
  final TaskCreateService? taskCreateService;
  final TaskListService? taskListService;
  final TaskEditService? taskEditService;
  final TaskDeleteService? taskDeleteService;

  final CommonTaskNameCreateService? commonTaskNameCreateService;
  // final CommonTaskNameListService? taskListService;
  final CommonTaskNameEditService? commonTaskNameEditService;
  // final CommonTaskNameDeleteService? taskDeleteService;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _tasks;
  late List<Task> _filteredTasks;
  late TaskFilterDateProvider _dateProvider;
  late String _searchTerm;
  late TextEditingController _selectedDateController;
  late TaskListService _taskListService;
  late TaskDeleteService _taskDeleteService;

  @override
  void initState() {
    super.initState();

    _searchTerm = "";
    _dateProvider = context.read<TaskFilterDateProvider>();
    _selectedDateController = TextEditingController(
        text: DateFormatter.formatDateWithoutTime(_dateProvider.selectedDate));
    _tasks = [];
    _filteredTasks = [];
    _taskListService = widget.taskListService ?? getIt<TaskListService>();
    _taskDeleteService = widget.taskDeleteService ?? getIt<TaskDeleteService>();

    fetchTasks();
  }

  Future<void> fetchTasks() async {
    var tasks = await _taskListService.getTasksByDate(_dateProvider.selectedDate);

    setState(() {
      _tasks = tasks;
      _filteredTasks = tasks;
    });
  }

  Future<void> _selectDate() async {
    DateTime now = DateTime.now();

    await showDatePicker(
            context: context,
            initialDate: _dateProvider.selectedDate,
            firstDate: DateTime(0),
            lastDate: now
    )
    .then((selectedDate) async {
        if (selectedDate != null) {
          _dateProvider.selectedDate = selectedDate;
          _selectedDateController.text = DateFormatter.formatDateWithoutTime(selectedDate);

          await fetchTasks();
          filterTasksByName();
        }
      }
    );
  }

  void delete(String taskId) {
    setState(() {
      _taskDeleteService.deleteTask(taskId);
    });
  }

  void setSearchterm(String searchTerm) {
    _searchTerm = searchTerm;

    filterTasksByName();
  }

  void filterTasksByName() {
    List<Task> filteredTasks = [];

    if (_searchTerm.isEmpty) {
      filteredTasks = _tasks;
    } else {
      filteredTasks = _tasks
          .where((task) =>
            task.name.toLowerCase().contains(_searchTerm.toLowerCase())
          )
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SearchBox(
                  onChanged: setSearchterm,
                ),
              ),
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: TextFormField(
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
              )),
            ],
          ),
          Expanded(
            child: TaskList(
              tasks: _filteredTasks,
              onDeletePressedFunction: delete,
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            key: const Key("createEditTaskFloatingActionButton"),
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
            heroTag: "newTaskButton",
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10.0,),
          FloatingActionButton(
            key: const Key("createEditCommonTaskNameFloatingActionButton"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateEditCommonTaskNamePage(
                        commonTaskNameCreateService: widget.commonTaskNameCreateService,
                        commonTaskNameEditService: widget.commonTaskNameEditService,
                      )));
            },
            tooltip: 'Add new common task name',
            heroTag: "newCommonTaskNameButton",
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
