import '../../../domain/model/common_task_name.dart';
import '../../../domain/repository/common_task_name_repository.dart';
import '../../../main.dart';
import '../../api/common_task_name/common_task_name_create_service.dart';

class CommonTaskNameCreateServiceImpl implements CommonTaskNameCreateService {
  late CommonTaskNameRepository _commonTaskNameRepository;

  CommonTaskNameCreateServiceImpl({CommonTaskNameRepository? commonTaskNameRepository}) {
    _commonTaskNameRepository = commonTaskNameRepository ?? getIt<CommonTaskNameRepository>();
  }

  @override
  Future<void> createCommonTaskName(String name) async {
    String id = _commonTaskNameRepository.nextIdentity();

    var commonTaskName = CommonTaskName(id, name);

    await _commonTaskNameRepository.add(commonTaskName);
  }
}