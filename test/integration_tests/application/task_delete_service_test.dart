import 'package:flutter_test/flutter_test.dart';
import 'package:nova_chrono/application/api/task_delete_service.dart';
import 'package:nova_chrono/application/impl/task_delete_service_impl.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/infrastructure/task_repository_impl.dart';

import '../../utils/test_database_provider.dart';

void main() {
  group("TaskDeleteService Integration Tests", () {
    late TestDatabaseProvider testDatabaseProvider;
    late TaskRepository taskRepository;
    late TaskDeleteService taskDeleteService;

    setUp(() async {
      testDatabaseProvider = TestDatabaseProvider.instance;
      await testDatabaseProvider.initDatabase();

      taskRepository = TaskRepositoryImpl(database: testDatabaseProvider.database);
      taskDeleteService = TaskDeleteServiceImpl(taskRepository: taskRepository);
    });

    tearDown(() async {
      await testDatabaseProvider.deleteDatabase();
    });

    test("Given taskId when calling deleteTask then task is deleted", () async {
      // Given
      String taskId = "1";

      // When
      await taskDeleteService.deleteTask(taskId);

      // Then
      Task? deletedTask = await taskRepository.getById(taskId);
      expect(deletedTask, null);
    });
  });
}