import 'package:mockito/annotations.dart';
import 'package:nova_chrono/application/api/task_create_service.dart';
import 'package:nova_chrono/application/api/task_list_service.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';

@GenerateMocks([TaskRepository])
@GenerateMocks([TaskCreateService])
@GenerateMocks([TaskListService])
void main() {}
