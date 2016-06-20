import 'dart:convert';
import 'package:awsdart/io.dart';

// Import key infomation. Edit this file if you want to run the exampel.
import 'keys.dart';

main() {
  // settup the AWS library with the dart:io based backend.
  setupAwsIO();

  Aws aws = new Aws(accessKey: ACSSES_KEY, secretKey: SECRET_KEY);

  var bucket = 'YOUR_BUCKET_NAME';

  //It will in most cases infer region from the url.
  aws
      .request(Uri.parse('http://${bucket}.s3.amazonaws.com/'),
          service: 's3', region: 'us-west-2')
      .then((Response res) {
    print(res.statusCode);
    print(res.headers);
    print(UTF8.decode(res.body));
  });
}
