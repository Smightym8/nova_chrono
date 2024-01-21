import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nova_chrono/infrastructure/database_provider/database_provider.dart';
import 'package:nova_chrono/injection_container.dart';
import 'package:nova_chrono/main.dart';
import 'package:nova_chrono/view/pages/home_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Creating task flow test", () {
    setUp(() async {
      await getIt<DatabaseProvider>().initDatabase();
    });

    tearDown(() async {
      await getIt<DatabaseProvider>().closeDatabase();
      await getIt<DatabaseProvider>().deleteDatabase();
    });

    testWidgets("When a task is created the task appears in the task list"
        " on the homepage", (tester) async {
      await tester.runAsync(() async {
        const taskNameExpected = "Test Task";
        const detailsExpected = "Details for the test task";

        await tester.pumpWidget(const App());

        await Future.delayed(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        var createEditTaskPageFloatingActionButtonFinder = find.byKey(const Key("createEditTaskPageFloatingActionButton"));
        await tester.tap(createEditTaskPageFloatingActionButtonFinder);

        await tester.pumpAndSettle();

        var taskNameTextFieldFinder = find.byKey(const Key("taskNameTextField"));
        await tester.enterText(taskNameTextFieldFinder, taskNameExpected);

        var detailsTextFieldFinder = find.byKey(const Key("detailsTextField"));
        await tester.enterText(detailsTextFieldFinder, detailsExpected);

        var saveButtonFinder = find.byKey(const Key('saveButton'));
        await tester.ensureVisible(saveButtonFinder);
        await tester.tapAt(tester.getCenter(saveButtonFinder));

        await Future.delayed(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        await Future.delayed(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        expect(find.byType(HomePage), findsOne);
        expect(find.text(taskNameExpected), findsOne);
        expect(find.text(detailsExpected), findsOne);
      });
    });
  });
}