import 'package:flutter_test/flutter_test.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/infrastructure/task_repository_impl.dart';

import '../../utils/test_database_provider.dart';

void main() {
  group("TaskRepository tests", () {
    late TestDatabaseProvider testDatabaseProvider;
    late TaskRepository taskRepository;

    setUp(() async {
      testDatabaseProvider = TestDatabaseProvider.instance;
      await testDatabaseProvider.initDatabase();

      taskRepository = TaskRepositoryImpl(database: testDatabaseProvider.database);
    });

    tearDown(() async {
      await testDatabaseProvider.deleteDatabase();
    });

    test("Given task when add then expected task is saved in database", () async {
      // Given
      String taskId = taskRepository.nextIdentity();
      Task taskExpected = Task(
          taskId, "Test", DateTime.now(), DateTime.now(), "Some details"
      );

      // When
      await taskRepository.add(taskExpected);

      // Then
      Task? taskActual = await taskRepository.getById(taskId);
      expect(taskActual, taskExpected);
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
      var tasksActual = await taskRepository.getByDate(date);

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