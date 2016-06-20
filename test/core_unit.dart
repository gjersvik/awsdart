library awsdart_core_unit;

import 'package:test/test.dart';
import 'package:awsdart/core.dart';

part 'src/core/aws.dart';
part 'src/core/sign.dart';
part 'src/core/utils.dart';

main() {
  awsTest();
  signTest();
  utilsTest();
}
