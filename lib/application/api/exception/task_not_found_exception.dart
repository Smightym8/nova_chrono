class TaskNotFoundException implements Exception {
  String cause;
  TaskNotFoundException(this.cause);
}