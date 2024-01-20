import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nova_chrono/infrastructure/database_provider/database_provider.dart';
import 'package:nova_chrono/injection_container.dart';
import 'package:nova_chrono/main.dart';
import 'package:nova_chrono/view/pages/home_page.dart';
import 'package:nova_chrono/view/providers/selected_page_provider.dart';
import 'package:nova_chrono/view/providers/task_filter_date_provider.dart';
import 'package:provider/provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Edit task flow test", () {
    setUp(() async {
      await getIt<DatabaseProvider>().initDatabase();
    });

    tearDown(() async {
      await getIt<DatabaseProvider>().closeDatabase();
      await getIt<DatabaseProvider>().deleteDatabase();
    });

    testWidgets("Given task in task list when editing task the information "
        "of the task are updated", (tester) async {
      await tester.runAsync(() async {
        const taskNameExpected = "Test Task";
        const detailsExpected = "Details for the test task";

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => TaskFilterDateProvider()),
              ChangeNotifierProvider(create: (context) => SelectedPageProvider()),
            ],
            child: const App(),
          ),
        );

        await Future.delayed(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        final editInkWellFinder = find.widgetWithIcon(
            InkWell,
            Icons.edit
        ).first;

        await tester.tap(editInkWellFinder);

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