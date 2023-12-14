import 'package:nova_chrono/domain/model/task.dart';

abstract class TaskRepository {
  void add(Task task);
}