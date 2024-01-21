import 'package:mockito/annotations.dart';
import 'package:nova_chrono/application/api/common_task_name/common_task_name_delete_service.dart';
import 'package:nova_chrono/application/api/common_task_name/common_task_name_list_service.dart';
import 'package:nova_chrono/application/api/task/task_create_service.dart';
import 'package:nova_chrono/application/api/task/task_delete_service.dart';
import 'package:nova_chrono/application/api/task/task_edit_service.dart';
import 'package:nova_chrono/application/api/task/task_list_service.dart';
import 'package:nova_chrono/domain/repository/common_task_name_repository.dart';
import 'package:nova_chrono/domain/repository/encryption_repository.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';

// TODO: Change to GenerateNiceMocks
@GenerateMocks([
  TaskRepository,
  EncryptionRepository,
  TaskCreateService,
  TaskListService,
  TaskEditService,
  TaskDeleteService,
  CommonTaskNameRepository,
  CommonTaskNameListService,
  CommonTaskNameDeleteService
])
void main() {}
