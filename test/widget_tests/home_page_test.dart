import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/view/pages/create_edit_task_page.dart';
import 'package:nova_chrono/view/pages/home_page.dart';

import '../mocks/annotations.mocks.dart';

void main() {
  const title = 'NovaChrono';
  late MockTaskCreateService mockTaskCreateService;
  late MockTaskListService mockTaskListService;

  setUp(() {
    mockTaskCreateService = MockTaskCreateService();
    mockTaskListService = MockTaskListService();
  });

  testWidgets('HomePage has a title and a floatingActionButton',
      (tester) async {
    final List<Task> tasks = <Task>[];
    final Future<List<Task>> tasksFuture = Future(() => tasks);

    when(mockTaskListService.getAllTasks()).thenAnswer((_) => tasksFuture);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MaterialApp(
          home: HomePage(
            title: title,
            taskCreateService: mockTaskCreateService,
            taskListService: mockTaskListService,
          ),
        ),
      ),
    );

    final titleFinder = find.text(title);
    final floatingActionButtonFinder = find.byType(FloatingActionButton);

    await tester.pumpAndSettle();

    expect(titleFinder, findsOneWidget);
    expect(floatingActionButtonFinder, findsOneWidget);
  });

  testWidgets(
      'When the FloatingActionButton is pressed it navigates to '
      'CreateTaskPage', (WidgetTester tester) async {
    final List<Task> tasks = <Task>[];
    final Future<List<Task>> tasksFuture = Future(() => tasks);

    when(mockTaskListService.getAllTasks()).thenAnswer((_) => tasksFuture);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MaterialApp(
          home: HomePage(
            title: title,
            taskCreateService: mockTaskCreateService,
            taskListService: mockTaskListService,
          ),
        ),
      ),
    );

    // Tap on the floating action button
    await tester.tap(find.byType(FloatingActionButton));

    // Trigger a frame
    await tester.pumpAndSettle();

    // Verify that the navigation occurred by checking the presence of a widget on the next page
    expect(find.byType(CreateEditTaskPage), findsOneWidget);
  });
}
