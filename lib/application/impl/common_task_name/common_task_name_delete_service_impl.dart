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
    await _commonTaskNameRepository.deleteCommonTaskName(id);
  }

}