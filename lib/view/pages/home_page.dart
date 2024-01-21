import 'package:flutter/material.dart';
import 'package:nova_chrono/app_state.dart';
import 'package:nova_chrono/view/pages/common_task_names_list_page.dart';
import 'package:nova_chrono/view/pages/task_list_page.dart';
import 'package:provider/provider.dart';

import 'error_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    int selectedPageIndex = Provider.of<AppState>(context).selectedPageIndex;

    Widget page;
    switch (selectedPageIndex) {
      case 0:
        page = TaskListPage(title: title);
        break;
      case 1:
        page = CommonTaskNamesListPage(title: title);
        break;
      default:
      // Don't show back button in this case as home would have an invalid
      // value for selectedPage index and the user can see the navigation bar
        var errorMessage = 'No widget for selected page index: $selectedPageIndex';
        page = ErrorPage(errorMessage: errorMessage, showBackToHomeButton: false);
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
                    selectedIndex: selectedPageIndex,
                    onDestinationSelected: (value) {
                      Provider.of<AppState>(context, listen: false).selectedPageIndex = value;
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
