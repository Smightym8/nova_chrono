import 'package:nova_chrono/injection_container.dart';

import 'create_task_flow_test.dart' as create_task_flow_test;
import 'delete_task_flow_test.dart' as delete_task_flow_test;
import 'edit_task_flow_test.dart' as edit_task_flow_test;

Future<void> main() async {
  await initializeDependencies(isTesting: true);

  create_task_flow_test.main();
  edit_task_flow_test.main();
  delete_task_flow_test.main();
}