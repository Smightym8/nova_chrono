import 'package:mockito/mockito.dart';
import 'package:nova_chrono/application/api/task/task_create_service.dart';
import 'package:nova_chrono/application/impl/task/task_create_service_impl.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/encryption_repository.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/injection_container.dart';
import 'package:test/test.dart';

import '../../mocks/annotations.mocks.dart';
import '../unit_test_injection_container.dart';

void main() {
  group('TaskCreateService Unit Tests', () {
    late TaskCreateService taskCreateService;
    late MockTaskRepository mockTaskRepository;
    late MockEncryptionRepository mockEncryptionRepository;

    setUpAll(() {
      initializeMockDependencies();

      mockTaskRepository = getIt<TaskRepository>() as MockTaskRepository;
      mockEncryptionRepository = getIt<EncryptionRepository>() as MockEncryptionRepository;
      taskCreateService = TaskCreateServiceImpl();
    });

    test(
        'given id, taskName, startTimestamp and endTimestamp. When calling '
        'taskCreateService.createTask then mockTaskRepository.add is called', () {
      // Given
      const id = '1';
      const taskName = 'Test Task';
      final startTimestamp = DateTime.now();
      final endTimestamp = startTimestamp.add(const Duration(hours: 1));
      final taskExpected = Task(id, taskName, startTimestamp, endTimestamp, '');

      when(mockTaskRepository.nextIdentity()).thenReturn(id);
      when(mockEncryptionRepository.encrypt(taskName)).thenReturn(taskName);
      when(mockEncryptionRepository.encrypt('')).thenReturn('');

      // When
      taskCreateService.createTask(taskName, startTimestamp, endTimestamp, null);

      // Then
      verify(mockTaskRepository.add(taskExpected));
    });

    test('given taskName, startTimestamp, endTimestamp and details. When calling '
        'taskCreateService.createTask then mockTaskRepository.add is called', () {
      // Given
      const id = '0';
      const taskName = 'Test Task';
      final startTimestamp = DateTime.now();
      final endTimestamp = startTimestamp.add(const Duration(hours: 1));
      const details = 'Some details';
      final taskExpected =
          Task(id, taskName, startTimestamp, endTimestamp, details);

      when(mockTaskRepository.nextIdentity()).thenReturn(id);
      when(mockEncryptionRepository.encrypt(taskName)).thenReturn(taskName);
      when(mockEncryptionRepository.encrypt(details)).thenReturn(details);

      // When
      taskCreateService.createTask(taskName, startTimestamp, endTimestamp, details);

      // Then
      verify(mockTaskRepository.add(taskExpected));
    });
  });
}