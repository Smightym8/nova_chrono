import 'package:mockito/annotations.dart';
import 'package:nova_chrono/application/api/task/task_create_service.dart';
import 'package:nova_chrono/application/api/task/task_delete_service.dart';
import 'package:nova_chrono/application/api/task/task_edit_service.dart';
import 'package:nova_chrono/application/api/task/task_list_service.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';

@GenerateMocks([TaskRepository])
@GenerateMocks([TaskCreateService])
@GenerateMocks([TaskListService])
@GenerateMocks([TaskEditService])
@GenerateMocks([TaskDeleteService])
void main() {}
