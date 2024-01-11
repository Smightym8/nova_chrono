import 'package:flutter_test/flutter_test.dart';
import 'package:nova_chrono/application/api/task/task_create_service.dart';
import 'package:nova_chrono/application/impl/task/task_create_service_impl.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/infrastructure/task_repository_impl.dart';

import '../../../integration_test/test_database_provider.dart';

void main() {
  group("TaskCreateService Integration Tests", () {
    late TestDatabaseProvider testDatabaseProvider;
    late TaskRepository taskRepository;
    late TaskCreateService taskCreateService;

    setUp(() async {
      testDatabaseProvider = TestDatabaseProvider.instance;
      await testDatabaseProvider.initDatabase();

      taskRepository = TaskRepositoryImpl(database: testDatabaseProvider.database);
      taskCreateService = TaskCreateServiceImpl(taskRepository: taskRepository);
    });

    tearDown(() async {
      await testDatabaseProvider.closeDatabase();
      await testDatabaseProvider.deleteDatabase();
    });

    test('given id, taskName, startTimestamp and endTimestamp. When createTask '
            'then task is created', () async {
      // Given
      const nameExpected = 'Test Task';
      final startTimestampExpected = DateTime.now();
      final endTimestampExpected = startTimestampExpected.add(const Duration(hours: 1));

      // When
      var taskId = await taskCreateService.createTask(
          nameExpected,
          startTimestampExpected,
          endTimestampExpected,
          null
      );

      // Then
      var taskActual = await taskRepository.getById(taskId);
      expect(taskActual, isNot(null));
      expect(taskActual?.name, nameExpected);
      expect(taskActual?.startTimestamp, startTimestampExpected);
      expect(taskActual?.endTimestamp, endTimestampExpected);
      expect(taskActual?.details, '');
    });

    test('given id, taskName, startTimestamp, endTimestamp and details. '
        'When createTask then task is created', () async {
      // Given
      const nameExpected = 'Test Task';
      final startTimestampExpected = DateTime.now();
      final endTimestampExpected = startTimestampExpected.add(const Duration(hours: 1));
      const detailsExpected = "Some details";

      // When
      var taskId = await taskCreateService.createTask(
          nameExpected,
          startTimestampExpected,
          endTimestampExpected,
          detailsExpected
      );

      // Then
      var taskActual = await taskRepository.getById(taskId);
      expect(taskActual, isNot(null));
      expect(taskActual?.name, nameExpected);
      expect(taskActual?.startTimestamp, startTimestampExpected);
      expect(taskActual?.endTimestamp, endTimestampExpected);
      expect(taskActual?.details, detailsExpected);
    });
  });
}