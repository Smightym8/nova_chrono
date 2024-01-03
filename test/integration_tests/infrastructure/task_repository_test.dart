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
  });
}