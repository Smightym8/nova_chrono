import 'package:flutter_test/flutter_test.dart';
import 'package:nova_chrono/application/api/task_edit_service.dart';
import 'package:nova_chrono/application/impl/task_edit_service_impl.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/infrastructure/task_repository_impl.dart';

import '../../utils/test_database_provider.dart';

void main() {
  group("TaskEditService Integration Tests", () {
    late TestDatabaseProvider testDatabaseProvider;
    late TaskRepository taskRepository;
    late TaskEditService taskEditService;

    setUp(() async {
      testDatabaseProvider = TestDatabaseProvider.instance;
      await testDatabaseProvider.initDatabase();

      taskRepository = TaskRepositoryImpl(database: testDatabaseProvider.database);
      taskEditService = TaskEditServiceImpl(taskRepository: taskRepository);
    });

    tearDown(() async {
      await testDatabaseProvider.closeDatabase();
      await testDatabaseProvider.deleteDatabase();
    });

    test("Given task when update then task is updated", () async {
      // Given
      var taskOriginal = Task(
          "1",
          "Task 1",
          DateTime(2023, 1, 20, 14, 30),
          DateTime(2023, 1, 20, 15, 00),
          ""
      );

      var updatedStartTimestamp = DateTime(2023, 1, 20, 13, 30);
      var updatedEndTimestamp = DateTime(2023, 1, 20, 14, 00);
      var updatedDetails = "Some details for task 1";

      // When
      await taskEditService.editTask(
          taskOriginal.id,
          taskOriginal.name,
          updatedStartTimestamp,
          updatedEndTimestamp,
          updatedDetails
      );

      // Then
      var updatedTask = await taskRepository.getById(taskOriginal.id);
      expect(updatedTask, isNot(null));
      expect(updatedTask!.id, taskOriginal.id);
      expect(updatedTask.name, taskOriginal.name);
      expect(updatedTask.startTimestamp, updatedStartTimestamp);
      expect(updatedTask.endTimestamp, updatedEndTimestamp);
      expect(updatedTask.details, updatedDetails);

      expect(updatedTask.startTimestamp, isNot(taskOriginal.startTimestamp));
      expect(updatedTask.endTimestamp, isNot(taskOriginal.endTimestamp));
      expect(updatedTask.details, isNot(taskOriginal.details));
    });
  });
}