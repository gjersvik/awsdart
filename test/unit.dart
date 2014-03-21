library amazone_dart_unit;

import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';

import 'package:amazone_dart/amazone_dart.dart';

part 'src/aws.dart';

main(){
  useVMConfiguration();
  awsTest();
}