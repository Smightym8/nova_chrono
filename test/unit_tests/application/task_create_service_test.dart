import 'package:mockito/mockito.dart';
import 'package:nova_chrono/application/api/task_create_service.dart';
import 'package:nova_chrono/application/impl/task_create_service_impl.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:test/test.dart';

import '../../mocks/annotations.mocks.dart';

void main() {
  group('TaskCreateService Tests', () {
    late TaskCreateService taskCreateService;
    late MockTaskRepository mockTaskRepository;

    setUp(() {
      mockTaskRepository = MockTaskRepository();
      taskCreateService = TaskCreateServiceImpl(taskRepository: mockTaskRepository);
    });

    test(
        'given id, taskName, startTimestamp and endTimestamp. When calling '
        'taskCreateService.createTask then mockTaskRepository.add is called', () {
      // Given
      const id = '0';
      const taskName = 'Test Task';
      final startTimestamp = DateTime.now();
      final endTimestamp = startTimestamp.add(const Duration(hours: 1));
      final taskExpected = Task(id, taskName, startTimestamp, endTimestamp, '');

      when(mockTaskRepository.nextIdentity()).thenReturn(id);

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

      // When
      taskCreateService.createTask(taskName, startTimestamp, endTimestamp, details);

      // Then
      verify(mockTaskRepository.add(taskExpected));
    });
  });
}