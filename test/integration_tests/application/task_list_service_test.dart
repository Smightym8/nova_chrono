import 'package:flutter_test/flutter_test.dart';
import 'package:nova_chrono/application/api/task_list_service.dart';
import 'package:nova_chrono/application/impl/task_list_service_impl.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/infrastructure/task_repository_impl.dart';

import '../../utils/test_database_provider.dart';

void main() {
  group("TaskListService Integration Tests", () {
    late TestDatabaseProvider testDatabaseProvider;
    late TaskRepository taskRepository;
    late TaskListService taskListService;

    setUp(() async {
      testDatabaseProvider = TestDatabaseProvider.instance;
      await testDatabaseProvider.initDatabase();

      taskRepository = TaskRepositoryImpl(database: testDatabaseProvider.database);
      taskListService = TaskListServiceImpl(taskRepository: taskRepository);
    });

    tearDown(() async {
      await testDatabaseProvider.deleteDatabase();
    });

    test("Given date when getByDate then expected tasks are returned", () async {
      // Given
      var date = DateTime(2023, 1, 22);
      var tasksExpected = <Task>[
        Task("3", "Task 3", DateTime(2023, 1, 22, 08, 00),
            DateTime(2023, 1, 22, 10, 00), "Some Details for task 3"),
        Task("4", "Task 4", DateTime(2023, 1, 22, 10, 00),
            DateTime(2023, 1, 22, 12, 00), "Some Details for task 4"),
      ];

      // When
      var tasksActual = await taskListService.getTasksByDate(date);

      // Then
      expect(tasksActual.length, tasksExpected.length);
      for (var i = 0; i < tasksExpected.length; i++) {
        var taskExpected = tasksExpected[i];
        var taskActual = tasksActual[i];

        expect(taskActual, taskExpected);
      }
    });
  });
}