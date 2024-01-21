import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/app_state.dart';
import 'package:nova_chrono/application/api/common_task_name/common_task_name_list_service.dart';
import 'package:nova_chrono/application/api/task/task_create_service.dart';
import 'package:nova_chrono/application/api/task/task_edit_service.dart';
import 'package:nova_chrono/application/api/task/task_list_service.dart';
import 'package:nova_chrono/injection_container.dart';
import 'package:nova_chrono/view/pages/create_edit_task_page.dart';
import 'package:nova_chrono/view/pages/home_page.dart';
import 'package:provider/provider.dart';

import '../../mocks/annotations.mocks.dart';
import '../unit_test_injection_container.dart';

void main() {
  group('CreateEditTaskPage Unit Tests', () {
    late MockTaskCreateService mockTaskCreateService;
    late MockTaskListService mockTaskListService;
    late MockTaskEditService mockTaskEditService;
    late MockCommonTaskNameListService mockCommonTaskNameListService;

    setUpAll(() {
      initializeMockDependencies();

      mockTaskCreateService = getIt<TaskCreateService>() as MockTaskCreateService;
      mockTaskListService = getIt<TaskListService>() as MockTaskListService;
      mockTaskEditService = getIt<TaskEditService>() as MockTaskEditService;
      mockCommonTaskNameListService = getIt<CommonTaskNameListService>() as MockCommonTaskNameListService;
    });

    testWidgets('CreateEditTaskPage has a form, two buttons and '
        'four TextFormFields', (tester) async {
      var expectedNumberOfTextFormFields = 4;
      var expectedNumberOfButtons = 2;

      when(mockCommonTaskNameListService.getAllCommonTaskNames()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            home: CreateEditTaskPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final formFinder = find.byType(Form);
      final textFormFieldFinder = find.byType(TextFormField);
      final buttonsFinder = find.byType(ElevatedButton);

      expect(formFinder, findsOneWidget);
      expect(textFormFieldFinder, findsNWidgets(expectedNumberOfTextFormFields));
      expect(buttonsFinder, findsNWidgets(expectedNumberOfButtons));
    });

    testWidgets('When the cancel button is pressed it navigates to HomePage',
        (tester) async {
      when(mockTaskListService.getTasksByDate(any))
          .thenAnswer((_) async => []);

      when(mockCommonTaskNameListService.getAllCommonTaskNames()).thenAnswer((_) async => []);

      // Start from home page as we need the route pushed on the stack
      await tester.pumpWidget(
          ChangeNotifierProvider(
            create: (context) => AppState(),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: MaterialApp(
                home: HomePage(title: "NovaChrono"),
              ),
            ),
          )
      );

      await tester.pumpAndSettle();

      var createEditTaskPageFloatingActionButtonFinder = find.byKey(const Key("createEditTaskPageFloatingActionButton"));
      await tester.tap(createEditTaskPageFloatingActionButtonFinder);

      await tester.pumpAndSettle();

      var cancelButtonFinder = find.byKey(const Key('cancelButton'));
      await tester.ensureVisible(cancelButtonFinder);
      await tester.tapAt(tester.getCenter(cancelButtonFinder));

      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('When the save button is pressed and the fields are empty '
        'it does not call TaskCreateService and '
        'validation messages are shown', (tester) async {
      when(mockCommonTaskNameListService.getAllCommonTaskNames()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            home: CreateEditTaskPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      var saveButtonFinder = find.byKey(const Key('saveButton'));
      await tester.ensureVisible(saveButtonFinder);
      await tester.tapAt(tester.getCenter(saveButtonFinder));

      await tester.pumpAndSettle();

      expect(find.text('Please enter a task name.'), findsOneWidget);
      verifyNever(mockTaskCreateService.createTask(any, any, any, any));
    });

    testWidgets("Given no task when all fields are valid createTask is called "
        "and it navigates to homepage", (tester) async {
      const taskNameExpected = "Some task";
      const detailsExpected = "Some details";

      when(mockTaskCreateService.createTask(taskNameExpected, any, any, detailsExpected)).thenAnswer((_) async => "1");
      when(mockCommonTaskNameListService.getAllCommonTaskNames()).thenAnswer((_) async => []);

      await tester.pumpWidget(
          ChangeNotifierProvider(
            create: (context) => AppState(),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: MaterialApp(
                home: CreateEditTaskPage(),
              ),
            ),
          )
      );

      await tester.pumpAndSettle();

      var taskNameTextFieldFinder = find.byKey(const Key("taskNameTextField"));
      await tester.enterText(taskNameTextFieldFinder, taskNameExpected);

      await tester.pumpAndSettle();

      var detailsTextFieldFinder = find.byKey(const Key("detailsTextField"));
      await tester.enterText(detailsTextFieldFinder, detailsExpected);

      await tester.pumpAndSettle();

      var saveButtonFinder = find.byKey(const Key('saveButton'));
      await tester.ensureVisible(saveButtonFinder);
      await tester.tapAt(tester.getCenter(saveButtonFinder));

      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      verify(mockTaskCreateService.createTask(taskNameExpected, any, any, detailsExpected));
      verifyNever(mockTaskEditService.editTask(any, any, any, any, any));
    });

    testWidgets("Given task when all fields are valid editTask is called "
        "and it navigates to homepage", (tester) async {
      when(mockCommonTaskNameListService.getAllCommonTaskNames()).thenAnswer((_) async => []);

      const taskId = "1";
      const taskName = "Some task";
      const details = "Some details";
      final startTimestamp = DateTime.now();
      final endTimestamp = DateTime(startTimestamp.year, startTimestamp.month,
          startTimestamp.day, startTimestamp.hour + 1);
      const updatedDetails = "Some new details";


      await tester.pumpWidget(
        ChangeNotifierProvider(
            create: (context) => AppState(),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: MaterialApp(
                home: CreateEditTaskPage(
                  taskId: taskId,
                  taskName: taskName,
                  startTimestamp: startTimestamp,
                  endTimestamp: endTimestamp,
                  details: details,
                ),
              ),
            ),
        )
      );

      await tester.pumpAndSettle();

      var detailsTextFieldFinder = find.byKey(const Key("detailsTextField"));
      await tester.enterText(detailsTextFieldFinder, updatedDetails);

      await tester.pumpAndSettle();

      var saveButtonFinder = find.byKey(const Key('saveButton'));
      await tester.ensureVisible(saveButtonFinder);
      await tester.tapAt(tester.getCenter(saveButtonFinder));

      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      verify(mockTaskEditService.editTask(
        taskId,
        taskName,
        startTimestamp,
        endTimestamp,
        updatedDetails
      ));
      verifyNever(mockTaskCreateService.createTask(any, any, any, any));
    });
  });
}
