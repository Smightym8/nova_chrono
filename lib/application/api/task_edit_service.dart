abstract class TaskEditService {
  void editTask(String taskId, String taskName, DateTime startTimestamp,
      DateTime endTimestamp, String? details);
}
