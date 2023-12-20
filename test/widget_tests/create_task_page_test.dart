import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/view/pages/create_task_page.dart';
import 'package:nova_chrono/view/pages/home_page.dart';

import '../mocks/annotations.mocks.dart';

void main() {
  group('CreateTaskPage Tests', () {
    const title = 'NovaChrono';
    late MockTaskCreateService mockTaskCreateService;

    setUp(() {
      mockTaskCreateService = MockTaskCreateService();
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
          builder: (context) => const HomePage(title: title)));

      // Tap on the button
      await tester.tap(find.byKey(const Key('cancelButton')),
          warnIfMissed: false);

      // Trigger a frame
      await tester.pumpAndSettle();

      // Verify that the navigation occurred by checking the presence of a widget on the next page
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets(
        'When the save button is pressed and the fields are empty '
        'it does not call TaskCreateService', (tester) async {
      final GlobalKey<NavigatorState> navigatorKey =
          GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            navigatorKey: navigatorKey,
            home: CreateTaskPage(
              title: title,
              taskCreateService: mockTaskCreateService,
            ),
          ),
        ),
      );

      navigatorKey.currentState!.push(MaterialPageRoute(
          builder: (context) => const HomePage(title: title)));

      // Tap on the button
      await tester.tap(find.byKey(const Key('saveButton')),
          warnIfMissed: false);

      // Trigger a frame
      await tester.pumpAndSettle();

      verifyNever(mockTaskCreateService.createTask(any, any, any, any));
    });

    testWidgets(
        'When the save button is pressed and the end timestamp is before '
        'the start timestamp it stays on the page and does not call '
        'TaskCreateService', (tester) async {
      // TODO: Find out how to simulate selecting date and time
    });

    testWidgets(
        'When the save button is pressed and all values are valid '
        'TaskCreateService is called', (tester) async {
      // TODO: Implement
      // TODO: Find out how to simulate selecting date and time
    });
  });
}
