library sign2test;

import 'package:unittest/unittest.dart';
import 'package:amazone_dart/amazone_dart.dart';


void main(){
  group('Sign2:', () {
    test('The sign string must contain &Version=2009-03-31', () {
      fail('Not Implmented');
    });
    test('The sign string must contain &SignatureVersion=2', () {
      fail('Not Implmented');
    });
    test('The sign string must contain &SignatureMethod=HmacSHA256', () {
      fail('Not Implmented');
    });
    test('The sign string must contain &AWSAccessKeyId=x were x is the passed accessKey', () {
      fail('Not Implmented');
    });
    test('The sign string must contain &Timestamp=x, were x is url ecoded UTC datetime. 0000-00-00T00:00:00', () {
      fail('Not Implmented');
    });
    test('The sign string must contain &SignatureMethod=HmacSHA256', () {
      fail('Not Implmented');
    });
    test('The sign string must contain &Signature=x, were x is the correct siganture', () {
      fail('Not Implmented');
    });
  });
}