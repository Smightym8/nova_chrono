import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/view/pages/create_edit_task_page.dart';
import 'package:nova_chrono/view/pages/home_page.dart';

import '../mocks/annotations.mocks.dart';

void main() {
  group('CreateEditTaskPage Tests', () {
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

    testWidgets(
        'CreateEditTaskPage has a form, two buttons and '
        'four TextFormFields', (tester) async {
      var expectedNumberOfTextFormFields = 4;
      var expectedNumberOfButtons = 2;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            home: CreateEditTaskPage(
              taskCreateService: mockTaskCreateService,
              taskEditService: mockTaskEditService,
            ),
          ),
        ),
      );

      final formFinder = find.byType(Form);
      final textFormFieldFinder = find.byType(TextFormField);
      final buttonsFinder = find.byType(ElevatedButton);

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

      when(mockTaskListService.getTasksByDate(any))
          .thenAnswer((_) => tasksFuture);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            navigatorKey: navigatorKey,
            home: CreateEditTaskPage(
              taskCreateService: mockTaskCreateService,
              taskEditService: mockTaskEditService,
            ),
          ),
        ),
      );

      // Manually push HomePage onto the navigation stack
      navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => HomePage(
                title: "NovaChrono",
                taskListService: mockTaskListService,
                taskDeleteService: mockTaskDeleteService,
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

      when(mockTaskListService.getTasksByDate(DateTime.now()))
          .thenAnswer((_) => tasksFuture);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            home: CreateEditTaskPage(
              taskCreateService: mockTaskCreateService,
              taskEditService: mockTaskEditService,
            ),
          ),
        ),
      );

      var saveButtonFinder = find.byKey(const Key('saveButton'));
      await tester.ensureVisible(saveButtonFinder);
      await tester.tapAt(tester.getCenter(saveButtonFinder));

      await tester.pumpAndSettle();

      expect(find.text('Please enter some text.'), findsOneWidget);
      verifyNever(mockTaskCreateService.createTask(any, any, any, any));
    });
  });
}
