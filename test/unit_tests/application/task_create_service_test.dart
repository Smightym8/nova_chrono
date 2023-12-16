import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nova_chrono/application/api/task_create_service.dart';
import 'package:nova_chrono/application/impl/task_create_service_impl.dart';
import 'package:nova_chrono/domain/model/task.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:test/test.dart';

import '../../mocks/task_create_service_tests.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  group('TaskCreateService Tests', () {
    late TaskCreateService taskCreateService;
    late MockTaskRepository mockTaskRepository;

    setUp(() {
      mockTaskRepository = MockTaskRepository();
      taskCreateService = TaskCreateServiceImpl(taskRepository: mockTaskRepository);
    });

    test('given taskName, startTimestamp and endTimestamp. When calling '
        'taskCreateService.createTask then mockTaskRepository.add is called', () {
      // Given
      const taskName = 'Test Task';
      final startTimestamp = DateTime.now();
      final endTimestamp = startTimestamp.add(const Duration(hours: 1));
      final taskExpected = Task(taskName, startTimestamp, endTimestamp, '');

      // When
      taskCreateService.createTask(taskName, startTimestamp, endTimestamp, null);

      // Then
      verify(mockTaskRepository.add(taskExpected));
    });

    test('given taskName, startTimestamp, endTimestamp and details. When calling '
        'taskCreateService.createTask then mockTaskRepository.add is called', () {
      // Given
      const taskName = 'Test Task';
      final startTimestamp = DateTime.now();
      final endTimestamp = startTimestamp.add(const Duration(hours: 1));
      const details = 'Some details';
      final taskExpected = Task(taskName, startTimestamp, endTimestamp, details);

      // When
      taskCreateService.createTask(taskName, startTimestamp, endTimestamp, details);

      // Then
      verify(mockTaskRepository.add(taskExpected));
    });
  });
}