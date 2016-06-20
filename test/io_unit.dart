library awsdart_io_unit;

import 'package:test/test.dart';
import 'package:awsdart/io.dart';

part 'src/io/io_requester.dart';
part 'src/io/setup_aws_io.dart';

main() {
  setupAwsIOTest();
  ioRequesterTest();
}
