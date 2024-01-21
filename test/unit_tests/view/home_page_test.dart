import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/application/api/common_task_name/common_task_name_list_service.dart';
import 'package:nova_chrono/application/api/task/task_list_service.dart';
import 'package:nova_chrono/domain/model/common_task_name.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/injection_container.dart';
import 'package:nova_chrono/view/pages/common_task_names_list_page.dart';
import 'package:nova_chrono/view/pages/home_page.dart';
import 'package:nova_chrono/view/pages/task_list_page.dart';
import 'package:nova_chrono/view/providers/selected_page_provider.dart';
import 'package:nova_chrono/view/providers/task_filter_date_provider.dart';
import 'package:provider/provider.dart';

import '../../mocks/annotations.mocks.dart';
import '../unit_test_injection_container.dart';

void main() {
  group("HomePage Unit Tests", () {
    const title = 'NovaChrono';
    late MockTaskListService mockTaskListService;
    late MockCommonTaskNameListService mockCommonTaskNameListService;

    setUpAll(() {
      initializeMockDependencies();

      mockTaskListService = getIt<TaskListService>() as MockTaskListService;
      mockCommonTaskNameListService = getIt<CommonTaskNameListService>() as MockCommonTaskNameListService;
    });

    testWidgets("HomePage shows TaskListPage by default", (tester) async {
      final List<Task> tasks = <Task>[];

      when(mockTaskListService.getTasksByDate(any))
          .thenAnswer((_) async => tasks);

      await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => TaskFilterDateProvider()),
              ChangeNotifierProvider(create: (context) => SelectedPageProvider()),
            ],
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: MaterialApp(
                home: HomePage(
                  title: title,
                ),
              ),
            ),
          )
      );

      await tester.pumpAndSettle();

      expect(find.byType(TaskListPage), findsOne);
    });

    testWidgets("When NavigationRailDestination with text Common Task Names"
        " is clicked it navigates to CommonTaskNamesListPage", (tester) async {
      final List<CommonTaskName> commonTaskNames = [];

      when(mockCommonTaskNameListService.getAllCommonTaskNames())
          .thenAnswer((_) async => commonTaskNames);

      await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => TaskFilterDateProvider()),
              ChangeNotifierProvider(create: (context) => SelectedPageProvider()),
            ],
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: MaterialApp(
                home: HomePage(
                  title: title,
                ),
              ),
            ),
          )
      );

      await tester.pumpAndSettle();

      var commonTaskNamesNavigationDestinationFinder = find.text('Common Task Names');
      await tester.tap(commonTaskNamesNavigationDestinationFinder);
      await tester.pumpAndSettle();

      expect(find.byType(CommonTaskNamesListPage), findsOne);
    });
  });
}