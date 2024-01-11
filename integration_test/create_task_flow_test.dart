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
import 'package:nova_chrono/view/pages/home_page.dart';
import 'package:nova_chrono/view/providers/task_filter_date_provider.dart';
import 'package:provider/provider.dart';

import 'test_database_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Creating task flow test", () {
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

    testWidgets("When a task is created the task appears in the task list"
        " on the homepage", (tester) async {
      await tester.runAsync(() async {
        const taskNameExpected = "Test Task";
        const detailsExpected = "Details for the test task";

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => TaskFilterDateProvider()),
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