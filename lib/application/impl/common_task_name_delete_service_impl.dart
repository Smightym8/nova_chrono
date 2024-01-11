import 'package:nova_chrono/application/api/common_task_name_delete_service.dart';
import 'package:nova_chrono/domain/repository/common_task_name_repository.dart';

import '../../main.dart';

class CommonTaskNameDeleteServiceImpl implements CommonTaskNameDeleteService {
  late CommonTaskNameRepository _commonTaskNameRepository;

  CommonTaskNameDeleteServiceImpl({CommonTaskNameRepository? commonTaskNameRepository}) {
    _commonTaskNameRepository = commonTaskNameRepository ?? getIt<CommonTaskNameRepository>();
  }

  @override
  Future<void> deleteCommonTaskName(String id) async {
    await _commonTaskNameRepository.deleteCommonTaskName(id);
  }

}