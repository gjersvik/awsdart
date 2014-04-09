library awsdart_io;

import 'dart:async';
import 'dart:io';

import 'package:awsdart/core.dart';
export 'package:awsdart/core.dart';

part 'src/io/io_requester.dart';

setupAwsIO(){
  Aws.requester = new IoRequester().request;
}
