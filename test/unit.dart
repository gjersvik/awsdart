library awsdart_unit;

import 'package:unittest/vm_config.dart';
import 'core_unit.dart' as core;
import 'io_unit.dart' as io;
import 'dynamodb_service_unit.dart' as dynamodb_service;

main(){
  useVMConfiguration();
  core.main();
  io.main();
  dynamodb_service.main();
}