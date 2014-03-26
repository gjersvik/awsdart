library awsdart_unit;

import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';

import 'package:awsdart/awsdart.dart';

part 'src/aws.dart';
part 'src/io_requester.dart';
part 'src/sign.dart';
part 'src/signature.dart';
part 'src/utils.dart';

main(){
  useVMConfiguration();
  
  awsTest();
  ioRequesterTest();
  signTest();
  signatureTest();
  utilsTest();
}