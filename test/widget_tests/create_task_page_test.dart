import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/view/pages/create_task_page.dart';
import 'package:nova_chrono/view/pages/home_page.dart';

import '../mocks/annotations.mocks.dart';

void main() {
  group('CreateTaskPage Tests', () {
    const title = 'NovaChrono';
    late MockTaskCreateService mockTaskCreateService;
    late MockTaskListService mockTaskListService;

    setUp(() {
      mockTaskCreateService = MockTaskCreateService();
      mockTaskListService = MockTaskListService();
    });

    testWidgets(
        'CreateTaskPage has a title, a form, two buttons and '
        'four TextFormFields', (tester) async {
      var expectedNumberOfTextFormFields = 4;
      var expectedNumberOfButtons = 2;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            home: CreateTaskPage(
                title: title, taskCreateService: mockTaskCreateService),
          ),
        ),
      );

      final titleFinder = find.text(title);
      final formFinder = find.byType(Form);
      final textFormFieldFinder = find.byType(TextFormField);
      final buttonsFinder = find.byType(ElevatedButton);

      expect(titleFinder, findsOneWidget);
      expect(formFinder, findsOneWidget);
      expect(
          textFormFieldFinder, findsNWidgets(expectedNumberOfTextFormFields));
      expect(buttonsFinder, findsNWidgets(expectedNumberOfButtons));
    });

    testWidgets('When the cancel button is pressed it navigates to HomePage',
        (tester) async {
      // Use a GlobalKey to get access to the NavigatorState
      final GlobalKey<NavigatorState> navigatorKey =
          GlobalKey<NavigatorState>();

      final List<Task> tasks = <Task>[];
      final Future<List<Task>> tasksFuture = Future(() => tasks);

      when(mockTaskListService.getAllTasks()).thenAnswer((_) => tasksFuture);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            navigatorKey: navigatorKey,
            home: CreateTaskPage(
                title: title, taskCreateService: mockTaskCreateService),
          ),
        ),
      );

      // Manually push HomePage onto the navigation stack
      navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => HomePage(
                title: title,
                taskListService: mockTaskListService,
              )));

      // Tap on the button
      var cancelButtonFinder = find.byKey(const Key('cancelButton'));
      await tester.ensureVisible(cancelButtonFinder);
      await tester.tapAt(tester.getCenter(cancelButtonFinder));

      // Trigger a frame
      await tester.pumpAndSettle();

      // Verify that the navigation occurred by checking the presence of a widget on the next page
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets(
        'When the save button is pressed and the fields are empty '
        'it does not call TaskCreateService and '
        'validation messages are shown', (tester) async {
      final List<Task> tasks = <Task>[];
      final Future<List<Task>> tasksFuture = Future(() => tasks);

      when(mockTaskListService.getAllTasks()).thenAnswer((_) => tasksFuture);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            home: CreateTaskPage(
              title: title,
              taskCreateService: mockTaskCreateService,
            ),
          ),
        ),
      );

      var saveButtonFinder = find.byKey(const Key('saveButton'));
      await tester.ensureVisible(saveButtonFinder);
      await tester.tapAt(tester.getCenter(saveButtonFinder));

      await tester.pumpAndSettle();

      expect(find.text('Please enter some text.'), findsOneWidget);
      expect(find.text('Please select a end date.'), findsOneWidget);
      verifyNever(mockTaskCreateService.createTask(any, any, any, any));
    });
  });
}
