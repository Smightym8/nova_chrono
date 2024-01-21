import 'package:nova_chrono/application/api/exception/common_task_name_not_found_exception.dart';
import 'package:nova_chrono/domain/repository/common_task_name_repository.dart';

import '../../../injection_container.dart';
import '../../api/common_task_name/common_task_name_delete_service.dart';

class CommonTaskNameDeleteServiceImpl implements CommonTaskNameDeleteService {
  late CommonTaskNameRepository _commonTaskNameRepository;

  CommonTaskNameDeleteServiceImpl() {
    _commonTaskNameRepository = getIt<CommonTaskNameRepository>();
  }

  @override
  Future<void> deleteCommonTaskName(String id) async {
    var commonTaskName = await _commonTaskNameRepository.getById(id);

    if (commonTaskName == null) {
      throw CommonTaskNameNotFoundException('Common task name with id $id not found');
    }

    await _commonTaskNameRepository.deleteCommonTaskName(id);
  }
}