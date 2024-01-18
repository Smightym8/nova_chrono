import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/view/pages/create_edit_task_page.dart';
import 'package:nova_chrono/view/pages/home_page.dart';
import 'package:nova_chrono/view/providers/selected_page_provider.dart';
import 'package:nova_chrono/view/providers/task_filter_date_provider.dart';
import 'package:provider/provider.dart';

import '../../mocks/annotations.mocks.dart';

void main() {
  group('CreateEditTaskPage Unit Tests', () {
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

    testWidgets('CreateEditTaskPage has a form, two buttons and '
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
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => TaskFilterDateProvider()),
            ChangeNotifierProvider(create: (context) => SelectedPageProvider()),
          ],
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MaterialApp(
              navigatorKey: navigatorKey,
              home: CreateEditTaskPage(
                taskCreateService: mockTaskCreateService,
                taskEditService: mockTaskEditService,
              ),
            ),
          ),
        )
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

    testWidgets('When the save button is pressed and the fields are empty '
        'it does not call TaskCreateService and '
        'validation messages are shown', (tester) async {
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

      expect(find.text('Please enter a task name.'), findsOneWidget);
      verifyNever(mockTaskCreateService.createTask(any, any, any, any));
    });

    testWidgets("Given no task when all fields are valid createTask is called "
        "and it navigates to homepage", (tester) async {
      const taskNameExpected = "Some task";
      const detailsExpected = "Some details";

      when(mockTaskCreateService.createTask(taskNameExpected, any, any, detailsExpected)).thenAnswer((_) => Future(() => "1"));

      await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => TaskFilterDateProvider()),
              ChangeNotifierProvider(create: (context) => SelectedPageProvider()),
            ],
            child:  Directionality(
              textDirection: TextDirection.ltr,
              child: MaterialApp(
                home: CreateEditTaskPage(
                  taskCreateService: mockTaskCreateService,
                  taskEditService: mockTaskEditService,
                  taskListService: mockTaskListService,
                  taskDeleteService: mockTaskDeleteService,
                ),
              ),
            ),
          )
      );

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
      const taskId = "1";
      const taskName = "Some task";
      const details = "Some details";
      final startTimestamp = DateTime.now();
      final endTimestamp = DateTime(startTimestamp.year, startTimestamp.month,
          startTimestamp.day, startTimestamp.hour + 1);
      const updatedDetails = "Some new details";


      await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => TaskFilterDateProvider()),
              ChangeNotifierProvider(create: (context) => SelectedPageProvider()),
            ],
            child:  Directionality(
              textDirection: TextDirection.ltr,
              child: MaterialApp(
                home: CreateEditTaskPage(
                  taskCreateService: mockTaskCreateService,
                  taskEditService: mockTaskEditService,
                  taskListService: mockTaskListService,
                  taskDeleteService: mockTaskDeleteService,
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
