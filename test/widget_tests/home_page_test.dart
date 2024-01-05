import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/view/components/search_box.dart';
import 'package:nova_chrono/view/components/task_list.dart';
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

  setUpAll(() {
    mockTaskCreateService = MockTaskCreateService();
    mockTaskListService = MockTaskListService();
    mockTaskEditService = MockTaskEditService();
    mockTaskDeleteService = MockTaskDeleteService();
  });

  testWidgets('HomePage has a title, a searchbox, a textformfield, a tasklist '
      'and a floatingActionButton',
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
    final searchBoxFinder = find.byType(SearchBox);
    final textFormFieldFinder = find.byType(TextFormField);
    final listViewFinder = find.byType(TaskList);
    final floatingActionButtonFinder = find.byType(FloatingActionButton);

    await tester.pumpAndSettle();

    expect(titleFinder, findsOneWidget);
    expect(searchBoxFinder, findsOneWidget);
    expect(textFormFieldFinder, findsOneWidget);
    expect(listViewFinder, findsOneWidget);
    expect(floatingActionButtonFinder, findsOneWidget);
  });

  testWidgets(
      'When the FloatingActionButton is pressed it navigates to'
      'CreateEditTaskPage', (WidgetTester tester) async {
    final List<Task> tasks = <Task>[];
    final Future<List<Task>> tasksFuture = Future(() => tasks);

    when(mockTaskListService.getTasksByDate(any))
        .thenAnswer((_) => tasksFuture);

    await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => TaskFilterDateProvider()),
          ],
          child: Directionality(
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

    // Tap on the floating action button
    await tester.tap(find.byType(FloatingActionButton));

    // Trigger a frame
    await tester.pumpAndSettle();

    // Verify that the navigation occurred by checking the presence of a widget on the next page
    expect(find.byType(CreateEditTaskPage), findsOneWidget);
  });

  testWidgets("Given search term when the search term is entered "
      "only one task with expected title is in the list", (tester) async {
    final List<Task> tasks = <Task>[
      Task("1", "Task 1", DateTime.now(), DateTime.now(), ""),
      Task("2", "Task 2", DateTime.now(), DateTime.now(), ""),
      Task("3", "Task 3", DateTime.now(), DateTime.now(), ""),
    ];
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

    await tester.pumpAndSettle();

    final textFieldFinder = find.byKey(const Key("searchBoxTextField"));
    await tester.enterText(textFieldFinder, "Task 2");

    await tester.pumpAndSettle();

    final listItemFinder = find.byType(ListTile);

    // TODO: Check if title of list item is also the expected one
    expect(listItemFinder, findsOne);
  });

  testWidgets("When the edit icon is clicked it navigates"
      " to CreateEditTaskPage", (tester) async {
    final List<Task> tasks = <Task>[
      Task("1", "Task 1", DateTime.now(), DateTime.now(), ""),
    ];
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

    await tester.pumpAndSettle();

    final editInkWellFinder = find.widgetWithIcon(
        InkWell,
        Icons.edit
    ).first;

    await tester.tap(editInkWellFinder);

    await tester.pumpAndSettle();

    expect(find.byType(CreateEditTaskPage), findsOne);
  });

  testWidgets("When the delete icon is the list is empty", (tester) async {
    final List<Task> tasks = <Task>[
      Task("1", "Task 1", DateTime.now(), DateTime.now(), ""),
    ];
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

    await tester.pumpAndSettle();

    final deleteInkWellFinder = find.widgetWithIcon(
        InkWell,
        Icons.delete_forever
    ).first;

    await tester.tap(deleteInkWellFinder);

    await tester.pumpAndSettle();

    expect(find.text("No tasks found"), findsOne);
  });

  testWidgets("When a date is selected getTasksByDate is called with "
      "the expected date and the contents of the list changes", (tester) async {
    final now = DateTime.now();
    final dateToSelect = DateTime(now.year, now.month, now.day - 1);

    final List<Task> initialTasks = <Task>[
      Task("1", "Task 1", now, now, ""),
    ];
    final Future<List<Task>> initialTasksFuture = Future(() => initialTasks);

    final List<Task> tasksAfterDateSelected = <Task>[];
    final Future<List<Task>> tasksAfterDateSelectedFuture = Future(() => tasksAfterDateSelected);

    when(mockTaskListService.getTasksByDate(now))
        .thenAnswer((_) => initialTasksFuture);

    when(mockTaskListService.getTasksByDate(dateToSelect))
        .thenAnswer((_) => tasksAfterDateSelectedFuture);

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

    await tester.pumpAndSettle();

    final datePickerFinder = find.byKey(const Key("dateFilterTextFormField"));
    await tester.tap(datePickerFinder);

    await tester.pumpAndSettle();

    await tester.tap(find.text(dateToSelect.day.toString()));
    await tester.tap(find.text("OK"));

    await tester.pumpAndSettle();

    verify(mockTaskListService.getTasksByDate(dateToSelect));
    expect(find.text("No tasks found"), findsOne);
  });
}
