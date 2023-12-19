import 'package:get_it/get_it.dart';
import 'package:nova_chrono/application/api/task_create_service.dart';
import 'package:nova_chrono/application/impl/task_create_service_impl.dart';
import 'package:nova_chrono/domain/repository/task_repository.dart';
import 'package:nova_chrono/infrastructure/task_repository_impl.dart';

final GetIt getIt = GetIt.instance;

void registerServices() {
  // TODO: Get rid of this and use only generated mocks in tests
  getIt.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl());
  getIt.registerLazySingleton<TaskCreateService>(() => TaskCreateServiceImpl());
}
