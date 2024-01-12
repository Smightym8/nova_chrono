abstract class TaskCreateService {
  Future<String> createTask(String taskName, DateTime startTimestamp, DateTime endTimestamp,
      String? details);
}