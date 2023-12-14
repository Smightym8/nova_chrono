abstract class TaskCreateService {
  void createTask(String taskName, DateTime startTimestamp, DateTime endTimestamp,
      String? details);
}