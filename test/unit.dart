library awsdart_unit;

import 'package:unittest/vm_config.dart';
import 'core_unit.dart' as core;
import 'io_unit.dart' as io;

main(){
  useVMConfiguration();
  core.main();
  io.main();
}