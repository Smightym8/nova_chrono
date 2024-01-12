import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nova_chrono/application/api/task/task_create_service.dart';
import 'package:nova_chrono/application/api/task/task_delete_service.dart';
import 'package:nova_chrono/application/api/task/task_edit_service.dart';
import 'package:nova_chrono/application/api/task/task_list_service.dart';
import 'package:nova_chrono/application/impl/task/task_create_service_impl.dart';
import 'package:nova_chrono/application/impl/task/task_delete_service_impl.dart';
import 'package:nova_chrono/application/impl/task/task_edit_service_impl.dart';
import 'package:nova_chrono/application/impl/task/task_list_service_impl.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/infrastructure/task_repository_impl.dart';
import 'package:nova_chrono/main.dart';
import 'package:nova_chrono/view/providers/selected_page_provider.dart';
import 'package:nova_chrono/view/providers/task_filter_date_provider.dart';
import 'package:provider/provider.dart';

import 'test_database_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Deleting task flow test", () {
    late TestDatabaseProvider testDatabaseProvider;
    late TaskRepository taskRepository;
    late TaskListService taskListService;
    late TaskCreateService taskCreateService;
    late TaskEditService taskEditService;
    late TaskDeleteService taskDeleteService;

    setUp(() async {
      testDatabaseProvider = TestDatabaseProvider.instance;
      await testDatabaseProvider.initDatabase();

      taskRepository = TaskRepositoryImpl(database: testDatabaseProvider.database);
      taskListService = TaskListServiceImpl(taskRepository: taskRepository);
      taskCreateService = TaskCreateServiceImpl(taskRepository: taskRepository);
      taskEditService = TaskEditServiceImpl(taskRepository: taskRepository);
      taskDeleteService = TaskDeleteServiceImpl(taskRepository: taskRepository);
    });

    tearDown(() async {
      await testDatabaseProvider.deleteDatabase();
    });

    testWidgets("Given at least one task in the task list when deleting a task "
        "the task is not in the list anymore", (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => TaskFilterDateProvider()),
              ChangeNotifierProvider(create: (context) => SelectedPageProvider()),
            ],
            child: App(
              taskCreateService: taskCreateService,
              taskListService: taskListService,
              taskEditService: taskEditService,
              taskDeleteService: taskDeleteService,
            ),
          ),
        );

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