part of awsdart_unit;

signTest() => group('Sign',(){
  Sign sign;
  
  setUp((){
    sign = new Sign('AKIAIOSFODNN7EXAMPLE',
        'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY');
  });
  
  tearDown((){
    sign = null;
  });
  
  test('test getKey',(){
    var req = new Request();
    req.region = 'us-east-1';
    req.service = 'iam';
    req.time = new DateTime.utc(2011, 09, 09);
    
  });
});