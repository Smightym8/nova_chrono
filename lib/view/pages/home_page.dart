import 'package:flutter/material.dart';
import 'package:nova_chrono/view/pages/common_task_names_list_page.dart';
import 'package:nova_chrono/view/pages/task_list_page.dart';
import 'package:provider/provider.dart';

import '../../application/api/common_task_name/common_task_name_delete_service.dart';
import '../../application/api/common_task_name/common_task_name_list_service.dart';
import '../../application/api/task/task_create_service.dart';
import '../../application/api/task/task_delete_service.dart';
import '../../application/api/task/task_edit_service.dart';
import '../../application/api/task/task_list_service.dart';
import '../providers/selected_page_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,
    this.taskListService,
    this.taskDeleteService,
    this.taskCreateService,
    this.taskEditService,
    this.commonTaskNameListService,
    this.commonTaskNameDeleteService,
  });

  final String title;
  final TaskListService? taskListService;
  final TaskDeleteService? taskDeleteService;
  final TaskCreateService? taskCreateService;
  final TaskEditService? taskEditService;
  final CommonTaskNameListService? commonTaskNameListService;
  final CommonTaskNameDeleteService? commonTaskNameDeleteService;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedPageIndex;
  late SelectedPageProvider _selectedPageProvider;

  @override
  void initState() {
    _selectedPageIndex = 0;
    _selectedPageProvider = context.read<SelectedPageProvider>();
    _selectedPageIndex = _selectedPageProvider.selectedPageIndex;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedPageIndex) {
      case 0:
        page = TaskListPage(
          title: widget.title,
          taskListService: widget.taskListService,
          taskDeleteService: widget.taskDeleteService,
          taskCreateService: widget.taskCreateService,
          taskEditService: widget.taskEditService,
        );
        break;
      case 1:
        page = CommonTaskNamesListPage(
          title: widget.title,
          commonTaskNameListService: widget.commonTaskNameListService,
          commonTaskNameDeleteService: widget.commonTaskNameDeleteService,
        );
      default:
        throw UnimplementedError('no widget for $_selectedPageIndex');
    }

    return LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                    extended: constraints.maxWidth >= 600,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.task),
                        label: Text('Tasks'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Common Task Names'),
                      ),
                    ],
                    selectedIndex: _selectedPageIndex,
                    onDestinationSelected: (value) {
                      _selectedPageProvider.selectedPageIndex = value;

                      setState(() {
                        _selectedPageIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
