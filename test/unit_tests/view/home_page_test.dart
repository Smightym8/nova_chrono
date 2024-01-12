import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/domain/model/common_task_name.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/view/pages/common_task_names_list_page.dart';
import 'package:nova_chrono/view/pages/home_page.dart';
import 'package:nova_chrono/view/pages/task_list_page.dart';
import 'package:nova_chrono/view/providers/selected_page_provider.dart';
import 'package:nova_chrono/view/providers/task_filter_date_provider.dart';
import 'package:provider/provider.dart';

import '../../mocks/annotations.mocks.dart';

void main() {
  group("HomePage Unit Tests", () {
    const title = 'NovaChrono';
    late MockTaskCreateService mockTaskCreateService;
    late MockTaskListService mockTaskListService;
    late MockTaskEditService mockTaskEditService;
    late MockTaskDeleteService mockTaskDeleteService;
    late MockCommonTaskNameListService mockCommonTaskNameListService;
    late MockCommonTaskNameDeleteService mockCommonTaskNameDeleteService;

    setUpAll(() {
      mockTaskCreateService = MockTaskCreateService();
      mockTaskListService = MockTaskListService();
      mockTaskEditService = MockTaskEditService();
      mockTaskDeleteService = MockTaskDeleteService();
      mockCommonTaskNameListService = MockCommonTaskNameListService();
      mockCommonTaskNameDeleteService = MockCommonTaskNameDeleteService();
    });

    testWidgets("HomePage shows TaskListPage by default", (tester) async {
      final List<Task> tasks = <Task>[];
      final Future<List<Task>> tasksFuture = Future(() => tasks);

      when(mockTaskListService.getTasksByDate(any))
          .thenAnswer((_) => tasksFuture);

      await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => TaskFilterDateProvider()),
              ChangeNotifierProvider(create: (context) => SelectedPageProvider()),
            ],
            child:  Directionality(
              textDirection: TextDirection.ltr,
              child: MaterialApp(
                home: HomePage(
                  title: title,
                  taskCreateService: mockTaskCreateService,
                  taskListService: mockTaskListService,
                  taskEditService: mockTaskEditService,
                  taskDeleteService: mockTaskDeleteService,
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
      final Future<List<CommonTaskName>> commonTaskNamesFuture = Future(() => commonTaskNames);

      when(mockCommonTaskNameListService.getAllCommonTaskNames())
          .thenAnswer((_) => commonTaskNamesFuture);

      await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => TaskFilterDateProvider()),
            ],
            child:  Directionality(
              textDirection: TextDirection.ltr,
              child: MaterialApp(
                home: HomePage(
                  title: title,
                  taskCreateService: mockTaskCreateService,
                  taskListService: mockTaskListService,
                  taskEditService: mockTaskEditService,
                  taskDeleteService: mockTaskDeleteService,
                  commonTaskNameListService: mockCommonTaskNameListService,
                  commonTaskNameDeleteService: mockCommonTaskNameDeleteService,
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