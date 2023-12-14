import '../api/task_create_service.dart';

class TaskCreateServiceImpl implements TaskCreateService {
  @override
  void createTask(String taskName, String startTimestamp, String endTimestamp,
      String? details) {
    // TODO: Save task
    print('Task name: $taskName\nStart: $startTimestamp'
        '\nEnd: $endTimestamp\nDetails: $details');
  }
}