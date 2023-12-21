import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nova_chrono/view/pages/create_task_page.dart';
import 'package:nova_chrono/view/pages/home_page.dart';

import '../mocks/annotations.mocks.dart';

void main() {
  const title = 'NovaChrono';
  late MockTaskCreateService mockTaskCreateService;

  setUp(() {
    mockTaskCreateService = MockTaskCreateService();
  });

  testWidgets('HomePage has a title and a floatingActionButton',
      (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MaterialApp(
          home: HomePage(
            title: title,
            taskCreateService: mockTaskCreateService,
          ),
        ),
      ),
    );

    final titleFinder = find.text(title);
    final floatingActionButtonFinder = find.byType(FloatingActionButton);

    expect(titleFinder, findsOneWidget);
    expect(floatingActionButtonFinder, findsOneWidget);
  });

  testWidgets(
      'When the FloatingActionButton is pressed it navigates to '
      'CreateTaskPage', (WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MaterialApp(
          home: HomePage(
            title: title,
            taskCreateService: mockTaskCreateService,
          ),
        ),
      ),
    );

    // Tap on the floating action button
    await tester.tap(find.byType(FloatingActionButton));

    // Trigger a frame
    await tester.pumpAndSettle();

    // Verify that the navigation occurred by checking the presence of a widget on the next page
    expect(find.byType(CreateTaskPage), findsOneWidget);
  });
}
