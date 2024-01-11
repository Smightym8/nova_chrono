import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/view/pages/create_edit_task_page.dart';
import 'package:nova_chrono/view/pages/home_page.dart';
import 'package:nova_chrono/view/providers/task_filter_date_provider.dart';
import 'package:provider/provider.dart';

import '../mocks/annotations.mocks.dart';

void main() {
  const title = 'NovaChrono';
  late MockTaskCreateService mockTaskCreateService;
  late MockTaskListService mockTaskListService;
  late MockTaskEditService mockTaskEditService;
  late MockTaskDeleteService mockTaskDeleteService;

  setUp(() {
    mockTaskCreateService = MockTaskCreateService();
    mockTaskListService = MockTaskListService();
    mockTaskEditService = MockTaskEditService();
    mockTaskDeleteService = MockTaskDeleteService();
  });

  testWidgets('HomePage has a title and two floatingActionButtons',
      (tester) async {
    final List<Task> tasks = <Task>[];
    final Future<List<Task>> tasksFuture = Future(() => tasks);

    when(mockTaskListService.getTasksByDate(any))
        .thenAnswer((_) => tasksFuture);

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
            ),
          ),
        ),
      )
    );

    final titleFinder = find.text(title);
    final createEditTaskFloatingActionButtonFinder = find.byKey(const Key("createEditTaskFloatingActionButton"));
    final createEditCommonTaskNameFloatingActionButtonFinder = find.byKey(const Key("createEditCommonTaskNameFloatingActionButton"));

    await tester.pumpAndSettle();

    expect(titleFinder, findsOneWidget);
    expect(createEditTaskFloatingActionButtonFinder, findsOneWidget);
    expect(createEditCommonTaskNameFloatingActionButtonFinder, findsOneWidget);
  });

  testWidgets(
      'When the FloatingActionButton is pressed it navigates to'
      'CreateTaskPage', (WidgetTester tester) async {
    final List<Task> tasks = <Task>[];
    final Future<List<Task>> tasksFuture = Future(() => tasks);

    when(mockTaskListService.getTasksByDate(any))
        .thenAnswer((_) => tasksFuture);

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
              ),
            ),
          ),
        )
    );

    final createEditTaskFloatingActionButtonFinder = find.byKey(const Key("createEditTaskFloatingActionButton"));

    await tester.tap(createEditTaskFloatingActionButtonFinder);

    // Trigger a frame
    await tester.pumpAndSettle();

    // Verify that the navigation occurred by checking the presence of a widget on the next page
    expect(find.byType(CreateEditTaskPage), findsOneWidget);
  });
}
