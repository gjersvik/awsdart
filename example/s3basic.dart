import 'dart:convert';
import 'package:awsdart/io.dart';

// Import key infomation. Edit this file if you want to run the exampel.
import 'keys.dart';

main(){
  // settups the AWS apis with the dart:io based backend.
  setupAwsIO();
  
  Aws aws = new Aws(accessKey: ACSSES_KEY, secretKey: SECRET_KEY);
  
  //It will in most cases infer region from the url.
  aws.request(Uri.parse('https://s3.amazonaws.com/')).then((Response res){
    print(res.statusCode);
    print(res.headers);
    print(UTF8.decode(res.body));
  });
}