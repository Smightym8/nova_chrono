import 'package:flutter_test/flutter_test.dart';
import 'package:nova_chrono/application/api/task/task_create_service.dart';
import 'package:nova_chrono/domain/repository/encryption_repository.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/infrastructure/database_provider/database_provider.dart';
import 'package:nova_chrono/injection_container.dart';

void main() {
  group("TaskCreateService Integration Tests", () {
    late TaskRepository taskRepository;
    late TaskCreateService taskCreateService;

    setUpAll(() async {
      await initializeDependencies(isTesting: true, isIntegrationTesting: true);
    });

    setUp(() async {
      await getIt<DatabaseProvider>().initDatabase();

      taskRepository = getIt<TaskRepository>();
      taskCreateService = getIt<TaskCreateService>();
    });

    tearDown(() async {
      await getIt<DatabaseProvider>().closeDatabase();
      await getIt<DatabaseProvider>().deleteDatabase();
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

      var decryptedTaskName = getIt<EncryptionRepository>().decrypt(taskActual!.name);
      var decryptedDetails = getIt<EncryptionRepository>().decrypt(taskActual.details);

      expect(decryptedTaskName, nameExpected);
      expect(taskActual.startTimestamp, startTimestampExpected);
      expect(taskActual.endTimestamp, endTimestampExpected);
      expect(decryptedDetails, '');
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

      var decryptedTaskName = getIt<EncryptionRepository>().decrypt(taskActual!.name);
      var decryptedDetails = getIt<EncryptionRepository>().decrypt(taskActual.details);

      expect(decryptedTaskName, nameExpected);
      expect(taskActual.startTimestamp, startTimestampExpected);
      expect(taskActual.endTimestamp, endTimestampExpected);
      expect(decryptedDetails, detailsExpected);
    });
  });
}