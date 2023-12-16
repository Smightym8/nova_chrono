import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:nova_chrono/application/api/task_create_service.dart';
import 'package:nova_chrono/view/pages/create_task_page.dart';
import 'package:nova_chrono/view/pages/home_page.dart';

import '../test_setup.dart';

@GenerateMocks([TaskCreateService])
void main() {
  registerServices();

  const title = 'NovaChrono';

  testWidgets('HomePage has a title and a floatingActionButton',
      (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: MaterialApp(
          home: HomePage(title: title),
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
      const Directionality(
        textDirection: TextDirection.ltr,
        child: MaterialApp(
          home: HomePage(title: title),
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
