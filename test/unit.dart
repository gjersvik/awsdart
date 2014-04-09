library awsdart_unit;

import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';

import 'package:awsdart/awsdart.dart';
import 'package:awsdart/core.dart';
import 'core_unit.dart' as core;


part 'src/io_requester.dart';

main(){
  useVMConfiguration();
  core.main();
  ioRequesterTest();
}