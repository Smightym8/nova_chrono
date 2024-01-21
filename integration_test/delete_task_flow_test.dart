import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nova_chrono/infrastructure/database_provider/database_provider.dart';
import 'package:nova_chrono/injection_container.dart';
import 'package:nova_chrono/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Deleting task flow test", () {
    setUp(() async {
      await getIt<DatabaseProvider>().initDatabase();
    });

    tearDown(() async {
      await getIt<DatabaseProvider>().closeDatabase();
      await getIt<DatabaseProvider>().deleteDatabase();
    });

    testWidgets("Given at least one task in the task list when deleting a task "
        "the task is not in the list anymore", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(const App());

        await Future.delayed(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        final deleteInkWellFinder = find.widgetWithIcon(
            InkWell,
            Icons.delete_forever
        ).first;

        // To prove that task is there
        expect(find.text("Task 1"), findsOne);

        await tester.tap(deleteInkWellFinder);

        await Future.delayed(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        // First task in the list during test is always Task 1
        expect(find.text("Task 1"), findsNothing);
      });
    });
  });
}