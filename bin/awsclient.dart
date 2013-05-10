import 'dart:crypto';
import 'dart:utf';
import 'package:intl/intl.dart';

final DateFormat AWSDATE = new DateFormat('yyyyMMdd');

class AwsKey{
  String key = '';
  DateTime date;
  String region = '';
  String service = '';
  AwsKey():date = new DateTime.now();
  
  String toString(){
    List<int> hash = encodeUtf8('AWS4'+ key).toList();
    hash = _hmac(hash,AWSDATE.format(date));
    hash = _hmac(hash,region);
    hash = _hmac(hash,service);
    hash = _hmac(hash,'aws4_request');
    return CryptoUtils.bytesToHex(hash);
  }
  
  List<int> _hmac(List<int> key,String data){
    var hmac = new HMAC(new SHA256(),key);
    hmac.add(encodeUtf8(data));
    return hmac.close();
  }
}


void main() {
  AwsKey key = new AwsKey();
  key.key = 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY';
  key.date = new DateTime(2012,2,15);
  key.region = 'us-east-1';
  key.service = 'iam';
  
  print('f4780e2d9f65fa895f9c67b32ce1baf0b0d8a43505a000a1a9e090d414db404d');
  print(key);
}
